@testable import AccessCheckoutSDK

class CardBrandsConfigurationFactoryMock: CardBrandsConfigurationFactory {
    private(set) var baseUrlPassed: String?
    private(set) var createCalled: Bool = false
    
    init() {
        super.init(RestClientMock<String>(replyWith: ""), MockCardBrandDtoTransformer())
    }
    
    override func create(baseUrl: String, completionHandler: @escaping (CardBrandsConfiguration) -> Void) {
        createCalled = true
        baseUrlPassed = baseUrl
        
        completionHandler(CardBrandsConfiguration([], ValidationRulesDefaults.instance()))
    }
}
