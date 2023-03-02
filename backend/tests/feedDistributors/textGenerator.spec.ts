require('dotenv').config()
import { assert } from "chai"
import { EMediaTypes } from "../../src/nftFeed/feedDistributors/models"
import TextGeneratorService from "../../src/nftFeed/TextGeneratorService"
import TelegramService from "../../src/nftFeed/feedDistributors/telegram/telegramService"
import strTools from "../../src/tools/strTools"
import { EEventTypes } from "../../src/nftFeed/nftFeedService"

describe.skip('Text Generator', () => {


    it('Send Image (png)', (done) => {
        const tokenMetadata = {
            collection: {
                contractAddress: '0x5985ED7bce4bEA12433f130D73354C07FF038914',
                title: 'STORM',
                symbol: 'STR'
            },
            token: {
                tokenId: '7',
                contractAddress: '0x5985ED7bce4bEA12433f130D73354C07FF038914',
                s3Path: 'https://madospace.ams3.digitaloceanspaces.com/dev1/7h9mjxn4yg.mp4',
                description: 'STORM is a series of digital animations that draws inspiration from the winter storms of the Pacific North West. Using a digital moiré technique, each animation interprets atmospheric forces (rain, wind, ice & snow) as kinetic, pixelated abstractions /// STORM 7, 1620 x 960 pixels, 170 frames, 25 fps, Nicolas Sassoon, 2021',
                title: 'S T O R M 7'
            }
        }
        // const text = TextGeneratorService.generateCaptionText({
        //     contractAddress: '0x5985ED7bce4bEA12433f130D73354C07FF038914',
        //     tokenId: '7',
        //     type: EEventTypes.AuctionFinalized,
        //     amount: '2',
        //     buyer: '0x0'
        // }, tokenMetadata)
        // telegramService.sendNewMessage(text, {
        //     url: tokenMetadata.token.s3Path,
        //     type: EMediaTypes.video
        // })
    })

})
