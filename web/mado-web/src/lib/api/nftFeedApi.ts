import config from "$lib/config"
import type { INftFeedElement } from "$lib/store/nftFeed"
import type { IUser } from "$lib/store/user"
import axios from "axios"


export default {
    getConfig: async (): Promise<{
        collectionTotalCount: number
        emoji: {
            name: string;
            symbol: string;
            bgColor: string;
            textColor: string;
        }[]
    }> => {
        const resp = await axios.get(config.apiUrl + '/feed/getConfig')
        return resp.data
    },
    getFeed: async (accessToken: string, collectionTotalCount: number, page: number, locale: string): Promise<INftFeedElement[]> => {
        const resp = await axios.get(config.apiUrl + '/feed/get', {
            headers: {
                Authorization: `Bearer ${accessToken}`,
                locale
            },
            params: {
                page,
                collectionTotalCount
            }
        })
        return resp.data
    }
}