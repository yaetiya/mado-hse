
const emptyAccess = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwYXlsb2FkIjp7ImlkIjoiNjMxZjU3MjA2ZjcxZjkwM2VkMjU1MjhkIiwidG9rZW5UeXBlIjoidXNlciJ9LCJpYXQiOjE2NjI5OTgzMDR9.C-JQ46jOpKxCZGN3hSn_8azbYbqRZfIIxZHVz3GuD6k'
import featureConfigApi from "$lib/api/featureConfigApi";
import nftFeedApi from "$lib/api/nftFeedApi";
import getParam from "$lib/tools/getParam";
import axios from "axios";
import { get, writable } from "svelte/store";
import { _runtimeData } from "./runtimeData";
export interface INftFeedConfig {
    collectionTotalCount: number
    emoji: {
        name: string;
        symbol: string;
        bgColor: string;
        textColor: string;
    }[]
}
export interface INftFeedElement {
    _id: string;
    mediaUrl: string;
    postText: string;
    contractAddress: string;
    tokenId: string;
    price: string;
    emojis: [
        {
            emoji: string;
            count: number;
            isWithMyLike: boolean
        }
    ]
}
export interface INftFeed {
    nfts: INftFeedElement[]
    config: INftFeedConfig
}
export interface IFeatureConfig {
    isOnAppStoreCheck: boolean;
}
function createStore() {
    const { subscribe, set, update } = writable<INftFeed | null>(null);
    const init = async () => {
        const emojiConf = await nftFeedApi.getConfig()
        const nfts = await nftFeedApi.getFeed(emptyAccess, emojiConf.collectionTotalCount, 0, get(_runtimeData).locale)
        set({
            nfts,
            config: emojiConf
        })
    }
    return {
        subscribe,
        init
    }
}

export const _nftFeed = createStore();