import { configuration } from "../config/configuration";
import AWS from "aws-sdk";
import { Body } from "aws-sdk/clients/s3";
import strTools from "../tools/strTools";
import { EMediaTypes } from "../nftFeed/feedDistributors/models";
const spacesEndpoint = new AWS.Endpoint(configuration.doSpace.endpoint);
const s3 = new AWS.S3({
    endpoint: spacesEndpoint,
    accessKeyId: configuration.doSpace.key, secretAccessKey: configuration.doSpace.secret
});
const spacesService = {
    buildFullPathToFile: name => configuration.doSpace.subDir + '/' + name,
    getPublicUrl: name => `https://${configuration.doSpace.name}.${configuration.doSpace.endpoint}/${spacesService.buildFullPathToFile(name)}`,
    uploadFile: (fileBody: Body, name: string) =>
        new Promise((resolve, reject) => {
            s3.putObject({
                Bucket: configuration.doSpace.name, Key: spacesService.buildFullPathToFile(name), Body: fileBody, ACL: "public-read",
                ContentType: (strTools.getMediaType(name) === EMediaTypes.video ? 'video' : 'image') + "/" + strTools.getFileFormat(name)
            }, (err, data) => {
                if (err) {
                    reject(err);
                    return;
                }
                resolve(data)
            })
        }),
    generateRandomName: () =>
        (Math.random() + 1).toString(36).substring(2)


}
export default spacesService