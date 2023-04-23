import mongoose, { model, Mongoose, Schema } from 'mongoose'
import { INftCollectionMetadataStorage, INftTokenStorage } from '../spaces/nftStorageModels'
import { EEventTypes, INftEvent } from '../nftFeedService'
import { Types } from 'mongoose';


export interface IMobileAppFeedElement {
    nftFeedCollection: mongoose.Types.ObjectId
    nftFeedToken: mongoose.Types.ObjectId
    event: INftEvent,
}
export interface IMobileAppFeedElementPopulated {
    _id: Types.ObjectId
    nftFeedCollection: INftCollectionMetadataStorage & { _id: Types.ObjectId };
    nftFeedToken: INftTokenStorage & { _id: Types.ObjectId }
    event: INftEvent,
}



const mobileAppFeedElementSchema = new Schema<IMobileAppFeedElement>(
    {
        nftFeedCollection: {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'nft-collection-metadata-storage'
        },
        nftFeedToken: {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'nft-token-storage'
        },
        event: {
            contractAddress: { type: String, },
            tokenId: { type: String, },
            type: { type: String, enum: EEventTypes, },
            amount: { type: String, },
            buyer: { type: String, },
        }
    },
    { timestamps: true }
)

export const MobileAppFeedElement = model<IMobileAppFeedElement>('mobile-app-feed-element', mobileAppFeedElementSchema)
