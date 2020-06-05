@testable import AccessCheckoutSDK
import XCTest

class CardBrandsConfigurationProviderTests: XCTestCase {
    let factory = CardBrandsConfigurationFactoryMock()
    var expectedConfiguration: CardBrandsConfiguration?
    var configurationProvider: CardBrandsConfigurationProvider?
    
    override func setUp() {
        configurationProvider = CardBrandsConfigurationProvider(factory)
    }
    
    func testReturnsConfigurationWithDefaultsOnlyWhenRemoteConfigurationIsNotNeeded() {
        expectedConfiguration = CardBrandsConfiguration([], ValidationRulesDefaults.instance())
        
        let result = configurationProvider!.get()
        
        XCTAssertEqual(expectedConfiguration, result)
    }
    
    func testReturnsConfigurationWithDefaultsOnlyWhenRemoteConfigurationHasBeenRequestedButNotYetProcessed() {
        expectedConfiguration = CardBrandsConfiguration([], ValidationRulesDefaults.instance())
        
        configurationProvider!.retrieveRemoteConfiguration(baseUrl: "a-url")
        let result = configurationProvider!.get()
        
        XCTAssertEqual("a-url", factory.baseUrlPassed)
        XCTAssertTrue(factory.createCalled)
        XCTAssertEqual(expectedConfiguration, result)
    }
    
    func testReturnsConfigurationWithBrandsAndDefaultsWhenSuccessfullyProcessedRemoteConfiguration() {
        let cardBrand = CardBrandModel(name: "a-brand", images: [],
                                       panValidationRule: ValidationRule(matcher: "rule-1", validLengths: []),
                                       cvvValidationRule: ValidationRule(matcher: "rule-2", validLengths: []))
        expectedConfiguration = CardBrandsConfiguration([cardBrand], ValidationRulesDefaults.instance())
        factory.willReturn(expectedConfiguration!)
        
        configurationProvider!.retrieveRemoteConfiguration(baseUrl: "a-url")
        let result = configurationProvider!.get()
        
        XCTAssertEqual("a-url", factory.baseUrlPassed)
        XCTAssertTrue(factory.createCalled)
        XCTAssertEqual(expectedConfiguration, result)
    }
}
