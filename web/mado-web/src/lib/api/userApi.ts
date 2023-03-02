import config from "$lib/config"
import type { IUser } from "$lib/store/user"
import axios from "axios"


export default {
    me: async (accessToken: string): Promise<IUser | void> => {
        const resp = await axios.get(config.apiUrl + '/me', {
            headers: {
                Authorization: `Bearer ${accessToken}`
            }
        })
        return resp.data
    },
    requestUnlock: async (accessToken: string): Promise<IUser | void> => {
        const resp = await axios.post(config.apiUrl + '/unlock', {}, {
            headers: {
                Authorization: `Bearer ${accessToken}`
            }
        })
        return resp.data
    }
}