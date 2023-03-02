import { EMediaTypes } from "../nftFeed/feedDistributors/models";

const getTagContent = (htmlString, tag) => {
    return htmlString.split(`<${tag}>`)[1].split(`</${tag}>`)[0]
}
const getFileFormat = (fileName: string) => {
    const a = fileName.split('.')
    return a[a.length - 1];
}
const getMediaType = (fileName: string) => {
    const format = getFileFormat(fileName);
    switch (format) {
        case 'png':
        case 'webp':
        case 'jpeg':
        case 'jpg':
            return EMediaTypes.img
        case 'gif':
            return EMediaTypes.gif
        case 'mp4':
            return EMediaTypes.video

        default:
            console.error("unknown format!!!")
            console.error(fileName)
            console.error(format)
            throw new Error("unknown format")
    }
}
export default {
    getTagContent,
    getFileFormat,
    getMediaType
}