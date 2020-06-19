@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class CvcViewTests: XCTestCase {
    private let brandsStartingWith4AndCvc2DigitsLong = TextFixtures.createCardBrandModel(
        name: "a-brand",
        panPattern: "^4\\d*$",
        panValidLengths: [16],
        cvcValidLength: 2
    )
    
    private let cvcView = CvcView()
    private let panView = PANView()
    
    // MARK: testing what the end user can and cannot type
    
    func testCanEnterAnyTextWhenNoPresenter() {
        XCTAssertTrue(type("abc", into: cvcView))
    }
    
    func testCanClearText() {
        initialiseValidation(cardBrands: [], cvcView: cvcView, panView: panView)
        XCTAssertTrue(type("", into: cvcView))
    }
    
    func testCannotTypeNonNumericalCharactersForUnknownBrand() {
        initialiseValidation(cardBrands: [], cvcView: cvcView, panView: panView)
        
        XCTAssertFalse(type("abc", into: cvcView))
        XCTAssertFalse(type("+*-", into: cvcView))
    }
    
    func testCanTypePartialCvcForUnknownBrand() {
        initialiseValidation(cardBrands: [], cvcView: cvcView, panView: panView)
        
        let result = type("12", into: cvcView)
        
        XCTAssertTrue(result)
    }
    
    func testCanTypeCvcAsLongAsMinLengthForUnknownBrand() {
        initialiseValidation(cardBrands: [], cvcView: cvcView, panView: panView)
        
        let result = type("123", into: cvcView)
        
        XCTAssertTrue(result)
    }
    
    func testCanTypeCvcAsLongAsMaxLengthForUnknownBrand() {
        initialiseValidation(cardBrands: [], cvcView: cvcView, panView: panView)
        
        let result = type("1234", into: cvcView)
        
        XCTAssertTrue(result)
    }
    
    func testCannotTypeCvcThatExceedsMaximiumLengthForUnknownBrand() {
        initialiseValidation(cardBrands: [], cvcView: cvcView, panView: panView)
        
        let result = type("12345", into: cvcView)
        
        XCTAssertFalse(result)
    }
    
    func testCannotTypeNonNumericalCharactersForABrand() {
        initialiseValidation(cardBrands: [brandsStartingWith4AndCvc2DigitsLong], cvcView: cvcView, panView: panView)
        type("4111111", into: panView)
        
        XCTAssertFalse(type("ab", into: cvcView))
        XCTAssertFalse(type("+*", into: cvcView))
    }
    
    func testCanTypePartialCvcForABrand() {
        initialiseValidation(cardBrands: [brandsStartingWith4AndCvc2DigitsLong], cvcView: cvcView, panView: panView)
        type("4111111", into: panView)
        
        let result = type("1", into: cvcView)
        
        XCTAssertTrue(result)
    }
    
    func testCanTypeValidCvcForABrand() {
        initialiseValidation(cardBrands: [brandsStartingWith4AndCvc2DigitsLong], cvcView: cvcView, panView: panView)
        type("4111111", into: panView)
        
        let result = type("12", into: cvcView)
        
        XCTAssertTrue(result)
    }
    
    func testCannotTypeCvcThatExceedsMaximiumLengthForABrand() {
        initialiseValidation(cardBrands: [brandsStartingWith4AndCvc2DigitsLong], cvcView: cvcView, panView: panView)
        type("4111111", into: panView)
        
        let result = type("123", into: cvcView)
        
        XCTAssertFalse(result)
    }
    
    // MARK: text feature
    
    func testCanGetText() {
        cvcView.textField.text = "some text"
        
        XCTAssertEqual("some text", cvcView.text)
    }
    
    // MARK: enabled feature
    
    func testCanGetTextFieldEnabledState() {
        cvcView.textField.isEnabled = false
        
        XCTAssertFalse(cvcView.isEnabled)
    }
    
    func testCanSetTextFieldEnabledState() {
        cvcView.textField.isEnabled = true
        cvcView.isEnabled = false
        
        XCTAssertFalse(cvcView.textField.isEnabled)
    }
    
    // MARK: text colour feature
    
    func testCanSetColourOfText() {
        cvcView.textColor = UIColor.red
        
        XCTAssertEqual(UIColor.red, cvcView.textField.textColor)
    }
    
    func testUnsetColourOfTextSetsColourToDefault() {
        cvcView.textColor = nil
        
        XCTAssertEqual(UIColor.black, cvcView.textField.textColor)
    }
    
    func testCanGetColourOfText() {
        cvcView.textField.textColor = UIColor.red
        
        XCTAssertEqual(UIColor.red, cvcView.textColor)
    }
    
    private func type(_ text: String, into view: PANView) {
        view.textField.text = text
        view.textFieldEditingChanged(view.textField)
    }
    
    private func type(_ text: String, into view: CvcView) -> Bool {
        let range = NSRange(location: 0, length: 0)
        
        return view.textField(view.textField, shouldChangeCharactersIn: range, replacementString: text)
    }
    
    private func initialiseValidation(cardBrands: [CardBrandModel], cvcView: CvcView, panView: PANView) {
        let merchantDelegate = createMerchantDelegate()
        let configurationProvider = createConfigurationProvider(with: [brandsStartingWith4AndCvc2DigitsLong])
        
        let validationConfig = CardValidationConfig(panView: panView,
                                                    expiryDateView: ExpiryDateView(),
                                                    cvcView: cvcView,
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
