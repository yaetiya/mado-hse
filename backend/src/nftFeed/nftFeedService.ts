import axios from "axios";
import nftMetadataStoringService from "./spaces/nftMetadataStoringService";
import strTools from "../tools/strTools";
import feedDistributors from "./feedDistributors";
import { EMediaTypes } from "./feedDistributors/models";
import telegramService from "./feedDistributors/telegram/telegramService";
import MobileAppFeedService from "./MobileAppFeed/MobileAppFeedService";
import TextGeneratorService from "./TextGeneratorService";

export enum EEventTypes {
    BidPlaced = 'BidPlaced', // new bid in auction
    BuyOffer = 'BuyOffer', // buy offer (not in auction)
    AuctionFinalized = 'AuctionFinalized' // Auction Finalized
}
export interface INftEvent {
    contractAddress: string;
    tokenId: string;
    type: EEventTypes;
    amount: string;
    buyer: string
}
const nftFeedService = {
    handleNftEvent: async (event: INftEvent) => {
        if (!event.amount || parseFloat(event.amount) < 0.1) return;

        const tokenMetadata = await nftMetadataStoringService.getTokenMetadata(event.contractAddress, event.tokenId.toString())
        const isImgOk = await nftFeedService.moderateImage(tokenMetadata.token.s3Path);
        if (!isImgOk) {
            telegramService.sendAlert('moderation failed ' + tokenMetadata.token.s3Path)
            return;
        }
        feedDistributors.forEach(x => {
            x.sendNewMessage(
                TextGeneratorService.generateCaptionTextHtml(event, tokenMetadata),
                {
                    url: tokenMetadata.token.s3Path,
                    type: strTools.getMediaType(tokenMetadata.token.s3Path)
                }
            )
        })
        if (strTools.getMediaType(tokenMetadata.token.s3Path) === EMediaTypes.video) return;
        MobileAppFeedService.addFeedElement({
            nftFeedCollection: tokenMetadata.collection._id,
            nftFeedToken: tokenMetadata.token._id,
            event
        })
    },
    moderateImage: async (s3Url) => {
        try {
            console.error('[m] moderation ', s3Url)
            if (strTools.getMediaType(s3Url) !== EMediaTypes.img) return true;

            const resp = await axios.get('https://nsfw-demo.sashido.io/api/image/classify?url=' + s3Url)
            const rates = {
                p: resp.data.find(x => x.className == "Porn").probability,
                neutral: resp.data.find(x => x.className == "Neutral").probability,
                s: resp.data.find(x => x.className == "Sexy").probability,
                drawing: resp.data.find(x => x.className == "Drawing").probability,
                h: resp.data.find(x => x.className == "Hentai").probability,
            }
            console.error(rates, s3Url)
            if (rates.p < 0.2 && rates.s < 0.4 && rates.neutral >= 0.5) return true;
            if (rates.h < 0.2 && rates.drawing >= 0.5) return true;
            return rates.h < 0.5 && rates.p < 0.4 && rates.s < 0.75
        } catch (e) {
            console.error(e)
            console.error('moderation err')
            telegramService.sendAlert('moderation err ' + s3Url)
        }
    }
}


export default nftFeedService