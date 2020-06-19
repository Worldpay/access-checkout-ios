@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class PANViewTests: XCTestCase {
    private let visaBrand = TextFixtures.createCardBrandModel(
        name: "visa",
        panPattern: "^(?!^493698\\d*$)4\\d*$",
        panValidLengths: [16, 18, 19],
        cvcValidLength: 3)
    private let maestroBrand = TextFixtures.createCardBrandModel(
        name: "maestro",
        panPattern: "^493698\\d*$",
        panValidLengths: [16, 18, 19],
        cvcValidLength: 3)
    
    let panView = PANView()
    
    // MARK: testing what the end user can and cannot type
    
    func testCanEnterAnyTextWhenNoPresenter() {
        XCTAssertTrue(type("abc", into: panView))
    }
    
    func testCanClearText() {
        initialiseValidation(cardBrands: [visaBrand], panView: panView)
        XCTAssertTrue(type("", into: panView))
    }
    
    func testCannotTypeNonNumericalCharacters() {
        initialiseValidation(cardBrands: [visaBrand], panView: panView)
        
        XCTAssertFalse(type("abc", into: panView))
        XCTAssertFalse(type("+*-", into: panView))
    }
    
    func testCanTypeValidVisaPan() {
        initialiseValidation(cardBrands: [visaBrand], panView: panView)
        
        let result = type("4111111111111111", into: panView)
        
        XCTAssertTrue(result)
    }
    
    func testCanTypeVisaPanThatFailsLuhnCheck() {
        initialiseValidation(cardBrands: [visaBrand], panView: panView)
        
        let result = type("4111111111111112", into: panView)
        
        XCTAssertTrue(result)
    }
    
    func testCanTypeVisaPanAsLongAsMaxLengthAllowed() {
        initialiseValidation(cardBrands: [visaBrand], panView: panView)
        
        let result = type("4111111111111111111", into: panView)
        
        XCTAssertTrue(result)
    }
    
    func testCannotTypeVisaPanThatExceedsMaximiumLength() {
        initialiseValidation(cardBrands: [visaBrand], panView: panView)
        
        let result = type("41111111111111111111", into: panView)
        
        XCTAssertFalse(result)
    }
    
    //  This test is important because the Visa pattern excludes explictly the Maestro pattern so we want
    // to make sure that it does not prevent the user from typing a maestro PAN
    func testCanTypeStartOfMaestroPan() {
        initialiseValidation(cardBrands: [visaBrand, maestroBrand], panView: panView)
        
        let result = type("493698123", into: panView)
        
        XCTAssertTrue(result)
    }
    
    func testCanTypePanOfUnknownBrandAsLongAsMaxLengthAllowed() {
        initialiseValidation(cardBrands: [], panView: panView)
        
        let result = type("1234567890123456789", into: panView)
        
        XCTAssertTrue(result)
    }
    
    func testCannotTypePanOfUnknownBrandThatExceedsMaximiumLength() {
        initialiseValidation(cardBrands: [], panView: panView)
        
        let result = type("12345678901234567890", into: panView)
        
        XCTAssertFalse(result)
    }
    
    // MARK: text feature
    
    func testCanGetText() {
        panView.textField.text = "some text"
        
        XCTAssertEqual("some text", panView.text)
    }
    
    // MARK: enabled feature
    
    func testCanGetTextFieldEnabledState() {
        panView.textField.isEnabled = false
        
        XCTAssertFalse(panView.isEnabled)
    }
    
    func testCanSetTextFieldEnabledState() {
        panView.textField.isEnabled = true
        panView.isEnabled = false
        
        XCTAssertFalse(panView.textField.isEnabled)
    }
    
    // MARK: text colour feature
    
    func testCanSetColourOfText() {
        panView.textColor = UIColor.red
        
        XCTAssertEqual(UIColor.red, panView.textField.textColor)
    }
    
    func testUnsetColourOfTextSetsColourToDefault() {
        panView.textColor = nil
        
        XCTAssertEqual(UIColor.black, panView.textField.textColor)
    }
    
    func testCanGetColourOfText() {
        panView.textField.textColor = UIColor.red
        
        XCTAssertEqual(UIColor.red, panView.textColor)
    }
    
    private func type(_ text: String, into view: PANView) -> Bool {
        let range = NSRange(location: 0, length: 0)
        
        return view.textField(view.textField, shouldChangeCharactersIn: range, replacementString: text)
    }
    
    private func initialiseValidation(cardBrands: [CardBrandModel], panView: PANView) {
        let expiryDateview = ExpiryDateView()
        let cvcView = CvcView()
        let merchantDelegate = createMerchantDelegate()
        
        let configurationProvider = createConfigurationProvider(with: cardBrands)
        
        let validationConfig = CardValidationConfig(panView: panView,
                                                    expiryDateView: expiryDateview,
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
