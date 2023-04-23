import { FastifyReply, FastifyRequest, FastifySchema } from 'fastify'
import mongoose from 'mongoose'
import { User } from '../user/models/user'
import { Course, CourseModelT, CoursePopulatedSwaggerModel, CourseSwaggerModel, ELocales, ICourse, IPart, Part, PartModelT } from './models/course'
import { notionToHtml } from './models/notionToHtml'
import { localeService } from './locale/localeService'
import strTools from '../tools/strTools'
import { JwtAuthHandlerInputT } from '../user/userHandlers'

export type ContentGeneratorHandlerInputT = {
    Body: {
        id?: string;
        pageId?: string,
        isDraft?: boolean,
        isNotReady?: boolean,
        order?: number,
        locale?: ELocales,
    }
}
export type LocaleBasedInputT = {
    Headers: {
        locale: string,
        platform?: string,
    }
}
export type GetCourseHandlerInputT = {
    Querystring: {
        id: string,
    }
}
export type onCourseCompletedInputT = {
    Body: {
        id: string,
    }
}
export type GetCoursesHandlerInputT = {
    Querystring: {
        ids: string[],
    }
}
export const getRoadmapSchema = {
    schema: {
        description: 'Get roadmap',
        tags: ['course'],
        headers: {
            type: 'object',
            properties: {
                locale: {
                    type: 'string',
                    description: 'Locale',
                },
            },
            required: [],
        },
        response: {
            200: {
                type: 'array',
                items: CourseSwaggerModel,
            },
        },
    } as FastifySchema,
}
export const contentGeneratorSchema = {
    schema: {
        description: 'Create course',
        tags: ['course'],
        body: {
            type: 'object',
            required: [],
            properties: {
                id: { type: 'string' },
                pageId: { type: 'string' },
                isDraft: { type: 'boolean', description: "drafts are hidden for the roadmap", default: false },
                isNotReady: { type: 'boolean', description: "soon flag", default: false },
                order: { type: 'number', description: "order in the roadmap" },
                locale: { type: 'string', description: "locale (en, ru..)" },
            },
        },
        response: {
            200: CoursePopulatedSwaggerModel,
        },
    } as FastifySchema,
}
export const getByIdGeneratorSchema = {
    schema: {
        description: 'Get course by Id',
        tags: ['course'],
        querystring: {
            type: 'object',
            properties: {
                id: { type: 'string' },
            },
        },
        response: {
            200: CoursePopulatedSwaggerModel,
        },
    } as FastifySchema,
}
export const onCourseCompletedSchema = {
    schema: {
        description: 'On course completed',
        tags: ['course'],
        body: {
            type: 'object',
            properties: {
                id: { type: 'string' },
            },
        },
        response: {
            200: {
                description: 'Success Response',
                type: 'array',
                items: {
                    id: { type: 'string' },
                }
            },
        },
    } as FastifySchema,
}
export const getByIdsGeneratorSchema = {
    schema: {
        description: 'Get courses by Ids',
        tags: ['course'],
        querystring: {
            type: 'object',
            properties: {
                ids: { type: 'array', items: { type: 'string' } },
            },
        },
        response: {
            200: {
                type: 'array',
                items: CoursePopulatedSwaggerModel,
            }
        },
    } as FastifySchema,
}
const onCourseCompleted = async (req: FastifyRequest<onCourseCompletedInputT>, res: FastifyReply) => {
    const course = await Course.findById(req.body.id).exec();
    const user = await User.findById((req as unknown as JwtAuthHandlerInputT).user.payload.id).exec()
    if (!course) {
        res.status(404).send({
            error: 'Course not found',
        })
        return;
    }
    user?.doneCourses.push(course._id)
    await user?.save();
    res.send(user?.doneCourses);
}

const getById = async (req: FastifyRequest<GetCourseHandlerInputT>, res: FastifyReply) => {
    const course = await Course.findById(req.query.id).exec();
    if (!course) {
        res.status(404).send({
            error: 'Course not found',
        })
        return;
    }
    const result = await course.populate('parts')
    res.send(result)
}
const getByIds = async (req: FastifyRequest<GetCoursesHandlerInputT>, res: FastifyReply) => {
    const courses = await Course.find({
        '_id': { $in: req.query.ids.map(i => new mongoose.Types.ObjectId(i)) }
    }).populate('parts').exec();
    if (!courses) {
        res.status(404).send({
            error: 'Courses not found',
        })
        return;
    }
    res.send(courses)
}

const createOrUpdate = async (req: FastifyRequest<ContentGeneratorHandlerInputT>, res: FastifyReply) => {
    let updatingCourse: CourseModelT | null = null;
    if (req.body.id) {
        updatingCourse = await Course.findById(req.body.id);
        if (!updatingCourse) {
            res.status(404).send({
                error: 'Course not found',
            })
            return;
        }
    }
    const pageId = (req.body.pageId || updatingCourse?.pageId)
    if (!pageId) {
        res.status(404).send({
            error: 'PageId Error',
        })
        return;
    }
    const content = await notionToHtml.getHtml(pageId)
    const contentSplitted = content.html.split('<hr>')
    const isTestnet = contentSplitted[0].includes('testnet')
    const shortDescription = strTools.getTagContent(contentSplitted[2], "p")
    const description = strTools.getTagContent(contentSplitted[3], "p")
    const imageUrl = strTools.getTagContent(content.html, "h2").replace(/<\/?[^>]+(>|$)/g, "").replace(/\n/g, '');
    const addingParts: Promise<PartModelT>[] = []

    contentSplitted.slice(4).forEach(async pageContent => {
        addingParts.push(new Promise(resolve => {
            let href = null;
            const spl = pageContent.split('##')
            if (spl.length === 2) {
                pageContent = spl[1];
                href = spl[0].replace(/<\/?[^>]+(>|$)/g, "").replace(/\n/g, '');;
            }

            const part: IPart = {
                content: pageContent,
                interactiveUrl: href || undefined,
            }

            Part.create(part).then(x => {
                resolve(x)
            })
        }))
    })

    Promise.all(addingParts).then(async parts => {
        if (parts.length === 0) {
            res.status(400).send({
                error: 'No parts found',
            })
            return;
        }
        if (updatingCourse) {
            (updatingCourse.parts as any) = parts.map(x => x._id)
            updatingCourse.shortDescription = shortDescription
            updatingCourse.description = description
            updatingCourse.pageId = pageId
            if (req.body.isDraft !== undefined) updatingCourse.isDraft = !!req.body.isDraft
            if (req.body.isNotReady !== undefined) updatingCourse.isNotReady = !!req.body.isNotReady
            updatingCourse.order = req.body.order || updatingCourse.order
            updatingCourse.locale = req.body.locale || updatingCourse.locale
            updatingCourse.preview = imageUrl
            updatingCourse.name = content.title,
                updatingCourse.isTestnet = isTestnet
            await updatingCourse.save()
            const result = await updatingCourse.populate('parts');
            res.status(200).send(result)
            return;
        }
        const createdCourse = new Course({
            pageId: req.body.pageId,
            name: content.title,
            shortDescription,
            description,
            isDraft: !!req.body.isDraft,
            isNotReady: !!req.body.isNotReady,
            locale: req.body.locale,
            order: req.body.order,
            preview: imageUrl,
            parts: parts.map(x => x._id),
            isTestnet
        })
        await createdCourse.save();
        const result = await createdCourse.populate('parts')
        res.send(result)
    })

}

const getRoadmap = async (req: FastifyRequest<LocaleBasedInputT>, res: FastifyReply) => {
    const locale = localeService.getLocale(req.headers.locale);
    const courses = (await Course.find({ isDraft: false, locale: locale }).exec()).sort((x, y) => x.order - y.order)
    res.send(courses)
}

export default {
    createOrUpdate,
    getById,
    getByIds,
    onCourseCompleted,
    getRoadmap,
}
