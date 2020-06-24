
public class AccessCheckoutClientBuilder {
    private var merchantId: String?
    private var accessBaseUrl: String?
    
    public init() {}
    
    public func merchantId(_ merchantId: String) -> AccessCheckoutClientBuilder {
        self.merchantId = merchantId
        return self
    }
    
    public func accessBaseUrl(_ accessBaseUrl: String) -> AccessCheckoutClientBuilder {
        self.accessBaseUrl = accessBaseUrl
        return self
    }
    
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
