
export enum EMediaTypes {
    video, img, gif
}
export interface IFeedDistributorService {
    sendNewMessage: (msg: string, media?: {
        url: string;
        type: EMediaTypes
    }) => any
}