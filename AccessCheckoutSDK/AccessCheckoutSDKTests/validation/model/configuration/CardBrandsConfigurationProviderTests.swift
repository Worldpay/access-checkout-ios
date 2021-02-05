@testable import AccessCheckoutSDK
import XCTest

class CardBrandsConfigurationProviderTests: XCTestCase {
    let factory = CardBrandsConfigurationFactoryMock()
    var configurationProvider: CardBrandsConfigurationProvider?
    
    override func setUp() {
        configurationProvider = CardBrandsConfigurationProvider(factory)
    }
    
    func testReturnsEmptyConfigurationWhenRemoteConfigurationIsNotNeeded() {
        let expectedConfiguration = CardBrandsConfiguration(allCardBrands: [], acceptedCardBrands: [])
        
        let result = configurationProvider!.get()
        
        XCTAssertEqual(expectedConfiguration, result)
    }
    
    func testReturnsEmptyConfigurationWhenRemoteConfigurationHasBeenRequestedButNotYetProcessed() {
        let expectedConfiguration = CardBrandsConfiguration(allCardBrands: [], acceptedCardBrands: [])
        
        configurationProvider!.retrieveRemoteConfiguration(baseUrl: "a-url", acceptedCardBrands: ["amex", "visa"])
        let result = configurationProvider!.get()
        
        XCTAssertTrue(factory.createCalled)
        XCTAssertEqual("a-url", factory.baseUrlPassed)
        XCTAssertEqual(["amex", "visa"], factory.acceptedBrandsPassed)
        XCTAssertEqual(expectedConfiguration, result)
    }
    
    func testReturnsConfigurationWithBrandsWhenSuccessfullyProcessedRemoteConfiguration() {
        let cardBrand = CardBrandModel(name: "a-brand", images: [],
                                       panValidationRule: ValidationRule(matcher: "rule-1", validLengths: []),
                                       cvcValidationRule: ValidationRule(matcher: "rule-2", validLengths: []))
        let expectedConfiguration = CardBrandsConfiguration(allCardBrands: [cardBrand], acceptedCardBrands: ["amex", "visa"])
        factory.willReturn(expectedConfiguration)
        
        configurationProvider!.retrieveRemoteConfiguration(baseUrl: "a-url", acceptedCardBrands: ["amex", "visa"])
        let result = configurationProvider!.get()
        
        XCTAssertTrue(factory.createCalled)
        XCTAssertEqual("a-url", factory.baseUrlPassed)
        XCTAssertEqual(["amex", "visa"], factory.acceptedBrandsPassed)
        XCTAssertEqual(expectedConfiguration, result)
    }
}
