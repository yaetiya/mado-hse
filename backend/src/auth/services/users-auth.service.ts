import mongoose, { Model } from 'mongoose'
import { ethWeb3 } from '../../tools/useWeb3'
import { IUser, User, UserAuthProvider, UserModelT, UserPlatforms, UserRoles } from '../models/user'
import { bufferToHex, ecrecover, isValidSignature, pubToAddress, toBuffer } from 'ethereumjs-util'
import { fastify } from '../..'



export enum TOKEN_TYPE {
    USER = 'user',
}
export interface AuthToken {
    accessToken: string
}

export interface JwtPayload {
    id: string
    tokenType: TOKEN_TYPE
}

const wcSignMessage = process.env.WC_SIGN_HASHED as string
export const UsersAuthService = {
    async signUp(platform: UserPlatforms) {
        const user = await this._createUser(platform)
        const token = await this.createUserToken(user)
        return {
            user,
            token,
        }
    },
    async signIn(address: string, signedMessage) {
        // 1. How to get sign
        // let secret = "0x..."
        // const msg = useWeb3.web3s.eth.utils.sha3('0xwelcometomado')
        // let sigObj = await useWeb3.web3s.eth.eth.accounts.sign(msg as string, secret)
        // console.error(sigObj.signature)
        const r = toBuffer(signedMessage.slice(0, 66))
        const s = toBuffer('0x' + signedMessage.slice(66, 130))
        const v = '0x' + signedMessage.slice(130, 132)
        // msg && console.log(web3.utils.stringToHex(msg))
        const publicKey = ecrecover(toBuffer(wcSignMessage), v, r, s)
        const addrBuf = pubToAddress(publicKey)
        const addressFromPublicKey = bufferToHex(addrBuf).toLowerCase();

        if (addressFromPublicKey !== address) throw new Error('Not match address. Invalid signature')

        const user = await this._createUser(UserPlatforms.Unknown, {
            address: address,
        })
        const token = await this.createUserToken(user)
        return {
            user,
            token,
        }
    },
    async createUserToken(user: UserModelT): Promise<AuthToken> {
        const token = await this.createJwtToken(user.id, TOKEN_TYPE.USER)
        return token
    },
    createJwtToken(id: string, tokenType: TOKEN_TYPE): AuthToken {
        const payload = { id, tokenType } as JwtPayload
        return {
            accessToken: (fastify as any).jwt.sign({ payload }),
        }
    },
    async _createUser(platform: UserPlatforms, userBase?: { address: string }): Promise<UserModelT> {
        if (!userBase) {
            const newUser = await User.create({
                lastAuthProvider: UserAuthProvider.FlashReg,
                doneCourses: [],
                roles: [UserRoles.User],
                isUnlocked: platform !== UserPlatforms.IOS,
            })
            return newUser;
        }
        const user = await User.findOne({
            where: {
                address: userBase.address,
            },
        })

        if (user?.address) {
            user.lastAuthProvider = UserAuthProvider.WC
            await user.save()
            return user
        }

        const data: IUser = {
            address: userBase.address,
            lastAuthProvider: UserAuthProvider.WC,
            doneCourses: [],
            roles: [UserRoles.User]
        }

        const newUser = await User.create(data)

        return newUser
    },
}
