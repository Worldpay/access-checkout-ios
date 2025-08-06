import Foundation

class ServiceDiscoveryResponseFactory {
    private let restClient: RestClient<ApiResponse>

    init(restClient: RestClient<ApiResponse> = RestClient()) {
        self.restClient = restClient
    }

    func create(
        request: URLRequest,
        completionHandler: @escaping (ApiResponse?) -> Void
    ) {
        restClient.send(
            urlSession: URLSession.shared,
            request: request
        ) {
            result, _ in
            let apiResponse: ApiResponse?

            switch result {
            case .success(let discoveryResponse):
                apiResponse = discoveryResponse
            case .failure:
                apiResponse = nil
                NSLog("Service discovery failed: \(result)")
            }

            completionHandler(apiResponse)
        }
    }
}
