import { FastifyReply, FastifyRequest, FastifySchema } from 'fastify'
import mongoose from 'mongoose'
import { ELocales } from '../courses/models/course'
import { localeService } from '../courses/locale/localeService'
import { EAllowedEmoji, Emoji } from './Emoji/EmojiModel'
import EmojiService from './Emoji/EmojiService'
import MobileAppFeedService from './MobileAppFeed/MobileAppFeedService'
import TextGeneratorService from './TextGeneratorService'
import { EmptyInputT } from '../cms/cmsHandlers'
import { JwtAuthHandlerInputT } from '../user/userHandlers'

export type GetFeedElementsInputT = {
    Querystring: {
        page: number;
        collectionTotalCount: number;
    }
    Headers: {
        locale: string
    }
}

export type AddOrRemoveEmojiInputT = {
    Body: {
        postId: string;
        emoji: EAllowedEmoji
    }
}

export const addOrRemoveEmojiSchema = {
    schema: {
        tags: ['nft-feed'],
        description: 'Add/Remove emoji from post',
        body: {
            type: 'object',
            properties: {
                postId: { type: 'string' },
                emoji: { type: 'string' },
            },
        },
    } as FastifySchema,
}
const addEmojiHandler = async (req: FastifyRequest<AddOrRemoveEmojiInputT>, res: FastifyReply) => {
    const resp = await EmojiService.addEmoji(new mongoose.Types.ObjectId((req as unknown as JwtAuthHandlerInputT).user.payload.id),
        req.body.emoji,
        new mongoose.Types.ObjectId(req.body.postId))
    if (!resp) { res.status(400).send("err"); return; }
    res.send({
        emoji: resp.emoji,
        count: resp.userIds.length,
        isWithMyLike: true
    });
}
const removeEmojiHandler = async (req: FastifyRequest<AddOrRemoveEmojiInputT>, res: FastifyReply) => {
    const resp = await EmojiService.removeEmoji(new mongoose.Types.ObjectId((req as unknown as JwtAuthHandlerInputT).user.payload.id),
        req.body.emoji,
        new mongoose.Types.ObjectId(req.body.postId))
    if (!resp) { res.status(400).send("err"); return; }
    res.send({
        emoji: resp.emoji,
        count: resp.userIds.length,
        isWithMyLike: false
    });
}

export const getFeedElementsSchema = {
    schema: {
        description: 'Add push token',
        tags: ['nft-feed'],
        querystring: {
            type: 'object',
            properties: {
                page: { type: 'number' },
                collectionTotalCount: { type: 'number' },
            },
        },
        headers: {
            type: 'object',
            properties: {
                locale: {
                    type: 'string',
                    description: 'Locale',
                },
            },
            required: [],
        },
    } as FastifySchema,
}


export const getCurrentCollectionCountSchema = {
    schema: {
        description: 'Get emoji config & current collection elements count. (needed for correct pagination)',
        tags: ['nft-feed'],
    } as FastifySchema,
}

const getFeed = async (req: FastifyRequest<GetFeedElementsInputT>, res: FastifyReply) => {
    const locale = localeService.getLocale(req.headers.locale);

    const feedElements = await MobileAppFeedService.getFeedElements(req.query.page, req.query.collectionTotalCount);
    const emojis = await Emoji.find({
        postId: { $in: feedElements.map(x => x._id.toString()) }
    }).exec()
    const emojisMap = {}
    emojis.forEach(e => {
        const postId = e.postId.toString();
        if (!emojisMap[postId]) {
            emojisMap[postId] = []
        }
        emojisMap[postId].push({
            emoji: e.emoji,
            count: e.userIds.length,
            isWithMyLike: e.userIds.includes(new mongoose.Types.ObjectId((req as unknown as JwtAuthHandlerInputT).user.payload.id))
        })
    })
    res.send(feedElements.map(x => ({
        _id: x._id,
        mediaUrl: x.nftFeedToken.s3Path,
        postText: TextGeneratorService.generateTextForMobileApp(locale, x.event, {
            collection: x.nftFeedCollection,
            token: x.nftFeedToken
        }),
        contractAddress: x.event.contractAddress,
        tokenId: x.event.tokenId,
        price: x.event.amount,
        emojis: emojisMap[x._id.toString()]
    })))
}
const getFeedConfig = async (req: FastifyRequest<EmptyInputT>, res: FastifyReply) => {
    const collectionTotalCount = await MobileAppFeedService.getCurrentCount();
    res.send({
        collectionTotalCount,
        emoji: Object.values(EAllowedEmoji).map(e => ({
            name: e,
            ...EmojiService.getEmojiDisplayConfiguration(e)
        }))
    })
}

export default {
    getFeed,
    getFeedConfig,
    addEmojiHandler,
    removeEmojiHandler
}
