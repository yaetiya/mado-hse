require('dotenv').config()
import {configuration} from './config/configuration'
import db from './db'
import {FastifyInstance} from 'fastify'
import {JwtAuthHandlerInputT} from './user/userHandlers'
import {balancesService} from './balances/service'
import {registerFastifies} from "./gateway/endpoints"
import {User, UserModelT, UserRoles} from './user/models/user'
import handleNftTxsService from './nftFeed/foundationApp/handleNftTxsService'

export const fastify: FastifyInstance = require('fastify')({
    logger: true,
})
registerFastifies(fastify);

db.init()
handleNftTxsService.main();
balancesService.initExchangeRates();
fastify.decorate('authenticate', async function (request, reply) {
    try {
        await request.jwtVerify()
        await User.updateOne({_id: (request as unknown as JwtAuthHandlerInputT).user.payload.id}, {$set: {lastActiveAt: new Date()}}).exec();
        if (request.headers.locale) {
            await User.updateOne({_id: (request as unknown as JwtAuthHandlerInputT).user.payload.id}, {$set: {locale: request.headers.locale}}).exec();
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

fastify.listen(configuration.port, '0.0.0.0', (error) => {
    if (error) {
        process.exit(1)
    }
})
