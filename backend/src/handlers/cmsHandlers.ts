import { FastifyReply, FastifyRequest, FastifySchema } from 'fastify'
import { SocialNetwork, SocialNetworkSwaggerModel } from '../cms/models/socialNetworkModel'

export type EmptyInputT = {
}
export type CreateSocialNetworkInputT = {
    Body: {
        title: string,
        url: string,
        iconPath: string,
    }
}
export const createSocialNetworkSchema = {
    schema: {
        description: 'Create social network',
        tags: ['CMS'],
        body: {
            description: 'create social network',
            type: 'object',
            properties: {
                title: { type: 'string' },
                url: { type: 'string' },
                iconPath: { type: 'string' },
            }
        },
        response: {
            200: SocialNetworkSwaggerModel,
        },
    } as FastifySchema,
}
export const getSocialNetworksSchema = {
    schema: {
        description: 'Get social networks',
        tags: ['CMS'],
        response: {
            200: {
                description: 'Success Response',
                type: 'array',
                items: SocialNetworkSwaggerModel,
            },
        },
    } as FastifySchema,
}
const getSocialNetworks = async (req: FastifyRequest<EmptyInputT>, res: FastifyReply) => {
    const result = (await SocialNetwork.find().exec())
    res.send(result)
}
const addSocialNetwork = async (req: FastifyRequest<CreateSocialNetworkInputT>, res: FastifyReply) => {
    SocialNetwork.create(req.body).then((c) => {
        res.send(c)
    })
}



export default {
    getSocialNetworks,
    addSocialNetwork
}