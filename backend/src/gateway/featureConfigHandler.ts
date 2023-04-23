import { FastifyReply, FastifyRequest } from "fastify";
import { configuration } from "../config/configuration";
import unleash from "../tools/unleash";
import { EmptyInputT } from "../cms/cmsHandlers";

const getFeatureConfig = async (req: FastifyRequest<EmptyInputT>, res: FastifyReply) => {
    res.send({
        isOnAppStoreCheck: unleash.isEnabled("is_on_app_store_check")
    })
}

export default {
    getFeatureConfig
}