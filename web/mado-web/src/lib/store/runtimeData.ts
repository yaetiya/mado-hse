import featureConfigApi from "$lib/api/featureConfigApi";
import getParam from "$lib/tools/getParam";
import { writable } from "svelte/store";
export interface IRuntimeData {
    locale: string;
    featureConfig?: IFeatureConfig;
}
export interface IFeatureConfig {
    isOnAppStoreCheck: boolean;
}
function createStore() {
    const { subscribe, set, update } = writable<IRuntimeData>({
        locale: 'en'
    });
    const init = () => {
        const locale = getParam.findGetParameter('locale') || 'en';
        update((data) => {
            return {
                ...data,
                locale
            }
        })
        featureConfigApi.get().then((c) => {
            update((data) => {
                return {
                    ...data,
                    featureConfig: c
                }
            })
        })
    }
    return {
        subscribe,
        init
    }
}

export const _runtimeData = createStore();