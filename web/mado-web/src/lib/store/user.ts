import userApi from "$lib/api/userApi";
import { getCookie } from "$lib/tools/cookie";
import { get, writable } from "svelte/store";
export interface IUser {
    accessToken?: string;
    doneCourses?: string[];
    _id: string;
    isUnlocked?: boolean;
    locale?: string;
}
function createStore() {
    const userStore = writable<IUser | undefined>(undefined);
    const tryAuth = async () => {
        const accessToken = getCookie('access_token');
        if (accessToken) {
            userApi.me(accessToken).then((user) => {
                if (user) {
                    userStore.set({ ...user, accessToken });
                }
            }).catch((e) => {
                console.error(e);
                console.error('load user error');
            })
        }
    }
    const unlock = () => {
        const userState = get(userStore);
        if (!userState?.accessToken) return;
        userApi.requestUnlock(userState.accessToken).then((user) => {
            if (user) {
                userStore.set({ ...user, accessToken: userState.accessToken });
                try {
                    (window as any).MessageInvoker.postMessage('event/unlocked')
                } catch {
                    console.error('no mobile app')
                }
            }
        }).catch((e) => {
            console.error(e);
            console.error('unlock error');
        })
    }
    return {
        subscribe: userStore.subscribe,
        unlock,
        tryAuth
    }
}

export const _user = createStore();