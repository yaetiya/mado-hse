import { FastifyReply, FastifyRequest, FastifySchema } from 'fastify'
import { User, UserModelT, UserPlatforms, UserSwaggerModel } from '../auth/models/user'
import { JwtPayload, UsersAuthService } from '../auth/services/users-auth.service'
import { ethWeb3 } from '../tools/useWeb3'

export type SignInHandlerInputT = {
    Body: {
        address: string,
        signature: string
    }
}
export type addAddressHandlerInputT = {
    Body: {
        address: string,
    }
}
export type getUserHandlerInputT = {

}
export type addPushTokenHandlerInputT = {
    Body: {
        token: string,
    }
}
export type SignUpHandlerInputT = {
    Headers: {
        platform?: string,
    }
}
export type JwtAuthHandlerInputT = {
    user: {
        payload: JwtPayload
    }
}
export const addPushTokenSchema = {
    schema: {
        description: 'Add push token',
        tags: ['user'],
        body: {
            description: 'add push token',
            type: 'object',
            properties: {
                token: { type: 'string' },
            },
        },
        response: {
            200: UserSwaggerModel,
        },
    } as FastifySchema,
}
export const addAddressSchema = {
    schema: {
        description: 'Add address',
        tags: ['user'],
        body: {
            description: 'add address',
            type: 'object',
            properties: {
                address: { type: 'string' },
            },
        },
        response: {
            200: UserSwaggerModel,
        },
    } as FastifySchema,
}
export const unlockUserSchema = {
    schema: {
        description: 'Unlock user',
        tags: ['user'],
        response: {
            200: UserSwaggerModel,
        },
    } as FastifySchema,
}
export const getUserSchema = {
    schema: {
        description: 'Get userdata',
        tags: ['user'],
        response: {
            200: UserSwaggerModel,
        },
    } as FastifySchema,
}
export const signInSchema = {
    schema: {
        description: 'Sign in',
        tags: ['user'],
        body: {
            description: 'WC Sign In',
            type: 'object',
            properties: {
                address: { type: 'string' },
                signature: { type: 'string' },
            },
        },
        response: {
            200: {
                description: 'Success Response',
                type: 'object',
                properties: {
                    user: UserSwaggerModel,
                    token: {
                        type: 'object',
                        properties: {
                            accessToken: { type: 'string' },
                        },
                    },
                },
            },
        },
    } as FastifySchema,
}


export const signUpSchema = {
    schema: {
        description: 'Sign up',
        tags: ['user'],
        headers: {
            description: 'Sign up',
            type: 'object',
            required: [],
            properties: {
                platform: { type: 'string' },
            },
        },
        response: {
            200: {
                description: 'Success Response',
                type: 'object',
                properties: {
                    user: UserSwaggerModel,
                    token: {
                        type: 'object',
                        properties: {
                            accessToken: { type: 'string' },
                        },
                    },
                },
            },
        },
    } as FastifySchema,
}


const signIn = async (req: FastifyRequest<SignInHandlerInputT>, res: FastifyReply) => {
    const resp = await UsersAuthService.signIn(req.body.address.toLowerCase(), req.body.signature)
    res.send(resp)
}
const getUser = async (req: FastifyRequest<getUserHandlerInputT>, res: FastifyReply) => {
    const user = (await User.findById((req as unknown as JwtAuthHandlerInputT).user.payload.id).exec()) as UserModelT
    res.send(user)
}
const signUp = async (req: FastifyRequest<SignUpHandlerInputT>, res: FastifyReply) => {
    const platform = req.headers.platform ? req.headers.platform as UserPlatforms : UserPlatforms.Unknown
    const resp = await UsersAuthService.signUp(platform);
    res.send(resp)
}

const addPushToken = async (req: FastifyRequest<addPushTokenHandlerInputT>, res: FastifyReply) => {
    if (!req.body.token) {
        res.status(400).send({
            message: 'Invalid token',
        })
    }
    const user = (await User.findById((req as unknown as JwtAuthHandlerInputT).user.payload.id).exec()) as UserModelT
    user.pushToken = req.body.token;
    await user?.save();
    res.send(user);
}

const addAddress = async (req: FastifyRequest<addAddressHandlerInputT>, res: FastifyReply) => {
    if (!ethWeb3.utils.isAddress(req.body.address)) {
        res.status(400).send({
            message: 'Invalid address',
        })
        return;
    }
    const user = (await User.findById((req as unknown as JwtAuthHandlerInputT).user.payload.id).exec()) as UserModelT
    user.address = req.body.address;
    await user?.save();
    res.send(user);
}
const unlockUser = async (req: FastifyRequest, res: FastifyReply) => {
    const user = (await User.findById((req as unknown as JwtAuthHandlerInputT).user.payload.id).exec()) as UserModelT
    user.isUnlocked = true;
    await user?.save();
    res.send(user);
}
export default {
    signIn,
    signUp,
    addAddress,
    addPushToken,
    getUser,
    unlockUser
}
