import { FastifyReply, FastifyRequest, FastifySchema } from 'fastify'
import { User, UserModelT, UserSwaggerModel } from '../user/models/user'
import { JwtPayload, UsersAuthService } from '../auth/services/users-auth.service'
import { balancesService } from './service'
import { ethWeb3 } from '../tools/useWeb3'

export type GetBalancesHandlerInputT = {
    Querystring: {
        address: string,
    }
}

export const getBalancesSchema = {
    schema: {
        description: 'Get balances',
        tags: ['user'],
        querystring: {
            type: 'object',
            properties: {
                address: { type: 'string' },
            },
        },
        response: {
            200: {
                type: 'object',
                properties: {
                    maticTestnet: { type: 'string' },
                    maticMainnet: { type: 'string' },
                    ethTestnet: { type: 'string' },
                    ethMainnet: { type: 'string' },
                    totalUsdBalance: { type: 'string' },
                }
            },
        },
    } as FastifySchema,
}
const getBalances = async (req: FastifyRequest<GetBalancesHandlerInputT>, res: FastifyReply) => {
    if (!ethWeb3.utils.isAddress(req.query.address)) {
        res.status(400).send({
            message: 'Invalid address',
        })
    }
    const balances = await balancesService.getBalances(req.query.address)
    res.send(balances);
}
export default {
    getBalances
}
