import axios from "axios";
import { Types } from "mongoose";
import sharp from "sharp";
import { configuration } from "../../config/configuration";
import { EMediaTypes } from "../feedDistributors/models";
import { alchemy } from "../../tools/alchemy";
import strTools from "../../tools/strTools";
import { INftCollectionMetadataStorage, INftTokenStorage, NftCollectionMetadataStorage, NftTokenStorage } from "./nftStorageModels";
import spacesService from "./spacesService";

export interface INftMetadataWithIds {
    collection: INftCollectionMetadataStorage & { _id: Types.ObjectId };
    token: INftTokenStorage & { _id: Types.ObjectId };
}
const nftMetadataStoringService = {
    getTokenMetadata: async (contractAddress: string, tokenId: string): Promise<INftMetadataWithIds> => {
        const savedCollectionData = await NftCollectionMetadataStorage.findOne({
            contractAddress
        }).exec();
        if (savedCollectionData) {
            let token: INftTokenStorage & { _id: Types.ObjectId } | null = await NftTokenStorage.findOne({
                contractAddress,
                tokenId
            }).exec();
            if (!token) {
                token = await nftMetadataStoringService.createTokenMetadata(contractAddress, tokenId)
            }
            return {
                collection: savedCollectionData,
                token: token
            }
        } else {
            return nftMetadataStoringService.createCollectionMetadata(contractAddress, tokenId)
        }
    },
    createTokenMetadata: async (contractAddress: string, tokenId: string, fetchedTokenData?: {
        collection: INftCollectionMetadataStorage;
        token: Omit<INftTokenStorage, "s3Path"> & { ipfsGateway?: string };
    }): Promise<INftTokenStorage & { _id: Types.ObjectId }> => {
        if (!fetchedTokenData) {
            fetchedTokenData = await nftMetadataStoringService.fetchTokenMetadata(contractAddress, tokenId)
        }
        const mediaFileName = spacesService.generateRandomName() + '.' + (fetchedTokenData.token.rawGatewayFileFormat || strTools.getFileFormat(fetchedTokenData.token.ipfsPath as string));
        const fileMetadata = await axios.get(fetchedTokenData.token.ipfsGateway || fetchedTokenData.token.rawGateway || '', { responseType: 'arraybuffer' })
        const fileMetadataBuffer = Buffer.from(fileMetadata.data, "utf-8")
        const isVideo = (strTools.getMediaType(mediaFileName) === EMediaTypes.video) || (fetchedTokenData.token.rawGatewayFileFormat === 'mp4');
        const compressedFileMetadataBuffer = isVideo ? fileMetadataBuffer : await sharp(fileMetadataBuffer, {
            pages: -1
        })
            .resize(1200, 1200).toBuffer()
        await spacesService.uploadFile(compressedFileMetadataBuffer, mediaFileName)
        const resultTokenData = { ...fetchedTokenData.token, s3Path: spacesService.getPublicUrl(mediaFileName) }
        return await NftTokenStorage.create(resultTokenData)
    },
    createCollectionMetadata: async (contractAddress: string, tokenId: string): Promise<INftMetadataWithIds> => {
        const fetchedTokenData = await nftMetadataStoringService.fetchTokenMetadata(contractAddress, tokenId)
        return {
            collection: await NftCollectionMetadataStorage.create(fetchedTokenData.collection),
            token: await nftMetadataStoringService.createTokenMetadata(contractAddress, tokenId, fetchedTokenData)
        }
    },
    fetchTokenMetadata: async (contractAddress: string, tokenId: string): Promise<{
        collection: INftCollectionMetadataStorage,
        token: Omit<INftTokenStorage, "s3Path"> & { ipfsGateway?: string }
    }> => {
        const nftData = await alchemy.nft.getNftMetadata(
            contractAddress,
            tokenId
        )
        const nftCollectionData = await alchemy.nft.getContractMetadata(
            contractAddress,
        )
        return {
            collection: {
                contractAddress: nftData.contract.address,
                title: nftCollectionData.name,
                symbol: nftCollectionData.symbol,
            },
            token: {
                ipfsPath: nftData.media[0] && nftData.media[0].raw,
                tokenId,
                contractAddress: contractAddress,
                ipfsGateway: nftData.media[0] && nftData.media[0].gateway,
                rawGateway: nftData.rawMetadata?.animation_url,
                rawGatewayFileFormat: nftData.rawMetadata?.animation_details?.format ? nftData.rawMetadata.animation_details.format.toLowerCase() : undefined,

                title: nftData.title,
                description: nftData.description,
            }
        }
    }
}
export default nftMetadataStoringService;