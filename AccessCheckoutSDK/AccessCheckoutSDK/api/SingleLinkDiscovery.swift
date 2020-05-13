import PromiseKit

class SingleLinkDiscovery {
    private let restClient: RestClient
    private let apiResponseLinkLookup: ApiResponseLinkLookup
    private(set) var linkToFind: String
    private(set) var urlRequest: URLRequest

    init(linkToFind: String, urlRequest: URLRequest) {
        self.restClient = RestClient()
        self.apiResponseLinkLookup = ApiResponseLinkLookup()
        self.linkToFind = linkToFind
        self.urlRequest = urlRequest
    }

    func discover() -> Promise<String> {
        return Promise { seal in
            firstly {
                restClient.send(urlSession: URLSession.shared, request: self.urlRequest, responseType: ApiResponse.self)
            }.done { response in
                if let linkValue = self.apiResponseLinkLookup.lookup(link: self.linkToFind, in: response) {
                    seal.resolve(.fulfilled(linkValue))
                } else {
                    seal.reject(AccessCheckoutClientError.unknown(message: "Failed to find link \(self.linkToFind) in response"))
                }
            }.catch { error in
                seal.reject(error)
            }
        }
    }
}
