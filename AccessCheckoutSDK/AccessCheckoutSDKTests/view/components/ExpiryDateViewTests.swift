@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class ExpiryDateViewTests: XCTestCase {
    private let visaBrand = CardBrandModel(
        name: "visa",
        images: [],
        panValidationRule: ValidationRule(matcher: "^(?!^493698\\d*$)4\\d*$", validLengths: [16, 18, 19]),
        cvvValidationRule: ValidationRule(matcher: nil, validLengths: [3])
    )
    
    let expiryDateView = ExpiryDateView()
    
    // MARK: testing what the end user can and cannot type in Month
    func testCanEnterAnyTextInMonthWhenNoPresenter() {
        XCTAssertTrue(typeMonth("abc", into: expiryDateView))
    }
    
    func testCanClearMonth() {
        initialiseValidation(expiryDateView: expiryDateView)
        XCTAssertTrue(typeMonth("", into: expiryDateView))
    }
    
    func testCannotTypeNonNumericalCharactersInMonth() {
        initialiseValidation(expiryDateView: expiryDateView)
        
        XCTAssertFalse(typeMonth("abc", into: expiryDateView))
        XCTAssertFalse(typeMonth("+*-", into: expiryDateView))
    }
    
    func testCanTypeStartOfMonth() {
        initialiseValidation(expiryDateView: expiryDateView)
        let result = typeMonth("1", into: expiryDateView)
        
        XCTAssertTrue(result)
    }
    
    func testCanTypeFullMonth() {
        initialiseValidation(expiryDateView: expiryDateView)
        
        let result = typeMonth("12", into: expiryDateView)
        
        XCTAssertTrue(result)
    }
    
    func testCannotTypeMonthThatExceedsMaximiumLength() {
        initialiseValidation(expiryDateView: expiryDateView)
        
        let result = typeMonth("123", into: expiryDateView)
        
        XCTAssertFalse(result)
    }
    
    // MARK: testing what the end user can and cannot type in Year
    func testCanEnterAnyTextInYearWhenNoPresenter() {
        XCTAssertTrue(typeYear("abc", into: expiryDateView))
    }
    
    func testCanClearYear() {
        initialiseValidation(expiryDateView: expiryDateView)
        XCTAssertTrue(typeYear("", into: expiryDateView))
    }
    
    func testCannotTypeNonNumericalCharactersInYear() {
        initialiseValidation(expiryDateView: expiryDateView)
        
        let result = typeYear("abc", into: expiryDateView)
        
        XCTAssertFalse(result)
    }
    
    func testCanTypeStartOfYear() {
        initialiseValidation(expiryDateView: expiryDateView)
        
        let result = typeYear("1", into: expiryDateView)
        
        XCTAssertTrue(result)
    }
    
    func testCanTypeFullFutureYear() {
        initialiseValidation(expiryDateView: expiryDateView)
        
        let result = typeYear("35", into: expiryDateView)
        
        XCTAssertTrue(result)
    }
    
    func testCanTypeFullPastYear() {
        initialiseValidation(expiryDateView: expiryDateView)
        
        let result = typeYear("19", into: expiryDateView)
        
        XCTAssertTrue(result)
    }
    
    func testCannotTypeYearThatExceedsMaximiumLength() {
        initialiseValidation(expiryDateView: expiryDateView)
        
        let result = typeYear("123", into: expiryDateView)
        
        XCTAssertFalse(result)
    }
    
    // MARK: testing the text colour feature
    func testCanSetColourOfText() {
        expiryDateView.textColor = UIColor.red
        
        XCTAssertEqual(UIColor.red, expiryDateView.monthTextField.textColor)
        XCTAssertEqual(UIColor.red, expiryDateView.yearTextField.textColor)
    }
    
    func testUnsetColourOfTextSetsColourToDefault() {
        expiryDateView.textColor = nil
        
        XCTAssertEqual(UIColor.black, expiryDateView.monthTextField.textColor)
        XCTAssertEqual(UIColor.black, expiryDateView.yearTextField.textColor)
    }
    
    private func typeMonth(_ text: String, into view: ExpiryDateView) -> Bool {
        let range = NSRange(location: 0, length: 0)
        
        return view.textField(view.monthTextField, shouldChangeCharactersIn: range, replacementString: text)
    }
    
    private func typeYear(_ text: String, into view: ExpiryDateView) -> Bool {
        let range = NSRange(location: 0, length: 0)
        
        return view.textField(view.yearTextField, shouldChangeCharactersIn: range, replacementString: text)
    }
    
    private func initialiseValidation(expiryDateView: ExpiryDateView) {
        let merchantDelegate = createMerchantDelegate()
        let configurationProvider = createConfigurationProvider(with: [visaBrand])
        
        let validationConfig = CardValidationConfig(panView: PANView(),
                                                    expiryDateView: expiryDateView,
                                                    cvvView: CVVView(),
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
        merchantDelegate.getStubbingProxy().cvvValidChanged(isValid: any()).thenDoNothing()
        
        return merchantDelegate
    }
}
