@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class PANViewTests: XCTestCase {
    private let visaBrand = CardBrandModel(
        name: "visa",
        images: [],
        panValidationRule: ValidationRule(matcher: "^(?!^493698\\d*$)4\\d*$", validLengths: [16, 18, 19]),
        cvvValidationRule: ValidationRule(matcher: nil, validLengths: [3])
    )
    
    let panView = PANView()
    
    func testCanClearText() {
        setUp(cardBrands: [visaBrand], panView: panView)
        XCTAssertTrue(type("", into: panView))
    }
    
    func testCannotTypeNonNumericalCharacters() {
        setUp(cardBrands: [visaBrand], panView: panView)
        
        XCTAssertFalse(type("abc", into: panView))
        XCTAssertFalse(type("+*-", into: panView))
    }
    
    func testCanTypeValidVisaPan() {
        setUp(cardBrands: [visaBrand], panView: panView)
        
        let result = type("4111111111111111", into: panView)
        
        XCTAssertTrue(result)
    }
    
    func testCanTypeVisaPanThatFailsLuhnCheck() {
        setUp(cardBrands: [visaBrand], panView: panView)
        
        let result = type("4111111111111112", into: panView)
        
        XCTAssertTrue(result)
    }
    
    func testCanTypeVisaPanAsLongAsMaxLengthAllowed() {
        setUp(cardBrands: [visaBrand], panView: panView)
        
        let result = type("4111111111111111111", into: panView)
        
        XCTAssertTrue(result)
    }
    
    func testCannotTypeVisaPanThatExceedsMaximiumLength() {
        setUp(cardBrands: [visaBrand], panView: panView)
        
        let result = type("41111111111111111111", into: panView)
        
        XCTAssertFalse(result)
    }
    
    func testCanTypePanOfUnknownBrandAsLongAsMaxLengthAllowed() {
        setUp(cardBrands: [], panView: panView)
        
        let result = type("1234567890123456789", into: panView)
        
        XCTAssertTrue(result)
    }
    
    func testCannotTypePanOfUnknownBrandThatExceedsMaximiumLength() {
        setUp(cardBrands: [], panView: panView)
        
        let result = type("12345678901234567890", into: panView)
        
        XCTAssertFalse(result)
    }
    
    func type(_ text: String, into view: PANView) -> Bool {
        let range = NSRange(location: 0, length: 0)
        
        return view.textField(view.textField, shouldChangeCharactersIn: range, replacementString: text)
    }
    
    func setUp(cardBrands: [CardBrandModel], panView: PANView) {
        let expiryDateview = ExpiryDateView()
        let cvvView = CVVView()
        let merchantDelegate = createMerchantDelegate()
        
        let configurationProvider = createConfigurationProvider(with: [visaBrand])
        
        let validationConfig = CardValidationConfig(panView: panView,
                                                    expiryDateView: expiryDateview,
                                                    cvvView: cvvView,
                                                    accessBaseUrl: "http://localhost",
                                                    validationDelegate: merchantDelegate)
        
        AccessCheckoutValidationInitialiser(configurationProvider).initialise(validationConfig)
    }
    
    func createConfigurationProvider(with cardBrands: [CardBrandModel]) -> CardBrandsConfigurationProvider {
        let configurationFactory = CardBrandsConfigurationFactoryMock()
        
        let configurationProvider: MockCardBrandsConfigurationProvider = MockCardBrandsConfigurationProvider(configurationFactory)
        configurationProvider.getStubbingProxy().retrieveRemoteConfiguration(baseUrl: any()).thenDoNothing()
        configurationProvider.getStubbingProxy().get().thenReturn(CardBrandsConfiguration(cardBrands))
        
        return configurationProvider
    }
    
    func createMerchantDelegate() -> AccessCheckoutCardValidationDelegate {
        let merchantDelegate = MockAccessCheckoutCardValidationDelegate()
        merchantDelegate.getStubbingProxy().handleCardBrandChange(cardBrand: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().handlePanValidationChange(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().handleExpiryDateValidationChange(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().handleCvvValidationChange(isValid: any()).thenDoNothing()
        
        return merchantDelegate
    }
}
