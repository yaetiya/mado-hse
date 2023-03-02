import mongoose, { model, Schema } from "mongoose";

export enum EAllowedEmoji {
    fire = 'fire',
    like = 'like',
    whale = 'whale'
}

export interface IEmoji {
    userIds: mongoose.Types.ObjectId[],
    emoji: EAllowedEmoji;
    postId: mongoose.Types.ObjectId
}


const emojiSchema = new Schema<IEmoji>(
    {
        userIds: [{
            type: mongoose.Schema.Types.ObjectId,
            ref: 'user'
        }],
        postId: {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'mobile-app-feed-element'
        },
        emoji: { type: String, enum: EAllowedEmoji },

    },
    { timestamps: true }
)

export const Emoji = model<IEmoji>('emoji', emojiSchema)
