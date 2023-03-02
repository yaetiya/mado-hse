import mongoose, { model, Schema } from 'mongoose'
export interface ISocialNetwork {
    iconPath: string
    title: string
    url: string
}

export const SocialNetworkSwaggerModel = {
    description: 'Social Network',
    type: 'object',
    properties: {
        iconPath: { type: 'string' },
        title: { type: 'string' },
        url: { type: 'string' },
    },
}
const socialNetworkSchema = new Schema<ISocialNetwork>(
    {
        iconPath: { type: String },
        title: { type: String },
        url: { type: String },
    },
    { timestamps: true }
)

export const SocialNetwork = model<ISocialNetwork>('social-network', socialNetworkSchema)
export type SocialNetworkModelT = mongoose.Document<unknown, any, ISocialNetwork> &
    ISocialNetwork & {
        _id: mongoose.Types.ObjectId
    }
