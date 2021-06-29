@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class PanViewPresenterCardSpacingTests: PresenterTestSuite {
    private let panValidationFlowMock = mockPanValidationFlow()

    private let visaBrand = TestFixtures.visaBrand()
    private let maestroBrand = TestFixtures.maestroBrand()
    private let unknownBrand = TestFixtures.unknownBrand()
    private let configurationProvider = MockCardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock())

    private let validVisaPan = TestFixtures.validVisaPan1
    private let validVisaPanWithSpaces = TestFixtures.validVisaPan1WithSpaces

    private let validVisaPanAsLongAsMaxLengthAllowed = TestFixtures.validVisaPanAsLongAsMaxLengthAllowed
    private let validVisaPanAsLongAsMaxLengthAllowedWithSpaces = TestFixtures.validVisaPanAsLongAsMaxLengthAllowedWithSpaces

    private let visaPanThatFailsLuhnCheck = TestFixtures.visaPanThatFailsLuhnCheck
    private let visaPanThatFailsLuhnCheckWithSpaces = TestFixtures.visaPanThatFailsLuhnCheckWithSpaces

    private let visaPanTooLong = TestFixtures.visaPanTooLong
    private let visaPanTooLongWithSpaces = TestFixtures.visaPanTooLongWithSpaces

    override func setUp() {
        panValidationFlowMock.getStubbingProxy().validate(pan: any()).thenDoNothing()
        panValidationFlowMock.getStubbingProxy().notifyMerchantIfNotAlreadyNotified().thenDoNothing()
    }

    private static func mockPanValidationFlow() -> MockPanValidationFlow {
        let validationStateHandler = CardValidationStateHandler(MockAccessCheckoutCardValidationDelegate())
        let cvcValidationFlow = MockCvcValidationFlow(CvcValidator(), validationStateHandler)
        let configurationProvider = MockCardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock())
        let panValidator = PanValidator(configurationProvider)

        return MockPanValidationFlow(panValidator, validationStateHandler, cvcValidationFlow)
    }

    private func createPresenterWithCardSpacing(detectedCardBrand: CardBrandModel?) -> PanViewPresenter {
        let panFormattingEnabled = true
        let cardBrandsConfiguration = CardBrandsConfiguration(allCardBrands: [visaBrand, maestroBrand], acceptedCardBrands: [])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        panValidationFlowMock.getStubbingProxy().getCardBrand().thenReturn(detectedCardBrand)

        let panValidator = PanValidator(configurationProvider)
        return PanViewPresenter(panValidationFlowMock, panValidator, panFormattingEnabled: panFormattingEnabled)
    }

    private func caretPosition() -> Int {
        return panTextField.offset(from: panTextField.beginningOfDocument, to: panTextField.selectedTextRange!.start)
    }

    private func waitThen(assertClosure: @escaping () -> Void) {
        let timeoutInSeconds = 0.1
        let exp = XCTestCase().expectation(description: "Waiting for \(timeoutInSeconds)")
        _ = XCTWaiter.wait(for: [exp], timeout: timeoutInSeconds)

        assertClosure()
    }

    func testOnEditingValidatesPan() {
        let pan = "123"
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: nil)

        presenter.onEditing(text: pan)

        verify(panValidationFlowMock).validate(pan: pan)
    }

    func testOnEditEndNotifiesMerchantOfValidationStateIfNotAlreadyNotified() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: nil)

        presenter.onEditEnd()

        verify(panValidationFlowMock).notifyMerchantIfNotAlreadyNotified()
    }

    func testCanChangeTextChecksIfTheTextCanBeEnteredButDoesNotTriggerValidationFlow() {
        let panFormattingEnabled = true
        let configurationProvider = MockCardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock())
        let panValidatorMock = MockPanValidator(configurationProvider)
        panValidatorMock.getStubbingProxy().canValidate(any()).thenReturn(true)
        let presenter = PanViewPresenter(panValidationFlowMock, panValidatorMock, panFormattingEnabled: panFormattingEnabled)

        _ = presenter.canChangeText(with: "123")

        verify(panValidatorMock).canValidate("123")
        verifyNoMoreInteractions(panValidationFlowMock)
    }

    func testCanChangeTextWithEmptyText() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: nil)

        let result = presenter.canChangeText(with: "")

        XCTAssertTrue(result)
    }

    func testOnEndEditingNotifiesMerchant() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: nil)
        panTextField.text = "123"

        presenter.textFieldDidEndEditing(panTextField)

        verify(panValidationFlowMock).notifyMerchantIfNotAlreadyNotified()
    }

    // MARK: testing what the end user can and cannot type

    func testCanClearText() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: nil)
        let range = NSRange(location: 0, length: 3)
        panTextField.text = "123"

        _ = presenter.textField(panTextField, shouldChangeCharactersIn: range, replacementString: "")

        XCTAssertEqual(panTextField.text, "")
        verify(panValidationFlowMock).notifyMerchantIfNotAlreadyNotified()
        verify(panValidationFlowMock).validate(pan: "")
    }

    func testCannotTypeOnlyNonNumericalCharacters() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: nil)
        XCTAssertEqual(panTextField.text, "")

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, "abc")
        XCTAssertEqual(panTextField.text, "")
        verifyNoMoreInteractions(panValidationFlowMock)

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, "-*+")
        XCTAssertEqual(panTextField.text, "")
        verifyNoMoreInteractions(panValidationFlowMock)
    }

    func testCanPasteAlphanumericCharactersButExtractsDigitsOnly() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: nil)
        XCTAssertEqual(panTextField.text, "")

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, "abc4444def3333gh")
        XCTAssertEqual(panTextField.text, "4444 3333")
        verify(panValidationFlowMock).validate(pan: "4444 3333")
    }

    func testCanTypeValidVisaPan() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: visaBrand)

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, validVisaPan)
        XCTAssertEqual(panTextField.text, validVisaPanWithSpaces)
        verify(panValidationFlowMock).notifyMerchantIfNotAlreadyNotified()
        verify(panValidationFlowMock).validate(pan: validVisaPanWithSpaces)
    }

    func testCanTypeValidVisaPanWithSpaces() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: visaBrand)

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, validVisaPanWithSpaces)
        XCTAssertEqual(panTextField.text, validVisaPanWithSpaces)
        verify(panValidationFlowMock).notifyMerchantIfNotAlreadyNotified()
        verify(panValidationFlowMock).validate(pan: validVisaPanWithSpaces)
    }

    func testCanTypeVisaPanWithSpacesThatFailsLuhnCheck() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: visaBrand)

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, visaPanThatFailsLuhnCheckWithSpaces)
        XCTAssertEqual(panTextField.text, visaPanThatFailsLuhnCheckWithSpaces)
        verify(panValidationFlowMock).notifyMerchantIfNotAlreadyNotified()
        verify(panValidationFlowMock).validate(pan: visaPanThatFailsLuhnCheckWithSpaces)
    }

    func testCanTypeVisaPanAsLongAsMaxLengthAllowed() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: visaBrand)

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, validVisaPanAsLongAsMaxLengthAllowed)
        XCTAssertEqual(panTextField.text, validVisaPanAsLongAsMaxLengthAllowedWithSpaces)
        verify(panValidationFlowMock).notifyMerchantIfNotAlreadyNotified()
        verify(panValidationFlowMock).validate(pan: validVisaPanAsLongAsMaxLengthAllowedWithSpaces)
    }

    func testCanTypeVisaPanWithSpacesAsLongAsMaxLengthAllowed() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: visaBrand)

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, validVisaPanAsLongAsMaxLengthAllowedWithSpaces)
        XCTAssertEqual(panTextField.text, validVisaPanAsLongAsMaxLengthAllowedWithSpaces)
        verify(panValidationFlowMock).notifyMerchantIfNotAlreadyNotified()
        verify(panValidationFlowMock).validate(pan: validVisaPanAsLongAsMaxLengthAllowedWithSpaces)
    }

    func testCannotTypeVisaPanWithSpacesThatExceedsMaximiumLength() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: visaBrand)

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, visaPanTooLongWithSpaces)
        XCTAssertEqual(panTextField.text, "")
        verify(panValidationFlowMock).getCardBrand()
        verifyNoMoreInteractions(panValidationFlowMock)
    }

    //  This test is important because the Visa pattern excludes explictly the Maestro pattern so we want
    // to make sure that it does not prevent the user from typing a maestro PAN
    func testCanTypeStartOfMaestroPan() {
        let cardBrandsConfiguration = CardBrandsConfiguration(allCardBrands: [visaBrand, maestroBrand], acceptedCardBrands: [])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        panValidationFlowMock.getStubbingProxy().getCardBrand().thenReturn(maestroBrand)

        let panValidator = PanValidator(configurationProvider)
        let presenter = PanViewPresenter(panValidationFlowMock, panValidator, panFormattingEnabled: true)

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, "493698123")

        XCTAssertEqual(panTextField.text, "4936 9812 3")
        verify(panValidationFlowMock).notifyMerchantIfNotAlreadyNotified()
        verify(panValidationFlowMock).validate(pan: "4936 9812 3")
    }

    func testCanTypePanOfUnknownBrandAsLongAsMaxLengthAllowed() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, "1234567890123456789")
        XCTAssertEqual(panTextField.text, "1234 5678 9012 3456 789")
        verify(panValidationFlowMock).notifyMerchantIfNotAlreadyNotified()
        verify(panValidationFlowMock).validate(pan: "1234 5678 9012 3456 789")
    }

    func testCannotTypePanOfUnknownBrandThatExceedsMaximiumLength() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, "1234 5678 9012 3456 7890")
        XCTAssertEqual(panTextField.text, "")
        verify(panValidationFlowMock).getCardBrand()
        verifyNoMoreInteractions(panValidationFlowMock)
    }

    func testShouldDeleteSpaceAndPreviousDigitWhenDeletingSpace() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "4444 3333"
        let textToInsert = ""
        let selection = NSRange(location: 4, length: 1)

        _ = presenter.textField(panTextField, shouldChangeCharactersIn: selection, replacementString: textToInsert)

        XCTAssertEqual("4443 333", panTextField.text)
        waitThen {
            XCTAssertEqual(3, self.caretPosition())
        }
    }

    // MARK: Caret position tests

    func testShouldMoveCaretToEndWhenEnteringTextInEmptyField() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)
        let textToInsert = "44443333"
        let carePosition = NSRange(location: 0, length: 0)

        _ = presenter.textField(panTextField, shouldChangeCharactersIn: carePosition, replacementString: textToInsert)

        XCTAssertEqual("4444 3333", panTextField.text)
        waitThen {
            XCTAssertEqual(9, self.caretPosition())
        }
    }

    func testShouldMoveCaretWhenSingleDigitIsInserted() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "4444 3333"
        let textToInsert = "1"
        let carePosition = NSRange(location: 6, length: 0)

        _ = presenter.textField(panTextField, shouldChangeCharactersIn: carePosition, replacementString: textToInsert)

        XCTAssertEqual("4444 3133 3", panTextField.text)
        waitThen {
            XCTAssertEqual(7, self.caretPosition())
        }
    }

    func testShouldMoveCaretAfterMultipleDigitsInsertedAtStart() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "4443"
        let textToInsert = "11"
        let carePosition = NSRange(location: 0, length: 0)

        _ = presenter.textField(panTextField, shouldChangeCharactersIn: carePosition, replacementString: textToInsert)

        XCTAssertEqual("1144 43", panTextField.text)
        waitThen {
            XCTAssertEqual(2, self.caretPosition())
        }
    }

    func testShouldMoveCaretAfterMultipleDigitsInsertedAtStartOverSelectionShorterThanNumberOfDigitsInserted() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "4443"
        let textToInsert = "11"
        let selection = NSRange(location: 0, length: 1)

        _ = presenter.textField(panTextField, shouldChangeCharactersIn: selection, replacementString: textToInsert)

        XCTAssertEqual("1144 3", panTextField.text)
        waitThen {
            XCTAssertEqual(2, self.caretPosition())
        }
    }

    func testShouldMoveCaretAfterMultipleDigitsInsertedAtStartOverSelectionLongerThanNumberOfDigitsInserted() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "4444 3333"
        let textToInsert = "11"
        let selection = NSRange(location: 0, length: 3)

        _ = presenter.textField(panTextField, shouldChangeCharactersIn: selection, replacementString: textToInsert)

        XCTAssertEqual("1143 333", panTextField.text)
        waitThen {
            XCTAssertEqual(2, self.caretPosition())
        }
    }

    func testShouldMoveCaretAfterMultipleDigitsPastedOverSelectionLongerThanTextPasted() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "4444 3333 2222"
        let textToInsert = "11"
        let selection = NSRange(location: 5, length: 4)

        _ = presenter.textField(panTextField, shouldChangeCharactersIn: selection, replacementString: textToInsert)

        XCTAssertEqual("4444 1122 22", panTextField.text)
        waitThen {
            XCTAssertEqual(7, self.caretPosition())
        }
    }

    func testShouldNotMoveCaretWhenSelectedTextIsDeletedUsingBackspace() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "4444 3333"
        let textToInsert = ""
        let selection = NSRange(location: 1, length: 2)

        _ = presenter.textField(panTextField, shouldChangeCharactersIn: selection, replacementString: textToInsert)

        XCTAssertEqual("4433 33", panTextField.text)
        waitThen {
            XCTAssertEqual(1, self.caretPosition())
        }
    }

    func testShouldMoveCaretAfterDigitsPastedWhenTextPastedIsAMixtureOfDigitsAndSomethingElse() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "4444 3333"
        let textToInsert = "2  2abc"
        let carePosition = NSRange(location: 6, length: 0)

        _ = presenter.textField(panTextField, shouldChangeCharactersIn: carePosition, replacementString: textToInsert)

        XCTAssertEqual("4444 3223 33", panTextField.text)
        waitThen {
            XCTAssertEqual(8, self.caretPosition())
        }
    }

    func testShouldNotMoveCaretWhenTextPastedHasNoDigits() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "4444 3333"
        let textToInsert = "abc"
        let carePosition = NSRange(location: 6, length: 0)

        _ = presenter.textField(panTextField, shouldChangeCharactersIn: carePosition, replacementString: textToInsert)

        XCTAssertEqual("4444 3333", panTextField.text)
        waitThen {
            XCTAssertEqual(6, self.caretPosition())
        }
    }

    func testShouldNotMoveCaretAfterSpaceWhenDigitInsertedAsTheLastDigitOfAGroupThatHasASpaceAfterIt() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "4444 3333"
        let textToInsert = "2"
        let carePosition = NSRange(location: 3, length: 0)

        _ = presenter.textField(panTextField, shouldChangeCharactersIn: carePosition, replacementString: textToInsert)

        XCTAssertEqual("4442 4333 3", panTextField.text)
        waitThen {
            XCTAssertEqual(4, self.caretPosition())
        }
    }

    // MARK: test for textFieldEditingChanged

    // Reformatting the pan is required in the case when deleting text using the delete key instead of the backspace key to

    func testTextFieldEditingChangedShouldReformatPanAndNotMoveCaretWhenPanIsIncorrectlyFormatted() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "4444333 22"
        let caretPosition = 5

        let newPosition = panTextField.position(from: panTextField.beginningOfDocument, offset: caretPosition)!
        panTextField.selectedTextRange = panTextField.textRange(from: newPosition, to: newPosition)
        XCTAssertEqual(caretPosition, self.caretPosition())

        presenter.textFieldEditingChanged(panTextField)

        XCTAssertEqual("4444 3332 2", panTextField.text)
        waitThen {
            XCTAssertEqual(caretPosition + 1, self.caretPosition())
        }
    }

    func testTextFieldEditingChangedShouldPassReformatedPanToValidationFlow() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "4444333"

        presenter.textFieldEditingChanged(panTextField)

        verify(panValidationFlowMock).validate(pan: "4444 333")
    }
}
