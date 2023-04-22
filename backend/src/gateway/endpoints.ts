require('dotenv').config()
import {FastifyInstance} from 'fastify'
import userHandlers, {
    addAddressHandlerInputT,
    addAddressSchema,
    addPushTokenHandlerInputT,
    addPushTokenSchema,
    getUserSchema,
    SignInHandlerInputT,
    signInSchema,
    SignUpHandlerInputT,
    signUpSchema,
    unlockUserSchema
} from '../handlers/userHandlers'
import contentGeneratorHandler, {
    ContentGeneratorHandlerInputT,
    contentGeneratorSchema,
    getByIdGeneratorSchema,
    getByIdsGeneratorSchema,
    GetCourseHandlerInputT,
    GetCoursesHandlerInputT,
    getRoadmapSchema,
    LocaleBasedInputT,
    onCourseCompletedInputT,
    onCourseCompletedSchema
} from '../handlers/coursesHandler'
import balancesHandler, {GetBalancesHandlerInputT, getBalancesSchema} from '../handlers/balancesHandler'
import cmsHandlers, {
    CreateSocialNetworkInputT,
    createSocialNetworkSchema,
    EmptyInputT,
    getSocialNetworksSchema
} from '../handlers/cmsHandlers'
import projectsHandlers, {
    CreateProjectInputT,
    createProjectSchema,
    getProjectSchema
} from '../handlers/projectsHandlers'
import featureConfigHandler from '../handlers/featureConfigHandler'
import nftFeedHandler, {
    AddOrRemoveEmojiInputT,
    addOrRemoveEmojiSchema,
    getCurrentCollectionCountSchema,
    GetFeedElementsInputT,
    getFeedElementsSchema
} from '../handlers/nftFeedHandler'

export function registerFastifies(fastify: FastifyInstance) {
    const authSchema = schema => ({
        onRequest: [(fastify as any).authenticate],
        ...schema
    })
    const adminOnlySchema = schema => ({
        onRequest: [(fastify as any).adminOnly],
        ...schema
    })
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

    fastify.register(require('fastify-cors'), {
        origin: '*',
    })
    fastify.register(require('fastify-jwt'), {
        secret: process.env.JWT_SECRET as string,
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
    }, {prefix: 'api'})
}