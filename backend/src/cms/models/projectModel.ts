import mongoose, { model, Schema } from 'mongoose'
import { ELocales } from '../../courses/models/course'
export interface IProject {
    name: string
    color: string
    textColor: string
    url: string
    tags: string[]
    description: string
    locale: ELocales
    isTestnet: boolean
}

export const ProjectSwaggerModel = {
    description: 'Project Model',
    type: 'object',
    required: ['name', 'color', 'textColor', 'url', 'tags', 'description'],
    properties: {
        _id: { type: 'string' },
        name: { type: 'string' },
        color: { type: 'string' },
        locale: { type: 'string' },
        textColor: { type: 'string' },
        isTestnet: { type: 'boolean' },
        url: { type: 'string' },
        tags: { type: 'array', items: { type: 'string' } },
        description: { type: 'string' },
    },
}
const projectSchema = new Schema<IProject>(
    {
        name: { type: String, required: true },
        color: { type: String, required: true },
        textColor: { type: String, required: true },
        url: { type: String, required: true },
        tags: { type: [String], required: true },
        isTestnet: { type: Boolean, required: true },
        description: { type: String, required: true },
        locale: { type: String, enum: ELocales, default: ELocales.en },
    },
    { timestamps: true }
)

export const Project = model<IProject>('project', projectSchema)
export type ProjectModelT = mongoose.Document<unknown, any, IProject> &
    IProject & {
        _id: mongoose.Types.ObjectId
    }
