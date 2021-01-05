@testable import AccessCheckoutSDK
import XCTest

class ExpiryDateViewTests: ViewTestSuite {
    // MARK: tests for the text formatting
    
    func testShouldAppendForwardSlashAfterMonthisEntered() {
        _ = initialiseCardValidation()
        
        XCTAssertEqual("02/", editExpiryDateAndGetResultingText("02"))
    }
    
    func testShouldBeAbleToEditMonthIndependentlyWithoutReformatting() {
        _ = initialiseCardValidation()
        
        XCTAssertEqual("01/29", editExpiryDateAndGetResultingText("01/29"))
        XCTAssertEqual("0/29", editExpiryDateAndGetResultingText("0/29"))
        XCTAssertEqual("/29", editExpiryDateAndGetResultingText("/29"))
        XCTAssertEqual("1/29", editExpiryDateAndGetResultingText("1/29"))
    }
    
    func testShouldReformatPastedNewDateOverwritingAnExistingOne() {
        _ = initialiseCardValidation()
        
        XCTAssertEqual("01/19", editExpiryDateAndGetResultingText("01/19"))
        XCTAssertEqual("12/99", editExpiryDateAndGetResultingText("1299"))
        XCTAssertEqual("12/98", editExpiryDateAndGetResultingText("1298"))
        XCTAssertEqual("12/98", editExpiryDateAndGetResultingText("12/98"))
        XCTAssertEqual("12/", editExpiryDateAndGetResultingText("12"))
        XCTAssertEqual("12", editExpiryDateAndGetResultingText("12"))
    }
    
    func testShouldBeAbleToDeleteCharactersToEmptyFromValidExpiryDate() {
        _ = initialiseCardValidation()
        
        XCTAssertEqual("12/99", editExpiryDateAndGetResultingText("12/99"))
        XCTAssertEqual("12/9", editExpiryDateAndGetResultingText("12/9"))
        XCTAssertEqual("12/", editExpiryDateAndGetResultingText("12/"))
        XCTAssertEqual("12", editExpiryDateAndGetResultingText("12"))
        XCTAssertEqual("1", editExpiryDateAndGetResultingText("1"))
        XCTAssertEqual("", editExpiryDateAndGetResultingText(""))
    }
    
    func testShouldBeAbleToDeleteCharactersToEmptyFromInvalidExpiryDate() {
        _ = initialiseCardValidation()
        
        XCTAssertEqual("13/99", editExpiryDateAndGetResultingText("13/99"))
        XCTAssertEqual("13/9", editExpiryDateAndGetResultingText("13/9"))
        XCTAssertEqual("13/", editExpiryDateAndGetResultingText("13/"))
        XCTAssertEqual("13", editExpiryDateAndGetResultingText("13"))
        XCTAssertEqual("1", editExpiryDateAndGetResultingText("1"))
        XCTAssertEqual("", editExpiryDateAndGetResultingText(""))
    }
    
    func testShouldNotReformatPastedValueWhenPastedValueIsSameAsCurrentValue() {
        _ = initialiseCardValidation()
        
        XCTAssertEqual("12/", editExpiryDateAndGetResultingText("12/"))
        XCTAssertEqual("12", editExpiryDateAndGetResultingText("12"))
    }
    
    func testShouldBeAbleToAddCharactersToComplete() {
        _ = initialiseCardValidation()
        
        XCTAssertEqual("", editExpiryDateAndGetResultingText(""))
        XCTAssertEqual("1", editExpiryDateAndGetResultingText("1"))
        XCTAssertEqual("12/", editExpiryDateAndGetResultingText("12"))
        XCTAssertEqual("12/", editExpiryDateAndGetResultingText("12/"))
        XCTAssertEqual("12/9", editExpiryDateAndGetResultingText("12/9"))
        XCTAssertEqual("12/99", editExpiryDateAndGetResultingText("12/99"))
    }
    
    func testShouldFormatSingleDigitsCorrectly_Overwrite() {
        _ = initialiseCardValidation()
        
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
            XCTAssertEqual(value, editExpiryDateAndGetResultingText(key))
        }
    }
    
    func testShouldFormatSingleDigitsCorrectly_NewlyEntered() {
        _ = initialiseCardValidation()
        
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
            _ = editExpiryDateAndGetResultingText("")
            XCTAssertEqual(value, editExpiryDateAndGetResultingText(key))
        }
    }
    
    func testShouldReformatWhenMonthValueChangesDespiteTheSeparatorBeingDeleted() {
        _ = initialiseCardValidation()
        
        XCTAssertEqual("02/", editExpiryDateAndGetResultingText("02/"))
        XCTAssertEqual("03/", editExpiryDateAndGetResultingText("03"))
    }
    
    func testShouldFormatDoubleDigitsCorrectly() {
        _ = initialiseCardValidation()
        
        let testDictionary = ["10": "10/",
                              "11": "11/",
                              "12": "12/",
                              "13": "01/3",
                              "14": "01/4",
                              "24": "02/4"]
        
        for (key, value) in testDictionary {
            _ = editExpiryDateAndGetResultingText("")
            XCTAssertEqual(value, editExpiryDateAndGetResultingText(key))
        }
    }
    
    func testShouldFormatTripleDigitsCorrectly() {
        _ = initialiseCardValidation()
        
        let testDictionary = ["100": "10/0",
                              "110": "11/0",
                              "120": "12/0",
                              "133": "01/33",
                              "143": "01/43",
                              "244": "02/44"]
        
        for (key, value) in testDictionary {
            _ = editExpiryDateAndGetResultingText("")
            XCTAssertEqual(value, editExpiryDateAndGetResultingText(key))
        }
    }
    
    // MARK: tests for clear
    
    func testCanClear() {
        _ = initialiseCardValidation()
        
        XCTAssertTrue(canEnterExpiryDate(""))
    }
    
    func testCanEnterAnyTextWhenNoPresenter() {
        XCTAssertTrue(canEnterExpiryDate("abc"))
    }
    
    func testCannotTypeNonNumericalCharactersButCanTypeSlash() {
        _ = initialiseCardValidation()
        
        XCTAssertFalse(canEnterExpiryDate("abc"))
        XCTAssertFalse(canEnterExpiryDate("+*-"))
        XCTAssertTrue(canEnterExpiryDate("/"))
    }
    
    // MARK: tests for what the control allows the user to type
    
    func testCanTypeUpTo5Digits() {
        _ = initialiseCardValidation()
        
        XCTAssertTrue(canEnterExpiryDate("1"))
        XCTAssertTrue(canEnterExpiryDate("12"))
        XCTAssertTrue(canEnterExpiryDate("123"))
        XCTAssertTrue(canEnterExpiryDate("1234"))
        XCTAssertTrue(canEnterExpiryDate("12345"))
    }
    
    func testCannotTypeMoreThan5Digits() {
        _ = initialiseCardValidation()
        
        XCTAssertFalse(canEnterExpiryDate("123456"))
    }
    
    func testCanTypeForwardSlashAtIncorrectPosition() {
        _ = initialiseCardValidation()
        
        XCTAssertTrue(canEnterExpiryDate("1234/"))
    }
    
    // MARK: text feature
    
    func testCanGetText() {
        expiryDateView.textField.text = "some text"
        
        XCTAssertEqual("some text", expiryDateView.text)
    }
    
    func testTextIsReturnedAsEmptyWhenTextFieldTextIsNil() {
        expiryDateView.textField.text = nil
        
        XCTAssertEqual("", expiryDateView.text)
    }
    
    // MARK: enabled feature
    
    func testCanGetTextFieldEnabledState() {
        expiryDateView.textField.isEnabled = false
        
        XCTAssertFalse(expiryDateView.isEnabled)
    }
    
    func testCanSetTextFieldEnabledState() {
        expiryDateView.textField.isEnabled = true
        expiryDateView.isEnabled = false
        
        XCTAssertFalse(expiryDateView.textField.isEnabled)
    }
    
    // MARK: text colour feature
    
    func testCanSetAndUnsetColourOfText() {
        expiryDateView.textColor = UIColor.red
        XCTAssertEqual(UIColor.red, expiryDateView.textField.textColor)
        
        expiryDateView.textColor = nil
        XCTAssertNotEqual(UIColor.red, expiryDateView.textField.textColor)
    }
    
    func testCanGetColourOfText() {
        expiryDateView.textField.textColor = UIColor.red
        
        XCTAssertEqual(UIColor.red, expiryDateView.textColor)
    }
    
    private func editExpiryDateAndGetResultingText(_ text: String) -> String {
        // This line is here to reproduce the behaviour where the state of the before applying the text to type would be saved by this call in production code when the text is being edited
        _ = expiryDateView.textField(expiryDateView.textField, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: "")
        
        editExpiryDate(text: text)
        return expiryDateView.textField!.text!
    }
}
