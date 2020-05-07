import PromiseKit

class VerifiedTokensRetrieveSessionHandler: RetrieveSessionHandler {
    private var apiClient: VerifiedTokensApiClient?

    init(apiClient: VerifiedTokensApiClient) {
        self.apiClient = apiClient
    }

    func canHandle(sessionType: SessionType) -> Bool {
        return sessionType == SessionType.verifiedTokens
    }

    func retrieveSession(_ merchantId: String, _ baseUrl: String, _ cardDetails: CardDetails, completionHandler: @escaping (Swift.Result<String, AccessCheckoutClientError>) -> Void) {
        firstly {
            apiClient!.createSession(baseUrl: baseUrl,
                                      merchantId: merchantId,
                                      pan: cardDetails.pan!,
                                      expiryMonth: cardDetails.expiryMonth!,
                                      expiryYear: cardDetails.expiryYear!,
                                      cvc: cardDetails.cvv!)
        }.done { session in
            completionHandler(.success(session))
        }.catch { error in
            completionHandler(.failure(error as! AccessCheckoutClientError))
        }
    }
}
