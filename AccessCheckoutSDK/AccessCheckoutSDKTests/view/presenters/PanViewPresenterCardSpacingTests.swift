import Cuckoo
import XCTest

@testable import AccessCheckoutSDK

class PanViewPresenterCardSpacingTests: PresenterTestSuite {
    private let panValidationFlowMock = mockPanValidationFlow()

    private let amexBrand = TestFixtures.amexBrand()
    private let visaBrand = TestFixtures.visaBrand()
    private let maestroBrand = TestFixtures.maestroBrand()
    private let unknownBrand = TestFixtures.unknownBrand()
    private let configurationProvider = MockCardBrandsConfigurationProvider(
        CardBrandsConfigurationFactoryMock()
    )

    private let validVisaPan = TestFixtures.validVisaPan1
    private let validVisaPanWithSpaces = TestFixtures.validVisaPan1WithSpaces

    private let validVisaPanAsLongAsMaxLengthAllowed = TestFixtures
        .validVisaPanAsLongAsMaxLengthAllowed
    private let validVisaPanAsLongAsMaxLengthAllowedWithSpaces = TestFixtures
        .validVisaPanAsLongAsMaxLengthAllowedWithSpaces

    private let visaPanThatFailsLuhnCheck = TestFixtures.visaPanThatFailsLuhnCheck
    private let visaPanThatFailsLuhnCheckWithSpaces = TestFixtures
        .visaPanThatFailsLuhnCheckWithSpaces

    private let visaPanTooLong = TestFixtures.visaPanTooLong
    private let visaPanTooLongWithSpaces = TestFixtures.visaPanTooLongWithSpaces

    override func setUp() {
        panValidationFlowMock.getStubbingProxy().validate(pan: any()).thenDoNothing()
        panValidationFlowMock.getStubbingProxy().notifyMerchant().thenDoNothing()
    }

    private static func mockPanValidationFlow() -> MockPanValidationFlow {
        let validationStateHandler = CardValidationStateHandler(
            MockAccessCheckoutCardValidationDelegate()
        )
        let cvcValidationFlow = MockCvcValidationFlow(CvcValidator(), validationStateHandler)
        let configurationProvider = MockCardBrandsConfigurationProvider(
            CardBrandsConfigurationFactoryMock()
        )
        let panValidator = PanValidator(configurationProvider)

        return MockPanValidationFlow(panValidator, validationStateHandler, cvcValidationFlow)
    }

    private func createPresenterWithCardSpacing(detectedCardBrand: CardBrandModel?)
        -> PanViewPresenter
    {
        let panFormattingEnabled = true
        let cardBrandsConfiguration = CardBrandsConfiguration(
            allCardBrands: [visaBrand, maestroBrand],
            acceptedCardBrands: []
        )
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        panValidationFlowMock.getStubbingProxy().getCardBrand().thenReturn(detectedCardBrand)

        let panValidator = PanValidator(configurationProvider)
        return PanViewPresenter(
            panValidationFlowMock,
            panValidator,
            panFormattingEnabled: panFormattingEnabled
        )
    }

    private func createPresenterWithCardSpacingAndFullOnValidation(allCardBrands: [CardBrandModel])
        -> PanViewPresenter
    {
        let acceptedCardBrands: [String] = []

        let merchantValidationDelegate = MockAccessCheckoutCardValidationDelegate()
        merchantValidationDelegate.getStubbingProxy().panValidChanged(isValid: any())
            .thenDoNothing()
        merchantValidationDelegate.getStubbingProxy().cardBrandChanged(cardBrand: any())
            .thenDoNothing()

        let configuration = CardBrandsConfiguration(
            allCardBrands: allCardBrands,
            acceptedCardBrands: acceptedCardBrands
        )
        let configurationFactory = CardBrandsConfigurationFactoryMock()
        configurationFactory.willReturn(configuration)

        let configurationProvider = CardBrandsConfigurationProvider(configurationFactory)
        configurationProvider.retrieveRemoteConfiguration(
            baseUrl: "",
            acceptedCardBrands: acceptedCardBrands
        )

        let panValidator = PanValidator(configurationProvider)
        let validationStateHandler = CardValidationStateHandler(merchantValidationDelegate)
        let cvcValidationFlow = CvcValidationFlow(CvcValidator(), validationStateHandler)
        let panValidationFlow = PanValidationFlow(
            panValidator,
            validationStateHandler,
            cvcValidationFlow
        )

        return PanViewPresenter(panValidationFlow, panValidator, panFormattingEnabled: true)
    }

    private func caretPosition() -> Int {
        return panTextField.offset(
            from: panTextField.beginningOfDocument,
            to: panTextField.selectedTextRange!.start
        )
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

        verify(panValidationFlowMock).notifyMerchant()
    }

    func testCanChangeTextChecksIfTheTextCanBeEnteredButDoesNotTriggerValidationFlow() {
        let panFormattingEnabled = true
        let configurationProvider = MockCardBrandsConfigurationProvider(
            CardBrandsConfigurationFactoryMock()
        )
        let panValidatorMock = MockPanValidator(configurationProvider)
        panValidatorMock.getStubbingProxy().canValidate(any()).thenReturn(true)
        let presenter = PanViewPresenter(
            panValidationFlowMock,
            panValidatorMock,
            panFormattingEnabled: panFormattingEnabled
        )

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

        verify(panValidationFlowMock).notifyMerchant()
    }

    // MARK: testing what the end user can and cannot type

    func testCanClearText() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: nil)
        let range = NSRange(location: 0, length: 3)
        panTextField.text = "123"

        _ = presenter.textField(
            panTextField,
            shouldChangeCharactersIn: range,
            replacementString: ""
        )

        XCTAssertEqual(panTextField.text, "")
        verify(panValidationFlowMock).validate(pan: "")
    }

    func testCanTypeDigitsWhenTextfieldTextIsSetToNil() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: nil)
        let range = NSRange(location: 0, length: 0)
        panTextField.text = nil

        _ = presenter.textField(
            panTextField,
            shouldChangeCharactersIn: range,
            replacementString: "123"
        )

        XCTAssertEqual(panTextField.text, "123")
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
        verify(panValidationFlowMock).validate(pan: validVisaPanWithSpaces)
    }

    func testCanTypeValidVisaPanWithSpaces() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: visaBrand)

        enterPanInUITextField(
            presenter: presenter,
            uiTextField: panTextField,
            validVisaPanWithSpaces
        )
        XCTAssertEqual(panTextField.text, validVisaPanWithSpaces)
        verify(panValidationFlowMock).validate(pan: validVisaPanWithSpaces)
    }

    func testCanTypeVisaPanWithSpacesThatFailsLuhnCheck() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: visaBrand)

        enterPanInUITextField(
            presenter: presenter,
            uiTextField: panTextField,
            visaPanThatFailsLuhnCheckWithSpaces
        )
        XCTAssertEqual(panTextField.text, visaPanThatFailsLuhnCheckWithSpaces)
        verify(panValidationFlowMock).validate(pan: visaPanThatFailsLuhnCheckWithSpaces)
    }

    func testCanTypeVisaPanAsLongAsMaxLengthAllowed() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: visaBrand)

        enterPanInUITextField(
            presenter: presenter,
            uiTextField: panTextField,
            validVisaPanAsLongAsMaxLengthAllowed
        )
        XCTAssertEqual(panTextField.text, validVisaPanAsLongAsMaxLengthAllowedWithSpaces)
        verify(panValidationFlowMock).validate(pan: validVisaPanAsLongAsMaxLengthAllowedWithSpaces)
    }

    func testCanTypeVisaPanWithSpacesAsLongAsMaxLengthAllowed() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: visaBrand)

        enterPanInUITextField(
            presenter: presenter,
            uiTextField: panTextField,
            validVisaPanAsLongAsMaxLengthAllowedWithSpaces
        )
        XCTAssertEqual(panTextField.text, validVisaPanAsLongAsMaxLengthAllowedWithSpaces)
        verify(panValidationFlowMock).validate(pan: validVisaPanAsLongAsMaxLengthAllowedWithSpaces)
    }

    func testCutsToMaxLengthAVisaPanWithSpacesThatExceedsMaximiumLength() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: visaBrand)

        enterPanInUITextField(
            presenter: presenter,
            uiTextField: panTextField,
            visaPanTooLongWithSpaces
        )

        XCTAssertEqual(panTextField.text, "4111 1111 1111 1111 111")
    }

    //  This test is important because the Visa pattern excludes explictly the Maestro pattern so we want
    // to make sure that it does not prevent the user from typing a maestro PAN
    func testCanTypeStartOfMaestroPan() {
        let cardBrandsConfiguration = CardBrandsConfiguration(
            allCardBrands: [visaBrand, maestroBrand],
            acceptedCardBrands: []
        )
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        panValidationFlowMock.getStubbingProxy().getCardBrand().thenReturn(maestroBrand)

        let panValidator = PanValidator(configurationProvider)
        let presenter = PanViewPresenter(
            panValidationFlowMock,
            panValidator,
            panFormattingEnabled: true
        )

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, "493698123")

        XCTAssertEqual(panTextField.text, "4936 9812 3")
        verify(panValidationFlowMock).validate(pan: "4936 9812 3")
    }

    func testCanTypePanOfUnknownBrandAsLongAsMaxLengthAllowed() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)

        enterPanInUITextField(
            presenter: presenter,
            uiTextField: panTextField,
            "1234567890123456789"
        )
        XCTAssertEqual(panTextField.text, "1234 5678 9012 3456 789")
        verify(panValidationFlowMock).validate(pan: "1234 5678 9012 3456 789")
    }

    func testCutsToMaxLengthAPanOfUnknownBrandThatExceedsMaxLength() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)

        enterPanInUITextField(
            presenter: presenter,
            uiTextField: panTextField,
            "1234 5678 9012 3456 7890"
        )

        XCTAssertEqual(panTextField.text, "1234 5678 9012 3456 789")
    }

    func testShouldFormatCorrectlyAmexCardEnteredInABlankUITextfield() {
        let presenter = createPresenterWithCardSpacingAndFullOnValidation(allCardBrands: [
            visaBrand, amexBrand,
        ])

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, "345678901234567")

        XCTAssertEqual(panTextField.text, "3456 789012 34567")
    }

    func testShouldFormatCorrectlyCardWithDifferentFormatEnteredAfterAmexCard() {
        let presenter = createPresenterWithCardSpacingAndFullOnValidation(allCardBrands: [
            visaBrand, amexBrand,
        ])
        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, "3456 789012 34567")
        XCTAssertEqual(panTextField.text, "3456 789012 34567")

        let allTextSelected = NSRange(location: 0, length: panTextField.text!.count)
        _ = presenter.textField(
            panTextField,
            shouldChangeCharactersIn: allTextSelected,
            replacementString: "4444123456789012"
        )

        XCTAssertEqual(panTextField.text, "4444 1234 5678 9012")
    }

    func testShouldFormatCorrectlyAmexEnteredAfterCardWithDifferentFormat() {
        let presenter = createPresenterWithCardSpacingAndFullOnValidation(allCardBrands: [
            visaBrand, amexBrand,
        ])
        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, "4444123456789012")
        XCTAssertEqual(panTextField.text, "4444 1234 5678 9012")

        let allTextSelected = NSRange(location: 0, length: panTextField.text!.count)
        _ = presenter.textField(
            panTextField,
            shouldChangeCharactersIn: allTextSelected,
            replacementString: "345678901234567"
        )

        XCTAssertEqual(panTextField.text, "3456 789012 34567")
    }

    func testShouldFormatCorrectlyCardWhenItBecomesAmex() {
        let presenter = createPresenterWithCardSpacingAndFullOnValidation(allCardBrands: [
            visaBrand, amexBrand,
        ])
        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, "45678912345")
        XCTAssertEqual(panTextField.text, "4567 8912 345")

        let noTextSelected = NSRange(location: 0, length: 0)
        _ = presenter.textField(
            panTextField,
            shouldChangeCharactersIn: noTextSelected,
            replacementString: "3"
        )

        XCTAssertEqual(panTextField.text, "3456 789123 45")
    }

    func testShouldFormatCorrectlyCardWhenItBecomesCardWithStandardFormat() {
        let presenter = createPresenterWithCardSpacingAndFullOnValidation(allCardBrands: [
            visaBrand, amexBrand,
        ])
        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, "345678912345")
        XCTAssertEqual(panTextField.text, "3456 789123 45")

        let noTextSelected = NSRange(location: 0, length: 0)
        _ = presenter.textField(
            panTextField,
            shouldChangeCharactersIn: noTextSelected,
            replacementString: "4"
        )

        XCTAssertEqual(panTextField.text, "4345 6789 1234 5")
    }

    func testShouldCutToFirstXDigitsPanWhichIsLongerThanTheMaxLength() {
        let presenter = createPresenterWithCardSpacingAndFullOnValidation(allCardBrands: [
            visaBrand, amexBrand,
        ])

        enterPanInUITextField(
            presenter: presenter,
            uiTextField: panTextField,
            "44443333222211110000999988887777"
        )

        XCTAssertEqual(panTextField.text, "4444 3333 2222 1111 000")
    }

    func
        testShouldCutToFirstXDigitsPanWhichIsLongerThanTheMaxLengthWithBrandDifferentFromCurrentBrand()
    {
        let presenter = createPresenterWithCardSpacingAndFullOnValidation(allCardBrands: [
            visaBrand, amexBrand,
        ])
        panTextField.text = "3455 55666 677"

        var noTextSelected = NSRange(location: 2, length: 0)
        _ = presenter.textField(
            panTextField,
            shouldChangeCharactersIn: noTextSelected,
            replacementString: "8888"
        )
        // Cuts pan to 15 digits due to Amex max length
        XCTAssertEqual("3488 885555 66667", panTextField.text)

        // Cuts pan to 19 digits due to visa max length
        noTextSelected = NSRange(location: 0, length: 0)
        _ = presenter.textField(
            panTextField,
            shouldChangeCharactersIn: noTextSelected,
            replacementString: "44442222"
        )
        XCTAssertEqual("4444 2222 3488 8855 556", panTextField.text)
    }

    // MARK: Caret position tests

    func testShouldMoveCaretToEndWhenEnteringTextInEmptyField() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)
        let textToInsert = "44443333"
        let caretPosition = NSRange(location: 0, length: 0)

        _ = presenter.textField(
            panTextField,
            shouldChangeCharactersIn: caretPosition,
            replacementString: textToInsert
        )

        XCTAssertEqual("4444 3333", panTextField.text)
        waitThen {
            XCTAssertEqual(9, self.caretPosition())
        }
    }

    func testShouldMoveCaretWhenSingleDigitIsInserted() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "4444 3333"
        let textToInsert = "1"
        let caretPosition = NSRange(location: 6, length: 0)

        _ = presenter.textField(
            panTextField,
            shouldChangeCharactersIn: caretPosition,
            replacementString: textToInsert
        )

        XCTAssertEqual("4444 3133 3", panTextField.text)
        waitThen {
            XCTAssertEqual(7, self.caretPosition())
        }
    }

    func testShouldMoveCaretAfterMultipleDigitsInsertedAtStart() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "4443"
        let textToInsert = "11"
        let caretPosition = NSRange(location: 0, length: 0)

        _ = presenter.textField(
            panTextField,
            shouldChangeCharactersIn: caretPosition,
            replacementString: textToInsert
        )

        XCTAssertEqual("1144 43", panTextField.text)
        waitThen {
            XCTAssertEqual(2, self.caretPosition())
        }
    }

    func
        testShouldMoveCaretAfterMultipleDigitsInsertedAtStartOverSelectionShorterThanNumberOfDigitsInserted()
    {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "4443"
        let textToInsert = "11"
        let selection = NSRange(location: 0, length: 1)

        _ = presenter.textField(
            panTextField,
            shouldChangeCharactersIn: selection,
            replacementString: textToInsert
        )

        XCTAssertEqual("1144 3", panTextField.text)
        waitThen {
            XCTAssertEqual(2, self.caretPosition())
        }
    }

    func
        testShouldMoveCaretAfterMultipleDigitsInsertedAtStartOverSelectionLongerThanNumberOfDigitsInserted()
    {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "4444 3333"
        let textToInsert = "11"
        let selection = NSRange(location: 0, length: 3)

        _ = presenter.textField(
            panTextField,
            shouldChangeCharactersIn: selection,
            replacementString: textToInsert
        )

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

        _ = presenter.textField(
            panTextField,
            shouldChangeCharactersIn: selection,
            replacementString: textToInsert
        )

        XCTAssertEqual("4444 1122 22", panTextField.text)
        waitThen {
            XCTAssertEqual(7, self.caretPosition())
        }
    }

    func testShouldMoveCaretWhenSelectedTextIsDeletedUsingBackspace() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "1234 5678"
        let textToInsert = ""
        let selection = NSRange(location: 1, length: 2)

        _ = presenter.textField(
            panTextField,
            shouldChangeCharactersIn: selection,
            replacementString: textToInsert
        )

        XCTAssertEqual("1456 78", panTextField.text)
        waitThen {
            XCTAssertEqual(1, self.caretPosition())
        }
    }

    func testShouldLeaveCaretInFrontOfSpaceWhenDigitInFrontOfSpaceIsDeleted() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "1234 5678"
        let textToInsert = ""
        let selection = NSRange(location: 5, length: 1)

        _ = presenter.textField(
            panTextField,
            shouldChangeCharactersIn: selection,
            replacementString: textToInsert
        )

        XCTAssertEqual("1234 678", panTextField.text)
        waitThen {
            XCTAssertEqual(5, self.caretPosition())
        }
    }

    func testShouldMoveCaretAfterDigitsPastedWhenTextPastedIsAMixtureOfDigitsAndSomethingElse() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "4444 3333"
        let textToInsert = "2  2abc"
        let caretPosition = NSRange(location: 6, length: 0)

        _ = presenter.textField(
            panTextField,
            shouldChangeCharactersIn: caretPosition,
            replacementString: textToInsert
        )

        XCTAssertEqual("4444 3223 33", panTextField.text)
        waitThen {
            XCTAssertEqual(8, self.caretPosition())
        }
    }

    func testShouldNotMoveCaretWhenTextPastedHasNoDigits() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "4444 3333"
        let textToInsert = "abc"
        let caretPosition = NSRange(location: 6, length: 0)

        _ = presenter.textField(
            panTextField,
            shouldChangeCharactersIn: caretPosition,
            replacementString: textToInsert
        )

        XCTAssertEqual("4444 3333", panTextField.text)
        waitThen {
            XCTAssertEqual(6, self.caretPosition())
        }
    }

    func
        testShouldMoveCaretAfterSpaceWhenDigitInsertedAsTheLastDigitOfAGroupThatAlreadyHasASpaceAfterIt()
    {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "4444 3333"
        let textToInsert = "2"
        let caretPosition = NSRange(location: 3, length: 0)

        _ = presenter.textField(
            panTextField,
            shouldChangeCharactersIn: caretPosition,
            replacementString: textToInsert
        )

        XCTAssertEqual("4442 4333 3", panTextField.text)
        waitThen {
            XCTAssertEqual(5, self.caretPosition())
        }
    }

    func testShouldAllowToPasteDigitOverSpaceAndMoveCaretAccordingly() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "4444 3333"
        let textToInsert = "2"
        let caretPosition = NSRange(location: 4, length: 1)

        _ = presenter.textField(
            panTextField,
            shouldChangeCharactersIn: caretPosition,
            replacementString: textToInsert
        )

        XCTAssertEqual("4444 2333 3", panTextField.text)
        waitThen {
            XCTAssertEqual(6, self.caretPosition())
        }
    }

    func testShouldAlsoDeletePreviousDigitAndMoveCaretAccordinglyWhenDeletingSpace() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "4444 3333"
        let textToInsert = ""
        let selection = NSRange(location: 4, length: 1)

        _ = presenter.textField(
            panTextField,
            shouldChangeCharactersIn: selection,
            replacementString: textToInsert
        )

        XCTAssertEqual("4443 333", panTextField.text)
        waitThen {
            XCTAssertEqual(3, self.caretPosition())
        }
    }

    func testShouldAllowToDeleteDigitLocatedInFrontOfSpaceAndLeaveCaretInFrontOfSpace() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "4444 3333"
        let textToInsert = ""
        let selection = NSRange(location: 5, length: 1)

        _ = presenter.textField(
            panTextField,
            shouldChangeCharactersIn: selection,
            replacementString: textToInsert
        )

        XCTAssertEqual("4444 333", panTextField.text)
        waitThen {
            XCTAssertEqual(5, self.caretPosition())
        }
    }

    func testShouldAllowToDeleteDigitLocatedBeforeSpaceAndMoveCaretAccordingly() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "4444 3333"
        let textToInsert = ""
        let selection = NSRange(location: 4, length: 1)

        _ = presenter.textField(
            panTextField,
            shouldChangeCharactersIn: selection,
            replacementString: textToInsert
        )

        XCTAssertEqual("4443 333", panTextField.text)
        waitThen {
            XCTAssertEqual(3, self.caretPosition())
        }
    }

    func testShouldShiftDigitsAndMoveCaretWhenPastingDigitsInAPanAlreadyAtMaxLength() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "4444 3333 2222 1111 000"
        let textToInsert = "9999"
        let selection = NSRange(location: 1, length: 0)

        _ = presenter.textField(
            panTextField,
            shouldChangeCharactersIn: selection,
            replacementString: textToInsert
        )

        XCTAssertEqual("4999 9444 3333 2222 111", panTextField.text)
        waitThen {
            XCTAssertEqual(6, self.caretPosition())
        }
    }

    func testShouldNotMoveCaretAfterSpaceWhenDeletingSelectionThatStartsWithASpace() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "4444 3333 2222 1111 000"
        let textToInsert = ""
        let selection = NSRange(location: 4, length: 3)

        _ = presenter.textField(
            panTextField,
            shouldChangeCharactersIn: selection,
            replacementString: textToInsert
        )

        XCTAssertEqual("4444 3322 2211 1100 0", panTextField.text)
        waitThen {
            XCTAssertEqual(4, self.caretPosition())
        }
    }

    // MARK: test for textFieldEditingChanged

    func testTextFieldEditingChangedShouldValidatePan() {
        let presenter = createPresenterWithCardSpacing(detectedCardBrand: unknownBrand)
        panTextField.text = "4444 333"

        presenter.textFieldEditingChanged(panTextField)

        verify(panValidationFlowMock).validate(pan: "4444 333")
    }
}
