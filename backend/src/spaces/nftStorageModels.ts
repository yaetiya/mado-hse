import mongoose, { model, Schema } from 'mongoose'

export interface INftCollectionMetadataStorage {
    contractAddress: string;
    title?: string;
    symbol?: string
}

export interface INftTokenStorage {
    s3Path: string;
    ipfsPath?: string;
    tokenId: string;
    contractAddress: string;
    description: string
    title: string;
    rawGateway?: string
    rawGatewayFileFormat?: string
}

const nftCollectionMetadataStorageSchema = new Schema<INftCollectionMetadataStorage>(
    {
        contractAddress: { type: String, index: { unique: true } },
        title: { type: String, required: false },
        symbol: { type: String, required: false },
    },
    { timestamps: true }
)

export const NftCollectionMetadataStorage = model<INftCollectionMetadataStorage>('nft-collection-metadata-storage', nftCollectionMetadataStorageSchema)


const nftTokenStorageSchema = new Schema<INftTokenStorage>(
    {
        s3Path: { type: String },
        ipfsPath: { type: String, required: false },
        rawGateway: { type: String, required: false },
        rawGatewayFileFormat: { type: String, required: false },
        tokenId: { type: String },
        contractAddress: { type: String },
        title: { type: String },
        description: { type: String, required: false },
    },
    { timestamps: true }
)

export const NftTokenStorage = model<INftTokenStorage>('nft-token-storage', nftTokenStorageSchema)
