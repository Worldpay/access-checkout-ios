import Foundation

class RestClient {
    func send<T: Decodable>(urlSession: URLSession, request: URLRequest, responseType: T.Type, completionHandler: @escaping (Result<T, AccessCheckoutError>) -> Void) {
        urlSession.dataTask(with: request) { data, _, error in
            if let responseBody = data {
                if let decodedResponse = try? JSONDecoder().decode(T.self, from: responseBody) {
                    completionHandler(.success(decodedResponse))
                } else if let accessCheckoutClientError = try? JSONDecoder().decode(AccessCheckoutError.self, from: responseBody) {
                    completionHandler(.failure(accessCheckoutClientError))
                } else {
                    completionHandler(.failure(AccessCheckoutError.responseDecodingFailed()))
                }
            } else {
                var errorMessage: String
                if error?.localizedDescription != nil {
                    errorMessage = error!.localizedDescription
                } else {
                    errorMessage = "Unexpected response: no data or error returned"
                }
                completionHandler(.failure(AccessCheckoutError.unexpectedApiError(message: errorMessage)))
            }
        }.resume()
    }
}
