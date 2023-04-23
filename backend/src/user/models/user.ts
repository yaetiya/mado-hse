import mongoose, { model, Schema } from 'mongoose'
export enum UserAuthProvider {
    WC = 'WC',
    FlashReg = 'FlashReg',
}
export enum UserPlatforms {
    Android = 'android',
    IOS = 'ios',
    Unknown = 'unknown',
}
export enum UserRoles {
    Admin = 'Admin',
    User = 'User',
}
export interface IUser {
    address: string
    lastAuthProvider: UserAuthProvider
    doneCourses: mongoose.Types.ObjectId[],
    roles: UserRoles[];
    pushToken?: string,
    lastActiveAt?: Date,
    locale?: string,
    isUnlocked?: boolean,
}

export const UserSwaggerModel = {
    description: 'User',
    type: 'object',
    required: ['_id', 'lastAuthProvider'],
    properties: {
        _id: { type: 'string' },
        address: { type: 'string' },
        lastAuthProvider: { type: 'string' },
        pushToken: { type: 'string' },
        locale: { type: 'string' },
        doneCourses: { type: 'array', items: { type: 'string' } },
        isUnlocked: { type: 'boolean' },
    },
}
const userSchema = new Schema<IUser>(
    {
        address: { type: String },
        pushToken: { type: String },
        lastAuthProvider: { type: String, enum: UserAuthProvider },
        doneCourses: [{
            type: mongoose.Schema.Types.ObjectId,
            ref: 'course'
        }],
        roles: [{
            type: String,
            enum: UserRoles,
            default: UserRoles.User
        }],
        lastActiveAt: Date,
        locale: { type: String },
        isUnlocked: {
            type: Boolean,
        },
    },
    { timestamps: true }
)

export const User = model<IUser>('user', userSchema)
export type UserModelT = mongoose.Document<unknown, any, IUser> &
    IUser & {
        _id: mongoose.Types.ObjectId
    }
