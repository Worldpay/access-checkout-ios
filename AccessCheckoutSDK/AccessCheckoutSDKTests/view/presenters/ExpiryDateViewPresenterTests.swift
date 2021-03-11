@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class ExpiryDateViewPresenterTests: PresenterTestSuite {
    private let expiryDateValidatorMock = MockExpiryDateValidator()
    private let expiryDateValidationFlow = mockExpiryDateValidationFlow()

    override func setUp() {
        expiryDateValidationFlow.getStubbingProxy().validate(expiryDate: any()).thenDoNothing()
        expiryDateValidationFlow.getStubbingProxy().notifyMerchantIfNotAlreadyNotified().thenDoNothing()
        expiryDateValidatorMock.getStubbingProxy().canValidate(any()).thenReturn(true)
    }

    func testOnEditingValidatesExpiryDate() {
        let expiryDate = "11/22"
        let presenter = ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidatorMock)

        presenter.onEditing(text: expiryDate)

        verify(expiryDateValidationFlow).validate(expiryDate: expiryDate)
    }

    func testOnEditEndNotifiesMerchantOfValidationStateIfNotAlreadyNotified() {
        let expiryDate = "11/2"
        let presenter = ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidatorMock)

        presenter.onEditEnd(text: expiryDate)

        verify(expiryDateValidationFlow).notifyMerchantIfNotAlreadyNotified()
    }

    func testCanChangeTextWithEmptyText() {
        let text = ""
        let presenter = ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidatorMock)

        let result = presenter.canChangeText(with: text)

        XCTAssertTrue(result)
    }

    func testCanChangeTextChecksIfTextCanBeEnteredAndDoesNotTriggerValidationFlow() {
        let text = "12"
        let presenter = ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidatorMock)

        _ = presenter.canChangeText(with: text)

        verify(expiryDateValidatorMock).canValidate(text)
        verifyNoMoreInteractions(expiryDateValidationFlow)
    }

    private static func mockExpiryDateValidationFlow() -> MockExpiryDateValidationFlow {
        let validator = ExpiryDateValidator()
        let validationStateHandler = CardValidationStateHandler(MockAccessCheckoutCardValidationDelegate())

        return MockExpiryDateValidationFlow(validator, validationStateHandler)
    }

    // MARK: Tests for presenter with UITextField

    func testTextFieldEndEditingValidatesExpiryDate() {
        let expiryDate = "11/22"
        let presenter = ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidatorMock)
        expiryDateTextField.text = expiryDate
        presenter.textFieldEditingChanged(expiryDateTextField)

        presenter.textFieldDidEndEditing(expiryDateTextField)
        verify(expiryDateValidationFlow).validate(expiryDate: expiryDate)
    }

    func testTextFieldDidEndEditingNotifiesMerchantOfValidationStateIfNotAlreadyNotified() {
        let expiryDate = "11/2"

        expiryDateTextField.text = expiryDate
        let presenter = ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidatorMock)

        presenter.textFieldDidEndEditing(expiryDateTextField)
        verify(expiryDateValidationFlow).notifyMerchantIfNotAlreadyNotified()
    }

    // MARK: tests for the text formatting

    func testShouldAppendForwardSlashAfterMonthisEntered() {
        let presenter = ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidatorMock)

        XCTAssertEqual("02/", editExpiryDateAndGetResultingText(presenter: presenter, "02"))
    }

    func testShouldBeAbleToEditMonthIndependentlyWithoutReformatting() {
        let presenter = ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidatorMock)

        XCTAssertEqual("01/29", editExpiryDateAndGetResultingText(presenter: presenter, "01/29"))
        XCTAssertEqual("0/29", editExpiryDateAndGetResultingText(presenter: presenter, "0/29"))
        XCTAssertEqual("/29", editExpiryDateAndGetResultingText(presenter: presenter, "/29"))
        XCTAssertEqual("1/29", editExpiryDateAndGetResultingText(presenter: presenter, "1/29"))
    }

    func testShouldReformatPastedNewDateOverwritingAnExistingOne() {
        let presenter = ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidatorMock)

        XCTAssertEqual("01/19", editExpiryDateAndGetResultingText(presenter: presenter, "01/19"))
        XCTAssertEqual("12/99", editExpiryDateAndGetResultingText(presenter: presenter, "1299"))
        XCTAssertEqual("12/98", editExpiryDateAndGetResultingText(presenter: presenter, "1298"))
        XCTAssertEqual("12/98", editExpiryDateAndGetResultingText(presenter: presenter, "12/98"))
        XCTAssertEqual("12/", editExpiryDateAndGetResultingText(presenter: presenter, "12"))
        XCTAssertEqual("12", editExpiryDateAndGetResultingText(presenter: presenter, "12"))
    }

    func testShouldBeAbleToDeleteCharactersToEmptyFromValidExpiryDate() {
        let presenter = ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidatorMock)

        XCTAssertEqual("12/99", editExpiryDateAndGetResultingText(presenter: presenter, "12/99"))
        XCTAssertEqual("12/9", editExpiryDateAndGetResultingText(presenter: presenter, "12/9"))
        XCTAssertEqual("12/", editExpiryDateAndGetResultingText(presenter: presenter, "12/"))
        XCTAssertEqual("12", editExpiryDateAndGetResultingText(presenter: presenter, "12"))
        XCTAssertEqual("1", editExpiryDateAndGetResultingText(presenter: presenter, "1"))
        XCTAssertEqual("", editExpiryDateAndGetResultingText(presenter: presenter, ""))
    }

    func testShouldBeAbleToDeleteCharactersToEmptyFromInvalidExpiryDate() {
        let presenter = ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidatorMock)

        XCTAssertEqual("13/99", editExpiryDateAndGetResultingText(presenter: presenter, "13/99"))
        XCTAssertEqual("13/9", editExpiryDateAndGetResultingText(presenter: presenter, "13/9"))
        XCTAssertEqual("13/", editExpiryDateAndGetResultingText(presenter: presenter, "13/"))
        XCTAssertEqual("13", editExpiryDateAndGetResultingText(presenter: presenter, "13"))
        XCTAssertEqual("1", editExpiryDateAndGetResultingText(presenter: presenter, "1"))
        XCTAssertEqual("", editExpiryDateAndGetResultingText(presenter: presenter, ""))
    }

    func testShouldNotReformatPastedValueWhenPastedValueIsSameAsCurrentValue() {
        let presenter = ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidatorMock)

        XCTAssertEqual("12/", editExpiryDateAndGetResultingText(presenter: presenter, "12/"))
        XCTAssertEqual("12", editExpiryDateAndGetResultingText(presenter: presenter, "12"))
    }

    func testShouldBeAbleToAddCharactersToComplete() {
        let presenter = ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidatorMock)

        XCTAssertEqual("", editExpiryDateAndGetResultingText(presenter: presenter, ""))
        XCTAssertEqual("1", editExpiryDateAndGetResultingText(presenter: presenter, "1"))
        XCTAssertEqual("12/", editExpiryDateAndGetResultingText(presenter: presenter, "12"))
        XCTAssertEqual("12/", editExpiryDateAndGetResultingText(presenter: presenter, "12/"))
        XCTAssertEqual("12/9", editExpiryDateAndGetResultingText(presenter: presenter, "12/9"))
        XCTAssertEqual("12/99", editExpiryDateAndGetResultingText(presenter: presenter, "12/99"))
    }

    func testShouldFormatSingleDigitsCorrectly_Overwrite() {
        let presenter = ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidatorMock)

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
            XCTAssertEqual(value, editExpiryDateAndGetResultingText(presenter: presenter, key))
        }
    }

    func testShouldFormatSingleDigitsCorrectly_NewlyEntered() {
        let presenter = ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidatorMock)

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
            _ = editExpiryDateAndGetResultingText(presenter: presenter, "")
            XCTAssertEqual(value, editExpiryDateAndGetResultingText(presenter: presenter, key))
        }
    }

    func testShouldReformatWhenMonthValueChangesDespiteTheSeparatorBeingDeleted() {
        let presenter = ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidatorMock)

        XCTAssertEqual("02/", editExpiryDateAndGetResultingText(presenter: presenter, "02/"))
        XCTAssertEqual("03/", editExpiryDateAndGetResultingText(presenter: presenter, "03"))
    }

    func testShouldFormatDoubleDigitsCorrectly() {
        let presenter = ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidatorMock)

        let testDictionary = ["10": "10/",
                              "11": "11/",
                              "12": "12/",
                              "13": "01/3",
                              "14": "01/4",
                              "24": "02/4"]

        for (key, value) in testDictionary {
            _ = editExpiryDateAndGetResultingText(presenter: presenter, "")
            XCTAssertEqual(value, editExpiryDateAndGetResultingText(presenter: presenter, key))
        }
    }

    func testShouldFormatTripleDigitsCorrectly() {
        let presenter = ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidatorMock)

        let testDictionary = ["100": "10/0",
                              "110": "11/0",
                              "120": "12/0",
                              "133": "01/33",
                              "143": "01/43",
                              "244": "02/44"]

        for (key, value) in testDictionary {
            _ = editExpiryDateAndGetResultingText(presenter: presenter, "")
            XCTAssertEqual(value, editExpiryDateAndGetResultingText(presenter: presenter, key))
        }
    }

    // MARK: tests for what the control allows the user to type

    func testCannotTypeIfValidatorReturnsFalse() {
        expiryDateValidatorMock.getStubbingProxy().canValidate(any()).thenReturn(false)
        let presenter = ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidatorMock)

        XCTAssertFalse(canEnterExpiryDate(presenter: presenter, uiTextField: expiryDateTextField, "12"))
    }

    func testCanTypeIfValidatorReturnsFalse() {
        expiryDateValidatorMock.getStubbingProxy().canValidate(any()).thenReturn(true)
        let presenter = ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidatorMock)

        XCTAssertTrue(canEnterExpiryDate(presenter: presenter, uiTextField: expiryDateTextField, "12"))
    }

    private func editExpiryDateAndGetResultingText(presenter: ExpiryDateViewPresenter, _ text: String) -> String {
        // This line is here to reproduce the behaviour where the state of the before applying the text to type would be saved by this call in production code when the text is being edited
        _ = presenter.textField(expiryDateTextField, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: "")

        expiryDateTextField.text = text
        presenter.textFieldEditingChanged(expiryDateTextField)
        return expiryDateTextField.text!
    }
}
