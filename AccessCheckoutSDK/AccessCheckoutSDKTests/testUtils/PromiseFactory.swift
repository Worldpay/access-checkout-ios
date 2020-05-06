import PromiseKit

class PromiseFactory {
    static func fulfilled<T>(with value:T) -> Promise<T> {
        return Promise { seal in
            seal.fulfill(value)
        }
    }
    
    static func rejected<E: Error, T>(with error:E, returningType: T.Type) -> Promise<T> {
        return Promise { seal in
            seal.reject(error)
        }
    }
}
