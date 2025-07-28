@testable import AccessCheckoutSDK

class RestClientMock<T: Decodable>: RestClient {
    private(set) var sendMethodCalled = false
    private(set) var expectedRequestSent = false
    private(set) var requestSent: URLRequest?
    private var response: T?
    private var error: AccessCheckoutError?

    init(replyWith response: T) {
        self.response = response
    }

    init(errorWith error: AccessCheckoutError) {
        self.error = error
    }

    //TODO: fix warning to do with generic parameter 'T'
    override func send<T: Decodable>(
        urlSession: URLSession, request: URLRequest, responseType: T.Type,
        completionHandler: @escaping (Result<T, AccessCheckoutError>, Int?) -> Void
    ) {
        sendMethodCalled = true
        requestSent = request

        if response != nil {
            completionHandler(.success(response as! T), nil)
        } else if error != nil {
            completionHandler(.failure(error!), nil)
        }
    }
}
