import Foundation

class ServiceDiscoveryResponseFactory {
    private let restClient: RestClient

    init(restClient: RestClient = RestClient()) {
        self.restClient = restClient
    }

    func create(
        request: URLRequest,
        completionHandler: @escaping (ApiResponse?) -> Void
    ) {
        restClient.send(
            urlSession: URLSession.shared,
            request: request,
            responseType: ApiResponse.self
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
