@testable import AccessCheckoutSDK

class CardBrandsConfigurationFactoryMock: CardBrandsConfigurationFactory {
    private(set) var baseUrlPassed: String?
    private(set) var acceptedBrandsPassed: [String]?
    private(set) var createCalled: Bool = false
    private var cardBrandsConfigurationToReturn = CardBrandsConfiguration(
        allCardBrands: [], acceptedCardBrands: [])

    init() {
        super.init(RestClientMock<[CardBrandDto]>(replyWith: []), MockCardBrandDtoTransformer())
    }

    func willReturn(_ expectedConfiguration: CardBrandsConfiguration) {
        cardBrandsConfigurationToReturn = expectedConfiguration
    }

    override func create(
        baseUrl: String, acceptedCardBrands: [String],
        completionHandler: @escaping (CardBrandsConfiguration) -> Void
    ) {
        createCalled = true
        baseUrlPassed = baseUrl
        acceptedBrandsPassed = acceptedCardBrands

        completionHandler(cardBrandsConfigurationToReturn)
    }
}
