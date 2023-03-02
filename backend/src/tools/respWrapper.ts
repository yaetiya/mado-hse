export type respWrapper<T> =
    | {
          type: 'err'
          message?: string
      }
    | {
          type: 'ok'
          data: T
      }
export const buildSuccessResp = <T>(data: T): respWrapper<T> => ({
    type: 'ok',
    data,
})

export const buildErrorResp = (message?: string): respWrapper<any> => ({
    type: 'err',
    message,
})
