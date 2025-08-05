import Foundation

internal class RestClient<T: Decodable> {
    func send(
        urlSession: URLSession,
        request: URLRequest,
        responseType: T.Type,
        completionHandler: @escaping (Result<T, AccessCheckoutError>, Int?) -> Void
    ) {
        urlSession.dataTask(with: request) { data, urlResponse, error in
            let urlResponse = urlResponse as? HTTPURLResponse
            if let responseBody = data {
                if let decodedResponse = try? JSONDecoder().decode(T.self, from: responseBody) {
                    completionHandler(.success(decodedResponse), urlResponse?.statusCode)
                } else if let accessCheckoutClientError = try? JSONDecoder().decode(
                    AccessCheckoutError.self,
                    from: responseBody
                ) {
                    completionHandler(
                        .failure(accessCheckoutClientError),
                        urlResponse?.statusCode)
                } else {
                    completionHandler(
                        .failure(AccessCheckoutError.responseDecodingFailed()),
                        urlResponse?.statusCode)
                }
            } else {
                var errorMessage: String
                if error?.localizedDescription != nil {
                    errorMessage = error!.localizedDescription
                } else {
                    errorMessage = "Unexpected response: no data or error returned"
                }
                completionHandler(
                    .failure(AccessCheckoutError.unexpectedApiError(message: errorMessage)),
                    urlResponse?.statusCode)
            }
        }.resume()
    }
}
