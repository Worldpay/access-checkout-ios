@testable import AccessCheckoutSDK

class RestClientMock<T: Decodable>: RestClient {
    private(set) var sendMethodCalled = false
    private(set) var expectedRequestSent = false
    private(set) var requestSent: URLRequest?
    private(set) var numberOfCalls: Int = 0
    private var response: T?
    private var error: AccessCheckoutError?
    private var statusCode: Int?

    override init() {
    }

    init(replyWith response: T) {
        self.response = response
    }

    init(errorWith error: AccessCheckoutError, statusCode: Int? = nil) {
        self.error = error
        self.statusCode = statusCode
    }

    //TODO: fix warning to do with generic parameter 'T'
    override func send<T: Decodable>(
        urlSession: URLSession, request: URLRequest, responseType: T.Type,
        completionHandler: @escaping (Result<T, AccessCheckoutError>, Int?) -> Void
    ) {
        numberOfCalls += 1
        sendMethodCalled = true
        requestSent = request

        if response != nil {
            completionHandler(.success(response as! T), 200)
        } else if error != nil {
            completionHandler(.failure(error!), statusCode)
        }
    }
}
