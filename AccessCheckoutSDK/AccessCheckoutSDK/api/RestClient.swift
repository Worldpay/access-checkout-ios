import Foundation

internal class RestClient<T: Decodable>: RestClientProtocol {
    func send(
        urlSession: URLSession,
        request: URLRequest,
        completionHandler: @escaping (Result<T, AccessCheckoutError>, Int?) -> Void
    ) -> URLSessionTask {
        let onDataTaskComplete = CompletionHandler { result, statusCode in
            completionHandler(result, statusCode)
        }

        let task: URLSessionDataTask = urlSession.dataTask(with: request) {
            data, urlResponse, error in
            if error?.localizedDescription == "cancelled" {
                return
            } else {
                onDataTaskComplete.handle(data, urlResponse, error)
            }
        }
        task.resume()
        return task
    }

    private class CompletionHandler {
        private var actualCompletionHandler: ((Result<T, AccessCheckoutError>, Int?) -> Void)

        fileprivate init(
            completionHandler actualCompletionHandler: @escaping (
                Result<T, AccessCheckoutError>, Int?
            ) -> Void
        ) {
            self.actualCompletionHandler = actualCompletionHandler
        }

        fileprivate func handle(_ data: Data?, _ urlResponse: URLResponse?, _ error: Error?) {
            let urlResponse = urlResponse as? HTTPURLResponse
            if let responseBody = data {
                if let decodedResponse = try? JSONDecoder().decode(T.self, from: responseBody) {
                    actualCompletionHandler(.success(decodedResponse), urlResponse?.statusCode)
                } else if let accessCheckoutClientError = try? JSONDecoder().decode(
                    AccessCheckoutError.self,
                    from: responseBody
                ) {
                    actualCompletionHandler(
                        .failure(accessCheckoutClientError),
                        urlResponse?.statusCode)
                } else {
                    actualCompletionHandler(
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
                actualCompletionHandler(
                    .failure(AccessCheckoutError.unexpectedApiError(message: errorMessage)),
                    urlResponse?.statusCode)
            }
        }
    }
}
