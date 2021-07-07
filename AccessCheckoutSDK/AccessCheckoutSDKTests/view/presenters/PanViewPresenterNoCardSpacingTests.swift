@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class PanViewPresenterNoCardSpacingTests: PresenterTestSuite {
    private let panValidatorMock = mockPanValidator()
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

    override func setUp() {
        panValidationFlowMock.getStubbingProxy().validate(pan: any()).thenDoNothing()
        panValidationFlowMock.getStubbingProxy().notifyMerchantIfNotAlreadyNotified().thenDoNothing()
        panValidatorMock.getStubbingProxy().canValidate(any()).thenReturn(true)
    }

    private static func mockPanValidationFlow() -> MockPanValidationFlow {
        let validationStateHandler = CardValidationStateHandler(MockAccessCheckoutCardValidationDelegate())
        let cvcValidationFlow = MockCvcValidationFlow(CvcValidator(), validationStateHandler)
        let configurationProvider = MockCardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock())
        let panValidator = PanValidator(configurationProvider)

        return MockPanValidationFlow(panValidator, validationStateHandler, cvcValidationFlow)
    }

    static func mockPanValidator() -> MockPanValidator {
        let configurationProvider = MockCardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock())
        let panValidator = MockPanValidator(configurationProvider)

        return panValidator
    }

    private func createPresenterWithoutCardSpacing(detectedCardBrand: CardBrandModel?) -> PanViewPresenter {
        let panFormattingEnabled = false
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
        let presenter = createPresenterWithoutCardSpacing(detectedCardBrand: nil)

        presenter.onEditing(text: pan)

        verify(panValidationFlowMock).validate(pan: pan)
    }

    func testOnEditEndNotifiesMerchantOfValidationStateIfNotAlreadyNotified() {
        let presenter = createPresenterWithoutCardSpacing(detectedCardBrand: nil)

        presenter.onEditEnd()

        verify(panValidationFlowMock).notifyMerchantIfNotAlreadyNotified()
    }

    func testCanChangeTextChecksIfTheTextCanBeEnteredAndDoesNotTriggerValidationFlow() {
        let panFormattingEnabled = false
        let configurationProvider = MockCardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock())
        let panValidatorMock = MockPanValidator(configurationProvider)
        panValidatorMock.getStubbingProxy().canValidate(any()).thenReturn(true)
        let presenter = PanViewPresenter(panValidationFlowMock, panValidatorMock, panFormattingEnabled: panFormattingEnabled)

        _ = presenter.canChangeText(with: "123")

        verify(panValidatorMock).canValidate("123")
        verifyNoMoreInteractions(panValidationFlowMock)
    }

    func testCanChangeTextWithEmptyText() {
        let presenter = createPresenterWithoutCardSpacing(detectedCardBrand: nil)

        let result = presenter.canChangeText(with: "")

        XCTAssertTrue(result)
    }

    func testOnEndEditingNotifiesMerchant() {
        let presenter = createPresenterWithoutCardSpacing(detectedCardBrand: nil)
        panTextField.text = "123"

        presenter.textFieldDidEndEditing(panTextField)

        verify(panValidationFlowMock).notifyMerchantIfNotAlreadyNotified()
    }

    // MARK: testing what the end user can and cannot type

    func testCanClearText() {
        let presenter = createPresenterWithoutCardSpacing(detectedCardBrand: nil)
        let range = NSRange(location: 0, length: 3)
        panTextField.text = "123"

        _ = presenter.textField(panTextField, shouldChangeCharactersIn: range, replacementString: "")

        XCTAssertEqual(panTextField.text, "")
        verify(panValidationFlowMock).notifyMerchantIfNotAlreadyNotified()
        verify(panValidationFlowMock).validate(pan: "")
    }

    func testCanTypeDigitsWhenTextfieldTextIsSetToNil() {
        let presenter = createPresenterWithoutCardSpacing(detectedCardBrand: nil)
        let range = NSRange(location: 0, length: 0)
        panTextField.text = nil

        _ = presenter.textField(panTextField, shouldChangeCharactersIn: range, replacementString: "123")

        XCTAssertEqual(panTextField.text, "123")
    }

    func testCannotTypeOnlyNonNumericalCharacters() {
        let presenter = createPresenterWithoutCardSpacing(detectedCardBrand: nil)
        XCTAssertEqual(panTextField.text, "")

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, "abc")
        XCTAssertEqual(panTextField.text, "")
        verifyNoMoreInteractions(panValidationFlowMock)

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, "-*+")
        XCTAssertEqual(panTextField.text, "")
        verifyNoMoreInteractions(panValidationFlowMock)
    }

    func testCanPasteAlphanumericCharactersButExtractsDigitsOnly() {
        let presenter = createPresenterWithoutCardSpacing(detectedCardBrand: nil)
        XCTAssertEqual(panTextField.text, "")

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, "abc4444def3333gh")
        XCTAssertEqual(panTextField.text, "44443333")
        verify(panValidationFlowMock).validate(pan: "44443333")
    }

    func testCanTypeValidVisaPan() {
        let presenter = createPresenterWithoutCardSpacing(detectedCardBrand: visaBrand)

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, validVisaPan)
        XCTAssertEqual(panTextField.text, validVisaPan)
        verify(panValidationFlowMock).notifyMerchantIfNotAlreadyNotified()
        verify(panValidationFlowMock).validate(pan: validVisaPan)
    }

    func testCanTypeVisaPanThatFailsLuhnCheck() {
        let presenter = createPresenterWithoutCardSpacing(detectedCardBrand: visaBrand)

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, visaPanThatFailsLuhnCheck)
        XCTAssertEqual(panTextField.text, visaPanThatFailsLuhnCheck)
        verify(panValidationFlowMock).notifyMerchantIfNotAlreadyNotified()
        verify(panValidationFlowMock).validate(pan: visaPanThatFailsLuhnCheck)
    }

    func testCanTypeVisaPanAsLongAsMaxLengthAllowed() {
        let presenter = createPresenterWithoutCardSpacing(detectedCardBrand: visaBrand)

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, validVisaPanAsLongAsMaxLengthAllowed)
        XCTAssertEqual(panTextField.text, validVisaPanAsLongAsMaxLengthAllowed)
        verify(panValidationFlowMock).notifyMerchantIfNotAlreadyNotified()
        verify(panValidationFlowMock).validate(pan: validVisaPanAsLongAsMaxLengthAllowed)
    }

    func testCannotTypeVisaPanThatExceedsMaximiumLength() {
        let presenter = createPresenterWithoutCardSpacing(detectedCardBrand: visaBrand)

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, visaPanTooLong)
        XCTAssertEqual(panTextField.text, "")
        verifyNoMoreInteractions(panValidationFlowMock)
    }

    // This test is important because the Visa pattern excludes explictly the Maestro pattern so we want
    // to make sure that it does not prevent the user from typing a maestro PAN
    func testCanTypeStartOfMaestroPan() {
        let cardBrandsConfiguration = CardBrandsConfiguration(allCardBrands: [visaBrand, maestroBrand], acceptedCardBrands: [])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        panValidationFlowMock.getStubbingProxy().getCardBrand().thenReturn(maestroBrand)

        let panValidator = PanValidator(configurationProvider)
        let presenter = PanViewPresenter(panValidationFlowMock, panValidator, panFormattingEnabled: false)

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, "493698123")

        XCTAssertEqual(panTextField.text, "493698123")
        verify(panValidationFlowMock).notifyMerchantIfNotAlreadyNotified()
        verify(panValidationFlowMock).validate(pan: "493698123")
    }

    func testCanTypePanOfUnknownBrandAsLongAsMaxLengthAllowed() {
        let presenter = createPresenterWithoutCardSpacing(detectedCardBrand: nil)

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, "1234567890123456789")
        XCTAssertEqual(panTextField.text, "1234567890123456789")
        verify(panValidationFlowMock).notifyMerchantIfNotAlreadyNotified()
        verify(panValidationFlowMock).validate(pan: "1234567890123456789")
    }

    func testCannotTypePanOfUnknownBrandThatExceedsMaximiumLength() {
        let presenter = createPresenterWithoutCardSpacing(detectedCardBrand: nil)

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, "12345678901234567890")
        XCTAssertEqual(panTextField.text, "")
        verifyNoMoreInteractions(panValidationFlowMock)
    }

    // MARK: Caret position tests

    func testShouldMoveCaretToEndWhenEnteringTextInEmptyField() {
        let presenter = createPresenterWithoutCardSpacing(detectedCardBrand: unknownBrand)
        let textToInsert = "44443333"
        let caretPosition = NSRange(location: 0, length: 0)
        _ = presenter.textField(panTextField, shouldChangeCharactersIn: caretPosition, replacementString: textToInsert)

        XCTAssertEqual("44443333", panTextField.text)
        waitThen {
            XCTAssertEqual(8, self.caretPosition())
        }
    }

    func testShouldMoveCaretWhenSingleDigitIsInserted() {
        let presenter = createPresenterWithoutCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "44443333"
        let textToInsert = "1"
        let caretPosition = NSRange(location: 6, length: 0)
        _ = presenter.textField(panTextField, shouldChangeCharactersIn: caretPosition, replacementString: textToInsert)

        XCTAssertEqual("444433133", panTextField.text)
        waitThen {
            XCTAssertEqual(7, self.caretPosition())
        }
    }

    func testShouldMoveCaretAfterMultipleDigitsInsertedAtStart() {
        let presenter = createPresenterWithoutCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "4443"
        let textToInsert = "11"
        let caretPosition = NSRange(location: 0, length: 0)

        _ = presenter.textField(panTextField, shouldChangeCharactersIn: caretPosition, replacementString: textToInsert)

        XCTAssertEqual("114443", panTextField.text)
        waitThen {
            XCTAssertEqual(2, self.caretPosition())
        }
    }

    func testShouldMoveCaretAfterMultipleDigitsInsertedAtStartOverSelectionShorterThanNumberOfDigitsInserted() {
        let presenter = createPresenterWithoutCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "4443"
        let textToInsert = "11"
        let selection = NSRange(location: 0, length: 1)

        _ = presenter.textField(panTextField, shouldChangeCharactersIn: selection, replacementString: textToInsert)

        XCTAssertEqual("11443", panTextField.text)
        waitThen {
            XCTAssertEqual(2, self.caretPosition())
        }
    }

    func testShouldMoveCaretAfterMultipleDigitsInsertedAtStartOverSelectionLongerThanNumberOfDigitsInserted() {
        let presenter = createPresenterWithoutCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "44443333"
        let textToInsert = "11"
        let selection = NSRange(location: 0, length: 3)

        _ = presenter.textField(panTextField, shouldChangeCharactersIn: selection, replacementString: textToInsert)

        XCTAssertEqual("1143333", panTextField.text)
        waitThen {
            XCTAssertEqual(2, self.caretPosition())
        }
    }

    func testShouldMoveCaretAfterMultipleDigitsPastedOverSelectionLongerThanTextPasted() {
        let presenter = createPresenterWithoutCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "444433332222"
        let textToInsert = "11"
        let selection = NSRange(location: 5, length: 4)

        _ = presenter.textField(panTextField, shouldChangeCharactersIn: selection, replacementString: textToInsert)

        XCTAssertEqual("4444311222", panTextField.text)
        waitThen {
            XCTAssertEqual(7, self.caretPosition())
        }
    }

    func testShouldNotMoveCaretWhenSelectedTextIsDeletedUsingBackspace() {
        let presenter = createPresenterWithoutCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "4444 3333"
        let textToInsert = ""
        let selection = NSRange(location: 1, length: 2)

        _ = presenter.textField(panTextField, shouldChangeCharactersIn: selection, replacementString: textToInsert)

        XCTAssertEqual("443333", panTextField.text)
        waitThen {
            XCTAssertEqual(1, self.caretPosition())
        }
    }

    func testShouldMoveCaretAfterDigitsPastedWhenTextPastedIsAMixtureOfDigitsAndSomethingElse() {
        let presenter = createPresenterWithoutCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "44443333"
        let textToInsert = "2  2abc"
        let caretPosition = NSRange(location: 6, length: 0)

        _ = presenter.textField(panTextField, shouldChangeCharactersIn: caretPosition, replacementString: textToInsert)

        XCTAssertEqual("4444332233", panTextField.text)
        waitThen {
            XCTAssertEqual(8, self.caretPosition())
        }
    }

    func testShouldNotMoveCaretWhenTextPastedHasNoDigits() {
        let presenter = createPresenterWithoutCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "44443333"
        let textToInsert = "abc"
        let caretPosition = NSRange(location: 5, length: 0)

        _ = presenter.textField(panTextField, shouldChangeCharactersIn: caretPosition, replacementString: textToInsert)

        XCTAssertEqual("44443333", panTextField.text)
        waitThen {
            XCTAssertEqual(5, self.caretPosition())
        }
    }

    func testShouldNotMoveCaretWhenPastingWouldCausePanToExceedMaxLength() {
        let presenter = createPresenterWithoutCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "4444333322221111"
        let textToInsert = "9999"
        let selection = NSRange(location: 1, length: 0)

        _ = presenter.textField(panTextField, shouldChangeCharactersIn: selection, replacementString: textToInsert)

        XCTAssertEqual("4444333322221111", panTextField.text)
        waitThen {
            XCTAssertEqual(1, self.caretPosition())
        }
    }

    // MARK: test for textFieldEditingChanged

    func testTextFieldEditingChangedShouldValidatePan() {
        let presenter = createPresenterWithoutCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "4444333"

        presenter.textFieldEditingChanged(panTextField)

        verify(panValidationFlowMock).validate(pan: "4444333")
    }
}
