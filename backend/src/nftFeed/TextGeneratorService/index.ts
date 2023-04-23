import { prices } from "../../balances/service";
import { ELocales } from "../../courses/models/course";
import { INftMetadataWithIds } from "../spaces/nftMetadataStoringService";
import { EEventTypes, INftEvent } from "../nftFeedService";

class TextGeneratorService {
    generateCaptionTextHtml(event: INftEvent, nftMetadata: INftMetadataWithIds): string {
        return [
            nftMetadata.collection.title,
            nftMetadata.collection.symbol && `($${nftMetadata.collection.symbol}).`,
            nftMetadata.token.title && `${nftMetadata.token.title}`,
            '\n' + this.#getTextActionFromEventType(event.type, ELocales.en),
            (parseFloat(event.amount) > 1) ? `<b>${event.amount} ETH</b>` : event.amount + ' ETH',
            `(${(prices.ethPrice * parseFloat(event.amount)).toFixed(2)}$)`,
            this.#getEmojiFromAmount(parseFloat(event.amount)),
            ((parseFloat(event.amount) > 1) && nftMetadata.collection.contractAddress && nftMetadata.token.tokenId) && `\n\n<a href='https://etherscan.io/nft/${nftMetadata.collection.contractAddress}/${nftMetadata.token.tokenId}'>View on Etherscan</a>`
        ].filter(x => !!x).join(' ')
    }
    generateTextForMobileApp(locale: ELocales, event: INftEvent, nftMetadata: INftMetadataWithIds) {
        return [
            nftMetadata.collection.title,
            nftMetadata.collection.symbol && `($${nftMetadata.collection.symbol}).`,
            nftMetadata.token.title && `${nftMetadata.token.title}`,
            '\n' + this.#getTextActionFromEventType(event.type, locale),
            event.amount + ' ETH',
            `(${(prices.ethPrice * parseFloat(event.amount)).toFixed(2)}$)`,
            this.#getEmojiFromAmount(parseFloat(event.amount)),
        ].filter(x => !!x).join(' ')
    }
    #getTextActionFromEventType(event: EEventTypes, locale: ELocales) {
        if (locale == ELocales.en) {
            switch (event) {
                case EEventTypes.AuctionFinalized:
                    return 'The Auction finished. The highest bid is'
                case EEventTypes.BidPlaced:
                    return 'New auction bid'
                case EEventTypes.BuyOffer:
                    return 'New buy offer'
                default:
                    break;
            }
        }
        if (locale == ELocales.ru) {
            switch (event) {
                case EEventTypes.AuctionFinalized:
                    return 'Аукцион завершен. Самая высокая ставка –'
                case EEventTypes.BidPlaced:
                    return 'Новая ставка на аукционе –'
                case EEventTypes.BuyOffer:
                    return 'Преложена новая цена покупки –'
                default:
                    break;
            }
        }
    }
    #getEmojiFromAmount(amount: number) {
        if (amount >= 20) return '😱🔥😱🔥😱🔥😱'
        if (amount >= 10) return '🔥🔥🔥'
        if (amount >= 1) return '😎'
        return ''
    }
}
export default new TextGeneratorService();