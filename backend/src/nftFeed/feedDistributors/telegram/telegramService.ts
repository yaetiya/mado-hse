import axios from 'axios';
import TelegramBot, { ParseMode } from 'node-telegram-bot-api';
import sharp from 'sharp';
import { configuration } from "../../../config/configuration";
import { EMediaTypes, IFeedDistributorService } from '../models';
class TelegramService implements IFeedDistributorService {
    bot: TelegramBot
    defaultOptions = {
        parse_mode: 'HTML' as ParseMode
    }
    constructor() {
        this.bot = new TelegramBot(configuration.nftFeed.tgBotSecret, { polling: true });
    };
    async sendAlert(msg) {
        await this.bot.sendMessage(configuration.nftFeed.errorLogsTgChannelId, msg, this.defaultOptions,)
    }
    async sendNewMessage(msg, media) {
        try {
            if (media) {
                const mediaContent = media.url
                if (media.type === EMediaTypes.img) {
                    await this.bot.sendPhoto(configuration.nftFeed.tgChannelId, mediaContent, { ...this.defaultOptions, caption: msg })
                } else if (media.type === EMediaTypes.video) {
                    const fileMetadata = await axios.get(mediaContent, { responseType: 'arraybuffer' })
                    const fileMetadataBuffer = Buffer.from(fileMetadata.data, "utf-8")
                    await this.bot.sendVideo(configuration.nftFeed.tgChannelId, fileMetadataBuffer, { ...this.defaultOptions, caption: msg, }, {
                        contentType: 'video/mp4'
                    })
                } else if (media.type === EMediaTypes.gif) {
                    await this.bot.sendAnimation(configuration.nftFeed.tgChannelId, mediaContent, { ...this.defaultOptions, caption: msg })
                }
            } else {
                await this.bot.sendMessage(configuration.nftFeed.tgChannelId, msg, this.defaultOptions,)
            }
        } catch (e) {
            console.error(e)
            console.error(media)
            this.sendAlert("err: " + media.url)
        }
    }
}
export default new TelegramService();