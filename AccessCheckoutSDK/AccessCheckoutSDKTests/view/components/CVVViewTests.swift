@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class CVVViewTests: XCTestCase {
    private let brandsStartingWith4AndCvv2DigitsLong = CardBrandModel(
        name: "a-brand",
        images: [],
        panValidationRule: ValidationRule(matcher: "^4\\d*$", validLengths: [16]),
        cvvValidationRule: ValidationRule(matcher: nil, validLengths: [2])
    )
    
    private let cvvView = CVVView()
    private let panView = PANView()
    
    func testCanClearText() {
        initialiseValidation(cardBrands: [], cvvView: cvvView, panView: panView)
        XCTAssertTrue(type("", into: cvvView))
    }
    
    func testCannotTypeNonNumericalCharactersForUnknownBrand() {
        initialiseValidation(cardBrands: [], cvvView: cvvView, panView: panView)
        
        XCTAssertFalse(type("abc", into: cvvView))
        XCTAssertFalse(type("+*-", into: cvvView))
    }
    
    func testCanTypePartialCvvForUnknownBrand() {
        initialiseValidation(cardBrands: [], cvvView: cvvView, panView: panView)
        
        let result = type("12", into: cvvView)
        
        XCTAssertTrue(result)
    }
    
    func testCanTypeCvvAsLongAsMinLengthForUnknownBrand() {
        initialiseValidation(cardBrands: [], cvvView: cvvView, panView: panView)
        
        let result = type("123", into: cvvView)
        
        XCTAssertTrue(result)
    }
    
    func testCanTypeCvvAsLongAsMaxLengthForUnknownBrand() {
        initialiseValidation(cardBrands: [], cvvView: cvvView, panView: panView)
        
        let result = type("1234", into: cvvView)
        
        XCTAssertTrue(result)
    }
    
    func testCannotTypeCvvThatExceedsMaximiumLengthForUnknownBrand() {
        initialiseValidation(cardBrands: [], cvvView: cvvView, panView: panView)
        
        let result = type("12345", into: cvvView)
        
        XCTAssertFalse(result)
    }
    
    func testCanTypePartialCvvForABrand() {
        initialiseValidation(cardBrands: [brandsStartingWith4AndCvv2DigitsLong], cvvView: cvvView, panView: panView)
        type("4111111", into: panView)
        
        let result = type("1", into: cvvView)
        
        XCTAssertTrue(result)
    }
    
    func testCanTypeValidCvvForABrand() {
        initialiseValidation(cardBrands: [brandsStartingWith4AndCvv2DigitsLong], cvvView: cvvView, panView: panView)
        type("4111111", into: panView)
        
        let result = type("12", into: cvvView)
        
        XCTAssertTrue(result)
    }
    
    func testCannotTypeCvvThatExceedsMaximiumLengthForABrand() {
        initialiseValidation(cardBrands: [brandsStartingWith4AndCvv2DigitsLong], cvvView: cvvView, panView: panView)
        type("4111111", into: panView)
        
        let result = type("123", into: cvvView)
        
        XCTAssertFalse(result)
    }
    
    private func type(_ text: String, into view: PANView) {
        view.textField.text = text
        view.textFieldEditingChanged(view.textField)
    }
    
    private func type(_ text: String, into view: CVVView) -> Bool {
        let range = NSRange(location: 0, length: 0)
        
        return view.textField(view.textField, shouldChangeCharactersIn: range, replacementString: text)
    }
    
    private func initialiseValidation(cardBrands: [CardBrandModel], cvvView: CVVView, panView: PANView) {
        let merchantDelegate = createMerchantDelegate()
        let configurationProvider = createConfigurationProvider(with: [brandsStartingWith4AndCvv2DigitsLong])
        
        let validationConfig = CardValidationConfig(panView: panView,
                                                    expiryDateView: ExpiryDateView(),
                                                    cvvView: cvvView,
                                                    accessBaseUrl: "http://localhost",
                                                    validationDelegate: merchantDelegate)
        
        AccessCheckoutValidationInitialiser(configurationProvider).initialise(validationConfig)
    }
    
    private func createConfigurationProvider(with cardBrands: [CardBrandModel]) -> CardBrandsConfigurationProvider {
        let configurationFactory = CardBrandsConfigurationFactoryMock()
        
        let configurationProvider: MockCardBrandsConfigurationProvider = MockCardBrandsConfigurationProvider(configurationFactory)
        configurationProvider.getStubbingProxy().retrieveRemoteConfiguration(baseUrl: any()).thenDoNothing()
        configurationProvider.getStubbingProxy().get().thenReturn(CardBrandsConfiguration(cardBrands))
        
        return configurationProvider
    }
    
    private func createMerchantDelegate() -> AccessCheckoutCardValidationDelegate {
        let merchantDelegate = MockAccessCheckoutCardValidationDelegate()
        merchantDelegate.getStubbingProxy().handleCardBrandChange(cardBrand: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().handlePanValidationChange(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().handleExpiryDateValidationChange(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().handleCvvValidationChange(isValid: any()).thenDoNothing()
        
        return merchantDelegate
    }
}
