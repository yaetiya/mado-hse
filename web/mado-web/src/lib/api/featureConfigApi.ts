import config from "$lib/config"
import type { IFeatureConfig } from "$lib/store/runtimeData"
import axios from "axios"


export default {
    get: async (): Promise<IFeatureConfig> => {
        const resp = await axios.get(config.apiUrl + '/feature-config')
        return resp.data
    },
}