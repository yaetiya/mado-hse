import { ELocales } from "../courses/models/course"

export const localeService = {
    getLocale: (locale) => {
        if (!Object.values(ELocales).includes(locale)) {
            return 'en'
        }
        return locale
    }
}