class PaymentsCvcRetrieveSessionHandler: RetrieveSessionHandler {
    private let apiClient: SessionsApiClient

    init(apiClient: SessionsApiClient) {
        self.apiClient = apiClient
    }

    func canHandle(sessionType: SessionType) -> Bool {
        return sessionType == SessionType.paymentsCvc
    }

    func retrieveSession(_ merchantId: String, _ baseUrl: String, _ cardDetails: CardDetails, completionHandler: @escaping (Result<String, AccessCheckoutClientError>) -> Void) {
        // ToDo - we should fail the process if we're trying to retrieve a session and CVV is empty
        apiClient.createSession(cvv: cardDetails.cvv!, urlSession: URLSession.shared) { result in
            switch result {
                case .success(let session):
                    completionHandler(.success(session))
                case .failure(let error):
                    completionHandler(.failure(error))
            }
        }
    }
}
