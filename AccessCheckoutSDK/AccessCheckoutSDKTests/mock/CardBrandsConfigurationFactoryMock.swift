@testable import AccessCheckoutSDK

class CardBrandsConfigurationFactoryMock: CardBrandsConfigurationFactory {
    private(set) var baseUrlPassed: String?
    private(set) var createCalled: Bool = false
    private var cardBrandsConfigurationToReturn = CardBrandsConfiguration([], ValidationRulesDefaults.instance())
    
    init() {
        super.init(RestClientMock<String>(replyWith: ""), MockCardBrandDtoTransformer())
    }
    
    func willReturn(_ expectedConfiguration:CardBrandsConfiguration) {
        self.cardBrandsConfigurationToReturn = expectedConfiguration
    }
    
    override func create(baseUrl: String, completionHandler: @escaping (CardBrandsConfiguration) -> Void) {
        createCalled = true
        baseUrlPassed = baseUrl
        
        completionHandler(cardBrandsConfigurationToReturn)
    }
}
