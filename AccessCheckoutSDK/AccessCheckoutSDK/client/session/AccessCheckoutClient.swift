/// This class is the entry point to the session generate for Access Worldpay Services.
///
/// This should be used when the merchant wishes to generate a new session to initiate a payment flow or other supported flow.
///
/// An implementation of this interface is returned after the `AccessCheckoutClientBuilder` is used.
///
/// - Attention: The the only way to create an instance of this class is by using the `AccessCheckoutClientBuilder`
/// - SeeAlso: AccessCheckoutClientBuilder
public struct AccessCheckoutClient {
    private let checkoutId: String
    private let baseUrl: String
    private let cardDetailsForSessionTypeValidator: CardDetailsForSessionTypeValidator
    private let retrieveSessionHandlerDispatcher: RetrieveSessionHandlerDispatcher

    init(
        checkoutId: String,
        baseUrl: String,
        _ cardDetailsForSessionTypeValidator: CardDetailsForSessionTypeValidator,
        _ retrieveSessionHandlerDispatcher: RetrieveSessionHandlerDispatcher
    ) {
        self.checkoutId = checkoutId
        self.baseUrl = baseUrl
        self.cardDetailsForSessionTypeValidator = cardDetailsForSessionTypeValidator
        self.retrieveSessionHandlerDispatcher = retrieveSessionHandlerDispatcher
    }
    /**
     This function allows the generation of a new session for the client to use in the next phase of the payment flow or other supported flow.
    
     The response of this function is asynchronous and will use a callback to respond back to the merchant
    
     - Parameter cardDetails: Represents the `CardDetails` that is provided by the merchant
     - Parameter sessionTypes: Represents a `Set` of `SessionType` that the merchant would like to retrieve
    
     - Throws: an `AccessCheckoutIllegalArgumentError` if some of the card details are missing to retrieve a given type of session
     */
    public func generateSessions(
        cardDetails: CardDetails,
        sessionTypes: Set<SessionType>,
        completionHandler: @escaping (Result<[SessionType: String], AccessCheckoutError>) -> Void
    ) throws {
        try sessionTypes.forEach {
            try cardDetailsForSessionTypeValidator.validate(cardDetails: cardDetails, for: $0)
        }

        ServiceDiscoveryProvider.discover(baseUrl: self.baseUrl) { result in
            switch result {
            case .success():
                let resultsHandler: RetrieveSessionResultsHandler = RetrieveSessionResultsHandler(
                    numberOfExpectedResults: sessionTypes.count,
                    completeWith: completionHandler
                )
                sessionTypes.forEach { sessionType in
                    retrieveSessionHandlerDispatcher.dispatch(
                        checkoutId, baseUrl, cardDetails, sessionType
                    ) {
                        result in
                        resultsHandler.handle(result, for: sessionType)
                    }
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
