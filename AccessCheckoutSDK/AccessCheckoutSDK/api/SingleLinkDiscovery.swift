import Foundation

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

    func discover(completionHandler: @escaping (Result<String, AccessCheckoutError>) -> Void) {
        restClient.send(urlSession: URLSession.shared, request: urlRequest, responseType: ApiResponse.self) { result in
            switch result {
                case .success(let response):
                    if let linkValue = self.apiResponseLinkLookup.lookup(link: self.linkToFind, in: response) {
                        completionHandler(.success(linkValue))
                    } else {
                        completionHandler(.failure(AccessCheckoutError.discoveryLinkNotFound(linkName: self.linkToFind)))
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
            }
        }
    }
}
