import { FastifyReply, FastifyRequest, FastifySchema } from 'fastify'
import { User, UserModelT } from '../auth/models/user'
import { IProject, Project, ProjectSwaggerModel } from '../cms/models/projectModel'
import { SocialNetwork, SocialNetworkSwaggerModel } from '../cms/models/socialNetworkModel'
import { ELocales } from '../courses/models/course'
import { EmptyInputT } from './cmsHandlers'
import { LocaleBasedInputT } from './coursesHandler'
import { JwtAuthHandlerInputT } from './userHandlers'
const projectsLockedList = ['Mado'
    // 'Explorer', 'Обозреватель'
]

export type CreateProjectInputT = {
    Body: IProject
}
export const createProjectSchema = {
    schema: {
        description: 'Create project',
        tags: ['Projects'],
        body: ProjectSwaggerModel,
        response: {
            200: ProjectSwaggerModel,
        },
    } as FastifySchema,
}
export const getProjectSchema = {
    schema: {
        headers: {
            type: 'object',
            properties: {
                locale: {
                    type: 'string',
                    description: 'Locale',
                },
                platform: {
                    type: 'string',
                    description: 'Platform',
                },
            },
            required: [],
        },

        description: 'Get projects',
        tags: ['Projects'],
        response: {
            200: {
                description: 'Success Response',
                type: 'array',
                items: ProjectSwaggerModel,
            },
        },
    } as FastifySchema,
}
const getProjects = async (req: FastifyRequest<LocaleBasedInputT>, res: FastifyReply) => {
    const user = (await User.findById((req as unknown as JwtAuthHandlerInputT).user.payload.id).exec()) as UserModelT
    const query: any = { locale: req.headers.locale || ELocales.en };
    if (!user.isUnlocked) {
        query.name = { $in: projectsLockedList }
    }
    const result = (await Project.find(query).exec())
    res.send(result);
}
const createProject = async (req: FastifyRequest<{
    Body: IProject
}>, res: FastifyReply) => {
    Project.create(req.body).then((c) => {
        res.send(c)
    })
}



export default {
    getProjects,
    createProject
}