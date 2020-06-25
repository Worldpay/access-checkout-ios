@testable import AccessCheckoutSDK
import XCTest

class PanViewTests: ViewTestSuite {
    private let visaBrand = TestFixtures.visaBrand()
    private let maestroBrand = TestFixtures.maestroBrand()
    
    private let validVisaPan = TestFixtures.validVisaPan1
    private let validVisaPanAsLongAsMaxLengthAllowed = TestFixtures.validVisaPanAsLongAsMaxLengthAllowed
    private let visaPanThatFailsLuhnCheck = TestFixtures.visaPanThatFailsLuhnCheck
    private let visaPanTooLong = TestFixtures.visaPanTooLong
    
    // MARK: testing what the end user can and cannot type
    
    func testCanEnterAnyTextWhenNoPresenter() {
        XCTAssertTrue(canEnterPan("abc"))
    }
    
    func testCanClearText() {
        _ = initialiseCardValidation(cardBrands: [visaBrand])
        XCTAssertTrue(canEnterPan(""))
    }
    
    func testCannotTypeNonNumericalCharacters() {
        _ = initialiseCardValidation(cardBrands: [visaBrand])
        
        XCTAssertFalse(canEnterPan("abc"))
        XCTAssertFalse(canEnterPan("+*-"))
    }
    
    func testCanTypeValidVisaPan() {
        _ = initialiseCardValidation(cardBrands: [visaBrand])
        
        XCTAssertTrue(canEnterPan(validVisaPan))
    }
    
    func testCanTypeVisaPanThatFailsLuhnCheck() {
        _ = initialiseCardValidation(cardBrands: [visaBrand])
        
        XCTAssertTrue(canEnterPan(visaPanThatFailsLuhnCheck))
    }
    
    func testCanTypeVisaPanAsLongAsMaxLengthAllowed() {
        _ = initialiseCardValidation(cardBrands: [visaBrand])
        
        XCTAssertTrue(canEnterPan(validVisaPanAsLongAsMaxLengthAllowed))
    }
    
    func testCannotTypeVisaPanThatExceedsMaximiumLength() {
        _ = initialiseCardValidation(cardBrands: [visaBrand])
        
        XCTAssertFalse(canEnterPan(visaPanTooLong))
    }
    
    //  This test is important because the Visa pattern excludes explictly the Maestro pattern so we want
    // to make sure that it does not prevent the user from typing a maestro PAN
    func testCanTypeStartOfMaestroPan() {
        _ = initialiseCardValidation(cardBrands: [visaBrand, maestroBrand])
        
        XCTAssertTrue(canEnterPan("493698123"))
    }
    
    func testCanTypePanOfUnknownBrandAsLongAsMaxLengthAllowed() {
        _ = initialiseCardValidation(cardBrands: [])
        
        XCTAssertTrue(canEnterPan("1234567890123456789"))
    }
    
    func testCannotTypePanOfUnknownBrandThatExceedsMaximiumLength() {
        _ = initialiseCardValidation(cardBrands: [])
        
        XCTAssertFalse(canEnterPan("12345678901234567890"))
    }
    
    // MARK: text feature
    
    func testCanGetText() {
        panView.textField.text = "some text"
        
        XCTAssertEqual("some text", panView.text)
    }
    
    func testTextIsReturnedAsEmptyWhenTextFieldTextIsNil() {
        panView.textField.text = nil
        
        XCTAssertEqual("", panView.text)
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
}
