@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class CvcViewTests: XCTestCase {
    private let brandsStartingWith4AndCvv2DigitsLong = TextFixtures.createCardBrandModel(
        name: "a-brand",
        panPattern: "^4\\d*$",
        panValidLengths: [16],
        cvcValidLength: 2
    )
    
    private let cvvView = CvcView()
    private let panView = PANView()
    
    // MARK: testing what the end user can and cannot type
    func testCanEnterAnyTextWhenNoPresenter() {
        XCTAssertTrue(type("abc", into: cvvView))
    }
    
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
    
    func testCannotTypeNonNumericalCharactersForABrand() {
        initialiseValidation(cardBrands: [brandsStartingWith4AndCvv2DigitsLong], cvvView: cvvView, panView: panView)
        type("4111111", into: panView)
        
        XCTAssertFalse(type("ab", into: cvvView))
        XCTAssertFalse(type("+*", into: cvvView))
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
    
    // MARK: testing the text colour feature
    func testCanSetColourOfText() {
        cvvView.textColor = UIColor.red
        
        XCTAssertEqual(UIColor.red, cvvView.textField.textColor)
    }
    
    func testUnsetColourOfTextSetsColourToDefault() {
        cvvView.textColor = nil
        
        XCTAssertEqual(UIColor.black, cvvView.textField.textColor)
    }
    
    private func type(_ text: String, into view: PANView) {
        view.textField.text = text
        view.textFieldEditingChanged(view.textField)
    }
    
    private func type(_ text: String, into view: CvcView) -> Bool {
        let range = NSRange(location: 0, length: 0)
        
        return view.textField(view.textField, shouldChangeCharactersIn: range, replacementString: text)
    }
    
    private func initialiseValidation(cardBrands: [CardBrandModel], cvvView: CvcView, panView: PANView) {
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
        merchantDelegate.getStubbingProxy().cardBrandChanged(cardBrand: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().panValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().expiryDateValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().cvcValidChanged(isValid: any()).thenDoNothing()
        
        return merchantDelegate
    }
}
