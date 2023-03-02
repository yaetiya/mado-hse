import Joi from '@hapi/joi'
import axios from 'axios';

export const validationSchema = Joi.object({
    PORT: Joi.number().port().required(),
    MONGO_CLIENT_URI: Joi.string().required(),
    JWT_SECRET: Joi.string().required(),
    WC_SIGN_MESSAGE: Joi.string().required(),
    MODE: Joi.string().valid('dev', 'prod').required(),
    DO_SPACES_ENDPOINT: Joi.string().required(),
    DO_SPACES_KEY: Joi.string().required(),
    DO_SPACES_SECRET: Joi.string().required(),
    DO_SPACES_NAME: Joi.string().required(),
    DO_SUB_DIR: Joi.string().required(),
    BOT_TOKEN: Joi.string().required(),
    TG_CHANNEL_ID: Joi.string().required(),
    ERROR_LOGS_TG_CHANNEL_ID: Joi.string().required(),
    ALCHEMY_SIGN_KEY: Joi.string().required(),
})


const checkEnv = () => {
    axios.defaults.timeout = 15000;

    const validationRes = validationSchema.validate(process.env, {
        allowUnknown: true,
    })
    const resMessage = validationSchema.validate(process.env, {
        allowUnknown: true,
    })
    if (validationRes.error?.message) {
        console.error(resMessage)
        throw new Error(resMessage)
    }
    return {
        env: process.env.NODE_ENV,
        environment: process.env.ENVIRONMENT,
        // @ts-ignore
        port: parseInt(process.env.PORT, 10),
        db: {
            connectUrl: process.env.MONGO_CLIENT_URI as string,
        },
        isDev: process.env.MODE === 'dev',
        alchemyKey: process.env.ALCHEMY_SIGN_KEY as string,
        doSpace: {
            endpoint: process.env.DO_SPACES_ENDPOINT as string,
            key: process.env.DO_SPACES_KEY as string,
            secret: process.env.DO_SPACES_SECRET as string,
            name: process.env.DO_SPACES_NAME as string,
            subDir: process.env.DO_SUB_DIR as string
        },
        nftFeed: {
            tgBotSecret: process.env.BOT_TOKEN as string,
            tgChannelId: parseInt(process.env.TG_CHANNEL_ID as string),
            errorLogsTgChannelId: parseInt(process.env.ERROR_LOGS_TG_CHANNEL_ID as string)
        }
    }
}

export const configuration = checkEnv();
