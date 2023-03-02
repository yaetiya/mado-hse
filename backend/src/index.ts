require('dotenv').config()
import { configuration } from './config/configuration'
import db from './db'
import { FastifyInstance } from 'fastify'
import userHandlers, { unlockUserSchema, addAddressHandlerInputT, addAddressSchema, addPushTokenHandlerInputT, addPushTokenSchema, getUserSchema, JwtAuthHandlerInputT, SignInHandlerInputT, signInSchema, SignUpHandlerInputT, signUpSchema } from './handlers/userHandlers'

export const fastify: FastifyInstance = require('fastify')({
    logger: true,
})
const authSchema = schema => ({
    onRequest: [(fastify as any).authenticate],
    ...schema
})
const adminOnlySchema = schema => ({
    onRequest: [(fastify as any).adminOnly],
    ...schema
})

import contentGeneratorHandler, { ContentGeneratorHandlerInputT, onCourseCompletedSchema, contentGeneratorSchema, getByIdGeneratorSchema, getByIdsGeneratorSchema, GetCourseHandlerInputT, GetCoursesHandlerInputT, onCourseCompletedInputT, LocaleBasedInputT, getRoadmapSchema } from './handlers/coursesHandler'
import balancesHandler, { GetBalancesHandlerInputT, getBalancesSchema } from './handlers/balancesHandler'
import { balancesService } from './balances/service'
import cmsHandlers, { CreateSocialNetworkInputT, createSocialNetworkSchema, EmptyInputT, getSocialNetworksSchema } from './handlers/cmsHandlers'
import { User, UserModelT, UserRoles } from './auth/models/user'
import projectsHandlers, { CreateProjectInputT, createProjectSchema, getProjectSchema } from './handlers/projectsHandlers'
import featureConfigHandler from './handlers/featureConfigHandler'
import handleNftTxsService from './nftFeed/foundationApp/handleNftTxsService'
import nftFeedHandler, { AddOrRemoveEmojiInputT, addOrRemoveEmojiSchema, getCurrentCollectionCountSchema, GetFeedElementsInputT, getFeedElementsSchema } from './handlers/nftFeedHandler'

// fastify.register(import('fastify-raw-body'), {
//     field: 'rawBody', // change the default request.rawBody property name
//     global: false, // add the rawBody to every request. **Default true**
//     encoding: 'utf8', // set it to false to set rawBody as a Buffer **Default utf8**
//     runFirst: true, // get the body before any preParsing hook change/uncompress it. **Default false**
//     routes: [] // array of routes, **`global`** will be ignored, wildcard routes not supported
// })
fastify.register(require('fastify-swagger'), {
    routePrefix: '/api/swagger',
    swagger: {
        info: {
            title: 'Mado API',
            description: 'Mado API',
            version: '0.1.0',
        },
        // url: 'https://mado.one/api',
        // host: configuration.isDev ? 'localhost:' + configuration.port : 'mado.one',
        // schemes: [configuration.isDev ? 'http' : 'https'],
        // endpointPath: configuration.isDev ? undefined : '/api',
        servers: [{
            url: 'https://mado.one/api',
            description: 'Production server'
        }],
        consumes: ['application/json'],
        produces: ['application/json'],
    },
    openapi: {
        security: [
            {
                bearerAuth: [],
            },
        ],
        components: {
            securitySchemes: {
                bearerAuth: {
                    type: 'http',
                    in: 'header',
                    scheme: 'bearer',
                    bearerFormat: 'JWT',
                },
            },
        },
    },
    exposeRoute: true,
})


db.init()
handleNftTxsService.main();
balancesService.initExchangeRates();
fastify.register(require('fastify-cors'), {
    origin: '*',
})
fastify.register(require('fastify-jwt'), {
    secret: process.env.JWT_SECRET as string,
})
fastify.decorate('authenticate', async function (request, reply) {
    try {
        await request.jwtVerify()
        await User.updateOne({ _id: (request as unknown as JwtAuthHandlerInputT).user.payload.id }, { $set: { lastActiveAt: new Date() } }).exec();
        if (request.headers.locale) {
            await User.updateOne({ _id: (request as unknown as JwtAuthHandlerInputT).user.payload.id }, { $set: { locale: request.headers.locale } }).exec();
        }
    } catch (err) {
        reply.send(err)
    }
})

fastify.decorate('adminOnly', async function (request, reply) {
    try {
        await request.jwtVerify()
        const user = (await User.findById((request as unknown as JwtAuthHandlerInputT).user.payload.id).exec()) as UserModelT
        if (!configuration.isDev && !user.roles.includes(UserRoles.Admin)) {
            throw new Error('User is not admin');
        }
    } catch (err) {
        reply.send(err)
    }
})

fastify.register((instance, opts, next) => {
    instance.post<SignInHandlerInputT>('/sign-in', signInSchema, userHandlers.signIn)
    instance.post<SignUpHandlerInputT>('/sign-up', signUpSchema, userHandlers.signUp)
    instance.get<GetCourseHandlerInputT>('/me', authSchema(getUserSchema), userHandlers.getUser)
    instance.get<GetBalancesHandlerInputT>('/balances', getBalancesSchema, balancesHandler.getBalances);
    instance.post<addAddressHandlerInputT>('/add-address', authSchema(addAddressSchema), userHandlers.addAddress)
    instance.post<addPushTokenHandlerInputT>('/notifications/add-token', authSchema(addPushTokenSchema), userHandlers.addPushToken)
    instance.post<EmptyInputT>('/unlock', authSchema(unlockUserSchema), userHandlers.unlockUser)

    instance.post<ContentGeneratorHandlerInputT>('/course/create-or-update', adminOnlySchema(contentGeneratorSchema), contentGeneratorHandler.createOrUpdate)
    instance.get<GetCourseHandlerInputT>('/course/get-by-id', getByIdGeneratorSchema, contentGeneratorHandler.getById)
    instance.get<GetCoursesHandlerInputT>('/course/get-by-ids', getByIdsGeneratorSchema, contentGeneratorHandler.getByIds)
    instance.get<LocaleBasedInputT>('/course/roadmap', getRoadmapSchema, contentGeneratorHandler.getRoadmap)
    instance.post<onCourseCompletedInputT>('/course/on-completed', authSchema(onCourseCompletedSchema), contentGeneratorHandler.onCourseCompleted)


    instance.post<CreateSocialNetworkInputT>('/cms/social-networks/create', adminOnlySchema(createSocialNetworkSchema), cmsHandlers.addSocialNetwork)
    instance.get<EmptyInputT>('/cms/social-networks/get', getSocialNetworksSchema, cmsHandlers.getSocialNetworks)

    instance.post<CreateProjectInputT>('/project/create', adminOnlySchema(createProjectSchema), projectsHandlers.createProject)
    instance.get<LocaleBasedInputT>('/project/get', authSchema(getProjectSchema), projectsHandlers.getProjects)

    instance.get<GetFeedElementsInputT>('/feed/get', authSchema(getFeedElementsSchema), nftFeedHandler.getFeed)
    instance.get<EmptyInputT>('/feed/getConfig', getCurrentCollectionCountSchema, nftFeedHandler.getFeedConfig)
    instance.post<AddOrRemoveEmojiInputT>('/feed/emoji', authSchema(addOrRemoveEmojiSchema), nftFeedHandler.addEmojiHandler)
    instance.delete<AddOrRemoveEmojiInputT>('/feed/emoji', authSchema(addOrRemoveEmojiSchema), nftFeedHandler.removeEmojiHandler)


    instance.get<LocaleBasedInputT>('/feature-config', featureConfigHandler.getFeatureConfig);
    instance.get('/', async function (req, res) {
        res.send('Mado api')
    })
    next()
}, { prefix: 'api' })


fastify.listen(configuration.port, '0.0.0.0', (error) => {
    if (error) {
        process.exit(1)
    }
})
