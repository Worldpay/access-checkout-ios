import Foundation

class ServiceDiscoveryResponseFactory {
    private let restClient: RestClient<ApiResponse>

    init(restClient: RestClient<ApiResponse> = RestClient()) {
        self.restClient = restClient
    }

    func create(
        request: URLRequest,
        completionHandler: @escaping (Result<ApiResponse, AccessCheckoutError>) -> Void
    ) {
        restClient.send(
            urlSession: URLSession.shared,
            request: request
        ) {
            result, _ in

            completionHandler(result)
        }
    }
}
