class ServiceDiscoveryFactory {
    private let restClient: RestClient

    init(restClient: RestClient = RestClient()) {
        self.restClient = restClient
    }

    func getDiscovery(
        request: URLRequest,
        completionHandler: @escaping (ApiResponse?) -> Void
    ) {
        restClient.send(
            urlSession: URLSession.shared,
            request: request,
            responseType: ApiResponse.self
        ) {
            result in
            let apiResponse: ApiResponse?

            switch result {
            case .success(let discoveryResponse):
                apiResponse = discoveryResponse
            case .failure:
                apiResponse = nil
            }

            completionHandler(apiResponse)
        }
    }
}
