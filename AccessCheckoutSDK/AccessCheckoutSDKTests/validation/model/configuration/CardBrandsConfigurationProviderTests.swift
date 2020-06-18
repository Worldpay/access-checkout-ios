@testable import AccessCheckoutSDK
import XCTest

class CardBrandsConfigurationProviderTests: XCTestCase {
    let factory = CardBrandsConfigurationFactoryMock()
    var expectedConfiguration: CardBrandsConfiguration?
    var configurationProvider: CardBrandsConfigurationProvider?
    
    override func setUp() {
        configurationProvider = CardBrandsConfigurationProvider(factory)
    }
    
    func testReturnsEmptyConfigurationWhenRemoteConfigurationIsNotNeeded() {
        expectedConfiguration = CardBrandsConfiguration([])
        
        let result = configurationProvider!.get()
        
        XCTAssertEqual(expectedConfiguration, result)
    }
    
    func testReturnsEmptyConfigurationWhenRemoteConfigurationHasBeenRequestedButNotYetProcessed() {
        expectedConfiguration = CardBrandsConfiguration([])
        
        configurationProvider!.retrieveRemoteConfiguration(baseUrl: "a-url")
        let result = configurationProvider!.get()
        
        XCTAssertEqual("a-url", factory.baseUrlPassed)
        XCTAssertTrue(factory.createCalled)
        XCTAssertEqual(expectedConfiguration, result)
    }
    
    func testReturnsConfigurationWithBrandsWhenSuccessfullyProcessedRemoteConfiguration() {
        let cardBrand = CardBrandModel(name: "a-brand", images: [],
                                       panValidationRule: ValidationRule(matcher: "rule-1", validLengths: []),
                                       cvcValidationRule: ValidationRule(matcher: "rule-2", validLengths: []))
        expectedConfiguration = CardBrandsConfiguration([cardBrand])
        factory.willReturn(expectedConfiguration!)
        
        configurationProvider!.retrieveRemoteConfiguration(baseUrl: "a-url")
        let result = configurationProvider!.get()
        
        XCTAssertEqual("a-url", factory.baseUrlPassed)
        XCTAssertTrue(factory.createCalled)
        XCTAssertEqual(expectedConfiguration, result)
    }
}
