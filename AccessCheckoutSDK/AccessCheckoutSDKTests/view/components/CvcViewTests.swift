@testable import AccessCheckoutSDK
import XCTest

class CvcViewTests: ViewTestSuite {
    private let brandsStartingWith4AndCvc2DigitsLong = TestFixtures.createCardBrandModel(
        name: "a-brand",
        panPattern: "^4\\d*$",
        panValidLengths: [16],
        cvcValidLength: 2
    )
    
    // MARK: testing what the end user can and cannot type
    
    func testCanEnterAnyTextWhenNoPresenter() {
        XCTAssertTrue(canEnterCvc("abc"))
    }
    
    func testCanClearText() {
        _ = initialiseCardValidation()
        
        XCTAssertTrue(canEnterCvc(""))
    }
    
    func testCannotTypeNonNumericalCharactersForUnknownBrand() {
        _ = initialiseCardValidation()
        
        XCTAssertFalse(canEnterCvc("abc"))
        XCTAssertFalse(canEnterCvc("+*-"))
    }
    
    func testCanTypePartialCvcForUnknownBrand() {
        _ = initialiseCardValidation()
        
        XCTAssertTrue(canEnterCvc("12"))
    }
    
    func testCanTypeCvcAsLongAsMinLengthForUnknownBrand() {
        _ = initialiseCardValidation()
        
        XCTAssertTrue(canEnterCvc("123"))
    }
    
    func testCanTypeCvcAsLongAsMaxLengthForUnknownBrand() {
        _ = initialiseCardValidation()
        
        XCTAssertTrue(canEnterCvc("1234"))
    }
    
    func testCannotTypeCvcThatExceedsMaximiumLengthForUnknownBrand() {
        _ = initialiseCardValidation()
        
        XCTAssertFalse(canEnterCvc("12345"))
    }
    
    func testCannotTypeNonNumericalCharactersForABrand() {
        _ = initialiseCardValidation(cardBrands: [brandsStartingWith4AndCvc2DigitsLong])
        editPan(text: "4")
        
        XCTAssertFalse(canEnterCvc("ab"))
        XCTAssertFalse(canEnterCvc("+*"))
    }
    
    func testCanTypePartialCvcForABrand() {
        _ = initialiseCardValidation(cardBrands: [brandsStartingWith4AndCvc2DigitsLong])
        editPan(text: "4")
        
        XCTAssertTrue(canEnterCvc("1"))
    }
    
    func testCanTypeValidCvcForABrand() {
        _ = initialiseCardValidation(cardBrands: [brandsStartingWith4AndCvc2DigitsLong])
        editPan(text: "4")
        
        XCTAssertTrue(canEnterCvc("12"))
    }
    
    func testCannotTypeCvcThatExceedsMaximiumLengthForABrand() {
        _ = initialiseCardValidation(cardBrands: [brandsStartingWith4AndCvc2DigitsLong])
        editPan(text: "4")
        
        XCTAssertFalse(canEnterCvc("123"))
    }
    
    // MARK: text feature
    
    func testCanGetText() {
        cvcView.textField.text = "some text"
        
        XCTAssertEqual("some text", cvcView.text)
    }
    
    func testTextIsReturnedAsEmptyWhenTextFieldTextIsNil() {
        cvcView.textField.text = nil
        
        XCTAssertEqual("", cvcView.text)
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
}
