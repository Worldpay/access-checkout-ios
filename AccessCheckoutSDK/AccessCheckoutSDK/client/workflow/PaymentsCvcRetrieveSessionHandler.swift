class PaymentsCvcRetrieveSessionHandler: RetrieveSessionHandler {
    func canHandle(sessionType: SessionType) -> Bool {
        return sessionType == SessionType.paymentsCvc
    }

    func retrieveSession(_ merchantId: String, _ baseUrl: String, _ cardDetails: CardDetails, completionHandler: @escaping (Result<String, Error>) -> Void) {
        completionHandler(.success("a-session"))
    }
}
