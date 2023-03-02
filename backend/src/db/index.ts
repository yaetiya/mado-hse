import mongoose from 'mongoose'
import { configuration } from '../config/configuration'
let database: mongoose.Connection | null = null
const init = () => {
    mongoose.connect(configuration.db.connectUrl)
    database = mongoose.connection
    database.on('error', (error) => {
        console.log(error)
    })

    database.once('connected', () => {
        console.log('Database Connected')
    })
}

export default {
    init,
}
