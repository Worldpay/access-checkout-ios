/**
 A builder that returns an `AccessCheckoutClient` for the merchant to use for session generation
 
 - SeeAlso: AccessCheckoutClient for more information on how to use the client
 */
public class AccessCheckoutClientBuilder {
    private var checkoutId: String?
    private var accessBaseUrl: String?
    
    public init() {}
    
    /**
     Deprecated - Sets the merchant id of the client
     - Parameter merchantId: `String` that represents the checkoutId given to the merchant at time of registration
     */
    @available(*, deprecated, message: "Your checkoutId should now be passed to the builder using checkoutId(). The support for passing your checkoutId using merchantId() will be removed in the next major version")
    public func merchantId(_ merchantId: String) -> AccessCheckoutClientBuilder {
        self.checkoutId = merchantId
        return self
    }
    
    /**
     Sets the checkoutId on the client
     
     - Parameter checkoutId: `String` that represents the checkoutId given to the merchant at time of registration
     */
    public func checkoutId(_ checkoutId: String) -> AccessCheckoutClientBuilder {
        self.checkoutId = checkoutId
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
        guard let checkoutId = checkoutId else {
            throw AccessCheckoutIllegalArgumentError.missingCheckoutId()
        }
        
        guard let accessBaseUrl = accessBaseUrl else {
            throw AccessCheckoutIllegalArgumentError.missingAccessBaseUrl()
        }
        
        let cardDetailsForSessionTypeValidator = CardDetailsForSessionTypeValidator()
        
        let retrieveCardSessionHandler = RetrieveCardSessionHandler(apiClient: CardSessionsApiClient())
        let retrieveCvcSessionHandler = RetrieveCvcSessionHandler(apiClient: CvcSessionsApiClient())
        let retrieveSessionHandlerDispatcher = RetrieveSessionHandlerDispatcher(retrieveSessionHandlers: [retrieveCardSessionHandler, retrieveCvcSessionHandler])
        
        return AccessCheckoutClient(checkoutId: checkoutId, baseUrl: accessBaseUrl, cardDetailsForSessionTypeValidator, retrieveSessionHandlerDispatcher)
    }
}
