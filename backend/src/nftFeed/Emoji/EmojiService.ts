import { EAllowedEmoji, Emoji } from "./EmojiModel";
import { Types } from 'mongoose';

class EmojiService {
    getEmojiDisplayConfiguration(emoji: EAllowedEmoji): {
        symbol: string;
        bgColor: string;
        textColor: string;
    } {
        switch (emoji) {
            case EAllowedEmoji.fire:
                return {
                    symbol: '🔥',
                    bgColor: '#FFEEDA',
                    textColor: '#FF8A00'
                }
            case EAllowedEmoji.whale:
                return {
                    symbol: '🐳',
                    bgColor: '#E9F0FF',
                    textColor: '#32A7C8'
                }
            case EAllowedEmoji.like:
                return {
                    symbol: '❤️',
                    bgColor: '#FFE1E1',
                    textColor: '#EA4C4C'
                }
        }
    }

    async createEmptyEmojiForPost(emoji: EAllowedEmoji, postId: Types.ObjectId) {
        const emojiEl = await Emoji.findOne({ emoji, postId }).exec();
        if (emojiEl) {
            return emojiEl;
        }
        const createdEmojiEl = await Emoji.create({
            postId,
            userIds: [],
            emoji
        })
        return createdEmojiEl;
    }
    async addEmoji(userId: Types.ObjectId, emoji: EAllowedEmoji, postId: Types.ObjectId) {
        const emojiEl = await Emoji.findOne({ emoji, postId }).exec();
        if (!emojiEl) {
            const createdEmojiEl = await Emoji.create({
                postId,
                userIds: [userId],
                emoji
            })
            return createdEmojiEl;
        }
        if (emojiEl.userIds.includes(userId)) return;
        emojiEl.userIds.push(userId)
        emojiEl.save();
        return emojiEl;
    }
    async removeEmoji(userId: Types.ObjectId, emoji: EAllowedEmoji, postId: Types.ObjectId) {
        const emojiEl = await Emoji.findOne({ emoji, postId }).exec();
        if (!emojiEl) return;
        if (!emojiEl.userIds.includes(userId)) return;
        emojiEl.userIds.splice(emojiEl.userIds.indexOf(userId), 1);
        emojiEl.save();
        return emojiEl;
    }
}

export default new EmojiService();