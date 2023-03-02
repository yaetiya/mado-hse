require('dotenv').config()
import { assert } from "chai"
import { EMediaTypes } from "../../src/nftFeed/feedDistributors/models"
import telegramService from "../../src/nftFeed/feedDistributors/telegram/telegramService"
import strTools from "../../src/tools/strTools"

describe.skip('Telegram send messages', () => {

    const sendTestMsg = (done: any, url: string) =>
        telegramService.sendNewMessage('test msg', {
            type: strTools.getMediaType(url),
            url
        }).then(done).catch((e) => {
            done(e)
        })

    it('Send Image (png)', (done) => {
        sendTestMsg(done, 'https://madospace.ams3.digitaloceanspaces.com/prod/pufaj.png')
    })
    it('Send Image (jpg)', (done) => {
        sendTestMsg(done, 'https://madospace.ams3.digitaloceanspaces.com/prod/v5k3y.jpg')
    })
    it.skip('Send video (mp4)', (done) => {
        sendTestMsg(done, 'https://madospace.ams3.digitaloceanspaces.com/prod/12fy5h.mp4')
    })
    it('Send Image (webp)', (done) => {
        sendTestMsg(done, 'https://media1.giphy.com/media/x9hb4UHYiguplrU2Vv/giphy.webp')
    })
    it('Send Image (gif)', (done) => {
        sendTestMsg(done, 'https://media2.giphy.com/media/d9YwHqNXg8ISka05nl/giphy.gif')
    })
    it('Send Image (gif)', (done) => {
        sendTestMsg(done, 'https://madospace.ams3.digitaloceanspaces.com/prod/z2b55.gif')
    })
})
