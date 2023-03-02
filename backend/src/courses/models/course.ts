import mongoose, { model, Schema } from 'mongoose'
type htmlString = string;
export enum ELocales {
    en = 'en',
    ru = 'ru',
}
export interface ICourse {
    pageId: string;
    order: number;
    isTestnet: boolean
    name: string
    preview: string
    shortDescription: string
    description: htmlString;
    parts: IPart[] | mongoose.Schema.Types.ObjectId[];
    isNotReady?: boolean; // Shows on the app
    isDraft?: boolean; // Does not display on the app
    locale?: ELocales;
}

export interface IPart {
    interactiveUrl?: string;
    content: htmlString;
}
export const PartSwaggerModel = {
    description: 'Part',
    type: 'object',
    required: ['content'],
    properties: {
        content: { type: 'string' },
        interactiveUrl: { type: 'string' },
    },
}
export const CourseSwaggerModel = {
    description: 'Course',
    type: 'object',
    required: ['pageId', '_id', 'name', 'preview', 'shortDescription', 'description', 'parts'],
    properties: {
        _id: { type: 'string' },
        pageId: { type: 'string' },
        name: { type: 'string' },
        isTestnet: { type: 'boolean' },
        preview: { type: 'string' },
        order: { type: 'number' },
        shortDescription: { type: 'string' },
        description: { type: 'string' },
        parts: {
            type: 'array', items: {
                type: 'string',
            }
        },
        isNotReady: { type: 'boolean' },
        locale: { type: 'string', default: ELocales.en },
    },
}

export const CoursePopulatedSwaggerModel = {
    ...CourseSwaggerModel,
    properties: {
        ...CourseSwaggerModel.properties,
        parts: { type: 'array', items: PartSwaggerModel },
    },
}
const partSchema = new Schema<IPart>(
    {
        content: { type: String },
        interactiveUrl: { type: String },
    },
    { timestamps: true }
)

const courseSchema = new Schema<ICourse>(
    {
        name: { type: String },
        pageId: { type: String, required: true },
        preview: { type: String },
        shortDescription: { type: String },
        description: { type: String },
        order: { type: Number, default: -1 },
        isDraft: { type: Boolean },
        locale: { type: String, enum: ELocales, default: ELocales.en },
        parts: {
            type: [{
                type: mongoose.Schema.Types.ObjectId,
                ref: 'part'
            }]
        },
        isNotReady: { type: Boolean },
        isTestnet: { type: Boolean },
    },
    { timestamps: true }
)

export const Course = model<ICourse>('course', courseSchema)
export type CourseModelT = mongoose.Document<unknown, any, ICourse> &
    ICourse & {
        _id: mongoose.Types.ObjectId
    }

export const Part = model<IPart>('part', partSchema)
export type PartModelT = mongoose.Document<unknown, any, IPart> &
    IPart & {
        _id: mongoose.Types.ObjectId
    }
