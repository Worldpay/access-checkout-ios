import Foundation

internal class RetryRestClientDecorator<T: Decodable>: RestClientProtocol {
    private let baseRestClient: RestClient<T>
    private let maxAttempts: Int

    init(baseRestClient: RestClient<T> = RestClient(), maxAttempts: Int = 3) {
        self.baseRestClient = baseRestClient
        self.maxAttempts = maxAttempts
    }

    func send(
        urlSession: URLSession,
        request: URLRequest,
        completionHandler: @escaping (Result<T, AccessCheckoutError>, Int?) -> Void
    ) -> URLSessionTask {
        sendWithRetries(
            urlSession: urlSession, request: request, attempts: 1,
            completionHandler: completionHandler)
    }

    private func sendWithRetries(
        urlSession: URLSession,
        request: URLRequest,
        attempts: Int,
        completionHandler: @escaping (Result<T, AccessCheckoutError>, Int?) -> Void
    ) -> URLSessionTask {
        baseRestClient.send(urlSession: urlSession, request: request) { result, statusCode in
            switch result {
            case .success(let response):
                completionHandler(.success(response), statusCode)
            case .failure(let error):
                if attempts < self.maxAttempts {
                    _ = self.sendWithRetries(
                        urlSession: urlSession,
                        request: request,
                        attempts: attempts + 1,
                        completionHandler: completionHandler
                    )
                } else {
                    let error = AccessCheckoutError.unexpectedApiError(
                        message:
                            "Failed after \(self.maxAttempts) attempt(s) with error \(error.message)"
                    )
                    completionHandler(.failure(error), statusCode)
                }
            }
        }
    }
}
