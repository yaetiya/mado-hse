import mongoose from "mongoose";
import { EAllowedEmoji } from "../Emoji/EmojiModel";
import EmojiService from "../Emoji/EmojiService";
import { IMobileAppFeedElement, IMobileAppFeedElementPopulated, MobileAppFeedElement } from "./MobileAppFeedModels";
class MobileAppFeedService {
    pageSize = 10

    async addFeedElement(mobileAppFeedElement: IMobileAppFeedElement) {
        const el = await MobileAppFeedElement.create(mobileAppFeedElement)
        const amount = parseFloat(mobileAppFeedElement.event.amount)
        const emojiList = [(amount >= 2 && EAllowedEmoji.whale), (amount < 2 && amount >= 1 && EAllowedEmoji.fire), EAllowedEmoji.like]
        emojiList.filter(x => x).forEach((x: EAllowedEmoji) => {
            EmojiService.createEmptyEmojiForPost(x, el._id)
        })
        return el;
    }
    async getFeedElements(page: number, querySessionTotalElementsCount: number): Promise<IMobileAppFeedElementPopulated[]> {
        const currentElementsCount = await MobileAppFeedElement.count().exec();
        const baseElementOffset = currentElementsCount - querySessionTotalElementsCount;
        const offset = baseElementOffset + page * this.pageSize, limit = this.pageSize
        return MobileAppFeedElement.find().sort({ _id: -1 }).skip(offset).limit(limit).populate(['nftFeedToken', 'nftFeedCollection']).exec() as never as IMobileAppFeedElementPopulated[];
    }
    getCurrentCount() {
        return MobileAppFeedElement.count().exec();
    }
}

export default new MobileAppFeedService();