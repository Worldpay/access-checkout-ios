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
    
    // MARK: tests for the text formatting
    
    func testShouldAppendForwardSlashAfterMonthisEntered() {
        initialiseValidation(expiryDateView: expiryDateView)
        
        XCTAssertEqual("02/", typeAndGetText("02", into: expiryDateView))
    }
    
    func testShouldBeAbleToEditMonthIndependentlyWithoutReformatting() {
        initialiseValidation(expiryDateView: expiryDateView)
        
        XCTAssertEqual("01/29", typeAndGetText("01/29", into: expiryDateView))
        XCTAssertEqual("0/29", typeAndGetText("0/29", into: expiryDateView))
        XCTAssertEqual("/29", typeAndGetText("/29", into: expiryDateView))
        XCTAssertEqual("1/29", typeAndGetText("1/29", into: expiryDateView))
    }
    
    func testShouldReformatPastedNewDateOverwritingAnExistingOne() {
        initialiseValidation(expiryDateView: expiryDateView)
        
        XCTAssertEqual("01/19", typeAndGetText("01/19", into: expiryDateView))
        XCTAssertEqual("12/99", typeAndGetText("1299", into: expiryDateView))
        XCTAssertEqual("12/98", typeAndGetText("1298", into: expiryDateView))
        XCTAssertEqual("12/98", typeAndGetText("12/98", into: expiryDateView))
        XCTAssertEqual("12/", typeAndGetText("12", into: expiryDateView))
        XCTAssertEqual("12", typeAndGetText("12", into: expiryDateView))
    }
    
    func testShouldBeAbleToDeleteCharactersToEmptyFromValidExpiryDate() {
        initialiseValidation(expiryDateView: expiryDateView)
        
        XCTAssertEqual("12/99", typeAndGetText("12/99", into: expiryDateView))
        XCTAssertEqual("12/9", typeAndGetText("12/9", into: expiryDateView))
        XCTAssertEqual("12/", typeAndGetText("12/", into: expiryDateView))
        XCTAssertEqual("12", typeAndGetText("12", into: expiryDateView))
        XCTAssertEqual("1", typeAndGetText("1", into: expiryDateView))
        XCTAssertEqual("", typeAndGetText("", into: expiryDateView))
    }
    
    func testShouldBeAbleToDeleteCharactersToEmptyFromInvalidExpiryDate() {
        initialiseValidation(expiryDateView: expiryDateView)
        
        XCTAssertEqual("13/99", typeAndGetText("13/99", into: expiryDateView))
        XCTAssertEqual("13/9", typeAndGetText("13/9", into: expiryDateView))
        XCTAssertEqual("13/", typeAndGetText("13/", into: expiryDateView))
        XCTAssertEqual("13", typeAndGetText("13", into: expiryDateView))
        XCTAssertEqual("1", typeAndGetText("1", into: expiryDateView))
        XCTAssertEqual("", typeAndGetText("", into: expiryDateView))
    }
    
    func testShouldNotReformatPastedValueWhenPastedValueIsSameAsCurrentValue() {
        initialiseValidation(expiryDateView: expiryDateView)
        
        XCTAssertEqual("12/", typeAndGetText("12/", into: expiryDateView))
        XCTAssertEqual("12", typeAndGetText("12", into: expiryDateView))
    }
    
    func testShouldBeAbleToAddCharactersToComplete() {
        initialiseValidation(expiryDateView: expiryDateView)
        
        XCTAssertEqual("", typeAndGetText("", into: expiryDateView))
        XCTAssertEqual("1", typeAndGetText("1", into: expiryDateView))
        XCTAssertEqual("12/", typeAndGetText("12", into: expiryDateView))
        XCTAssertEqual("12/", typeAndGetText("12/", into: expiryDateView))
        XCTAssertEqual("12/9", typeAndGetText("12/9", into: expiryDateView))
        XCTAssertEqual("12/99", typeAndGetText("12/99", into: expiryDateView))
    }
    
    func testShouldFormatSingleDigitsCorrectly_Overwrite() {
        initialiseValidation(expiryDateView: expiryDateView)
        
        let testDictionary = ["1": "1",
                              "2": "02/",
                              "3": "03/",
                              "4": "04/",
                              "5": "05/",
                              "6": "06/",
                              "7": "07/",
                              "8": "08/",
                              "9": "09/"]
        
        for (key, value) in testDictionary {
            XCTAssertEqual(value, typeAndGetText(key, into: expiryDateView))
        }
    }
    
    func testShouldFormatSingleDigitsCorrectly_NewlyEntered() {
        initialiseValidation(expiryDateView: expiryDateView)
        
        let testDictionary = ["1": "1",
                              "2": "02/",
                              "3": "03/",
                              "4": "04/",
                              "5": "05/",
                              "6": "06/",
                              "7": "07/",
                              "8": "08/",
                              "9": "09/"]
        
        for (key, value) in testDictionary {
            _ = typeAndGetText("", into: expiryDateView)
            XCTAssertEqual(value, typeAndGetText(key, into: expiryDateView))
        }
    }
    
    func testShouldReformatWhenMonthValueChangesDespiteTheSeparatorBeingDeleted() {
        initialiseValidation(expiryDateView: expiryDateView)
        
        XCTAssertEqual("02/", typeAndGetText("02/", into: expiryDateView))
        XCTAssertEqual("03/", typeAndGetText("03", into: expiryDateView))
    }
    
    func testShouldFormatDoubleDigitsCorrectly() {
        initialiseValidation(expiryDateView: expiryDateView)
        
        let testDictionary = ["10": "10/",
                              "11": "11/",
                              "12": "12/",
                              "13": "01/3",
                              "14": "01/4",
                              "24": "02/4"]
        
        for (key, value) in testDictionary {
            _ = typeAndGetText("", into: expiryDateView)
            XCTAssertEqual(value, typeAndGetText(key, into: expiryDateView))
        }
    }
    
    func testShouldFormatTripleDigitsCorrectly() {
        initialiseValidation(expiryDateView: expiryDateView)
        
        let testDictionary = ["100": "10/0",
                              "110": "11/0",
                              "120": "12/0",
                              "133": "01/33",
                              "143": "01/43",
                              "244": "02/44"]
        
        for (key, value) in testDictionary {
            _ = typeAndGetText("", into: expiryDateView)
            XCTAssertEqual(value, typeAndGetText(key, into: expiryDateView))
        }
    }
    
    // MARK: tests for clear
    
    func testCanClear() {
        initialiseValidation(expiryDateView: expiryDateView)
        
        XCTAssertTrue(canType("", into: expiryDateView))
    }
    
    func testCanEnterAnyTextWhenNoPresenter() {
        XCTAssertTrue(canType("abc", into: expiryDateView))
    }
    
    func testCannotTypeNonNumericalCharactersButCanTypeSlash() {
        initialiseValidation(expiryDateView: expiryDateView)
        
        XCTAssertFalse(canType("abc", into: expiryDateView))
        XCTAssertFalse(canType("+*-", into: expiryDateView))
        XCTAssertTrue(canType("/", into: expiryDateView))
    }
    
    // MARK: tests for what the control allows the user to type
    
    func testCanTypeUpTo5Digits() {
        initialiseValidation(expiryDateView: expiryDateView)
        
        XCTAssertTrue(canType("1", into: expiryDateView))
        XCTAssertTrue(canType("12", into: expiryDateView))
        XCTAssertTrue(canType("123", into: expiryDateView))
        XCTAssertTrue(canType("1234", into: expiryDateView))
        XCTAssertTrue(canType("12345", into: expiryDateView))
    }
    
    func testCannotTypeMoreThan5Digits() {
        initialiseValidation(expiryDateView: expiryDateView)
        
        XCTAssertFalse(canType("123456", into: expiryDateView))
    }
    
    func testCanTypeForwardSlashAtIncorrectPosition() {
        initialiseValidation(expiryDateView: expiryDateView)
        
        XCTAssertTrue(canType("1234/", into: expiryDateView))
    }
    
    // MARK: testing the text colour feature
    
    func testCanSetColourOfText() {
        expiryDateView.textColor = UIColor.red
        
        XCTAssertEqual(UIColor.red, expiryDateView.textField.textColor)
    }
    
    func testUnsetColourOfTextSetsColourToDefault() {
        expiryDateView.textColor = nil
        
        XCTAssertEqual(UIColor.black, expiryDateView.textField.textColor)
    }
    
    private func typeAndGetText(_ text: String, into expiryDateView: ExpiryDateView) -> String {
        // This line is here to reproduce the behaviour where the text before change would be saved by this call in production code when the text is being edited
        _ = expiryDateView.textField(expiryDateView.textField, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: "")
        
        expiryDateView.textField.text = text
        expiryDateView.textFieldEditingChanged(expiryDateView.textField)
        return expiryDateView.textField!.text!
    }
    
    private func canType(_ text: String, into view: ExpiryDateView) -> Bool {
        let range = NSRange(location: 0, length: 0)
        
        return view.textField(view.textField, shouldChangeCharactersIn: range, replacementString: text)
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
