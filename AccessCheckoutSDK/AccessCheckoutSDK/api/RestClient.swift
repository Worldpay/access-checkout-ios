import Foundation
import PromiseKit

class RestClient {
    func send<T: Decodable>(urlSession: URLSession, request: URLRequest, responseType: T.Type) -> Promise<T> {
        return Promise { seal in
            urlSession.dataTask(with: request) { data, _, error in
                if let responseBody = data {
                    if let decodedResponse = try? JSONDecoder().decode(T.self, from: responseBody) {
                        seal.fulfill(decodedResponse)
                    } else if let accessCheckoutClientError = try? JSONDecoder().decode(AccessCheckoutClientError.self, from: responseBody) {
                        seal.reject(accessCheckoutClientError)
                    } else {
                        seal.reject(AccessCheckoutClientError.unknown(message: "Failed to decode response data"))
                    }
                } else {
                    var errorMessage: String
                    if error?.localizedDescription != nil {
                        errorMessage = error!.localizedDescription
                    } else {
                        errorMessage = "Unexpected response: no data or error returned"
                    }
                    seal.reject(AccessCheckoutClientError.unknown(message: errorMessage))
                }
            }.resume()
        }
    }
}
