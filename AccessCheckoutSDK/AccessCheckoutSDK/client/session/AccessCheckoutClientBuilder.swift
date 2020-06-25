/**
 A builder that returns an `AccessCheckoutClient` for the merchant to use for session generation
 
 - SeeAlso: AccessCheckoutClient for more information on how to use the client
 */
public class AccessCheckoutClientBuilder {
    private var merchantId: String?
    private var accessBaseUrl: String?
    
    public init() {}
    
    /**
     Sets the merchant id of the client
     
     - Parameter merchantId: `String` that represents the id of the merchant given to the merchant at time of registration
     */
    public func merchantId(_ merchantId: String) -> AccessCheckoutClientBuilder {
        self.merchantId = merchantId
        return self
    }
    
    /**
     Sets the base url for Access Worldpay services
     
     - Parameter accessBaseUrl: `String` that represents the base url of Worlpay API services
     */
    public func accessBaseUrl(_ accessBaseUrl: String) -> AccessCheckoutClientBuilder {
        self.accessBaseUrl = accessBaseUrl
        return self
    }
    
    /**
     Builds the `AccessCheckoutClient` instance
     
     - Returns: `AccessCheckoutClient` instance
     - Throws: `AccessCheckoutIllegalArgumentError` is thrown when a property is missing
     */
    public func build() throws -> AccessCheckoutClient {
        guard let merchantId = self.merchantId else {
            throw AccessCheckoutIllegalArgumentError.missingMerchantId()
        }
        
        guard let accessBaseUrl = self.accessBaseUrl else {
            throw AccessCheckoutIllegalArgumentError.missingAccessBaseUrl()
        }
        
        let cardDetailsForSessionTypeValidator = CardDetailsForSessionTypeValidator()
        
        let verifiedTokensRetrieveSessionHandler = VerifiedTokensRetrieveSessionHandler(apiClient: VerifiedTokensApiClient())
        let paymentsCvcRetrieveSessionHandler = PaymentsCvcRetrieveSessionHandler(apiClient: SessionsApiClient())
        let retrieveSessionHandlerDispatcher = RetrieveSessionHandlerDispatcher(retrieveSessionHandlers: [verifiedTokensRetrieveSessionHandler, paymentsCvcRetrieveSessionHandler])
        
        return AccessCheckoutClient(merchantId: merchantId, baseUrl: accessBaseUrl, cardDetailsForSessionTypeValidator, retrieveSessionHandlerDispatcher)
    }
}
