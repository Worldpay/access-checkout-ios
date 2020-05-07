import PromiseKit

class PaymentsCvcRetrieveSessionHandler: RetrieveSessionHandler {
    private var apiClient: SessionsApiClient?

    init(apiClient: SessionsApiClient) {
        self.apiClient = apiClient
    }

    func canHandle(sessionType: SessionType) -> Bool {
        return sessionType == SessionType.paymentsCvc
    }

    func retrieveSession(_ merchantId: String, _ baseUrl: String, _ cardDetails: CardDetails, completionHandler: @escaping (Swift.Result<String, AccessCheckoutClientError>) -> Void) {
        
        firstly {
            apiClient!.createSession(baseUrl: baseUrl, merchantId: merchantId, cvc: cardDetails.cvv!)
        }.done() { session in
            completionHandler(.success(session))
        }.catch() { error in
            completionHandler(.failure(error as! AccessCheckoutClientError))
        }
    }
}
