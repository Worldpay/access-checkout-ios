@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class PanViewPresenterTests: PresenterTestSuite {
    private let panValidatorMock = mockPanValidator()
    private let panValidationFlow = mockPanValidationFlow()

    override func setUp() {
        panValidationFlow.getStubbingProxy().validate(pan: any()).thenDoNothing()
        panValidationFlow.getStubbingProxy().notifyMerchantIfNotAlreadyNotified().thenDoNothing()
        panValidatorMock.getStubbingProxy().canValidate(any()).thenReturn(true)
    }

    func testOnEditingValidatesPan() {
        let pan = "123"
        let presenter = PanViewPresenter(panValidationFlow, panValidatorMock, panFormattingEnabled: false)

        presenter.onEditing(text: pan)

        verify(panValidationFlow).validate(pan: pan)
    }

    func testOnEditEndNotifiesMerchantOfValidationStateIfNotAlreadyNotified() {
        let presenter = PanViewPresenter(panValidationFlow, panValidatorMock, panFormattingEnabled: false)

        presenter.onEditEnd()

        verify(panValidationFlow).notifyMerchantIfNotAlreadyNotified()
    }

    func testCanChangeTextChecksIfTheTextCanBeEnteredAndDoesNotTriggerValidationFlow() {
        let text = "123"
        let presenter = PanViewPresenter(panValidationFlow, panValidatorMock, panFormattingEnabled: false)

        _ = presenter.canChangeText(with: text)

        verify(panValidatorMock).canValidate(text)
        verifyNoMoreInteractions(panValidationFlow)
    }

    func testCanChangeTextWithEmptyText() {
        let presenter = PanViewPresenter(panValidationFlow, panValidatorMock, panFormattingEnabled: false)

        let result = presenter.canChangeText(with: "")

        XCTAssertTrue(result)
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

    // MARK: Tests for Presenter with UITextField

    private let visaBrand = TestFixtures.visaBrand()
    private let maestroBrand = TestFixtures.maestroBrand()
    private let configurationProvider = MockCardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock())

    private let validVisaPan = TestFixtures.validVisaPan1
    private let validVisaPanWithSpaces = TestFixtures.validVisaPan1WithSpaces

    private let validVisaPanAsLongAsMaxLengthAllowed = TestFixtures.validVisaPanAsLongAsMaxLengthAllowed
    private let validVisaPanAsLongAsMaxLengthAllowedWithSpaces = TestFixtures.validVisaPanAsLongAsMaxLengthAllowedWithSpaces

    private let visaPanThatFailsLuhnCheck = TestFixtures.visaPanThatFailsLuhnCheck
    private let visaPanThatFailsLuhnCheckWithSpaces = TestFixtures.visaPanThatFailsLuhnCheckWithSpaces

    private let visaPanTooLong = TestFixtures.visaPanTooLong

    func testOnEndEditingNotifiesMerchant() {
        let pan = "123"
        panTextField.text = pan
        let presenter = PanViewPresenter(panValidationFlow, panValidatorMock, panFormattingEnabled: false)

        presenter.textFieldDidEndEditing(panTextField)
        verify(panValidationFlow).notifyMerchantIfNotAlreadyNotified()
    }

    // MARK: testing what the end user can and cannot type

    func testCanClearText() {
        let range = NSRange(location: 0, length: 3)
        let presenter = PanViewPresenter(panValidationFlow, panValidatorMock, panFormattingEnabled: false)
        panValidationFlow.getStubbingProxy().getCardBrand().thenReturn(nil)
        panTextField.text = "123"
        presenter.textField(panTextField, shouldChangeCharactersIn: range, replacementString: "")

        XCTAssertEqual(panTextField.text, "")
        verify(panValidationFlow).notifyMerchantIfNotAlreadyNotified()
        verify(panValidationFlow).validate(pan: "")
    }

    func testCannotTypeNonNumericalCharacters() {
        let cardBrandsConfiguration = CardBrandsConfiguration(allCardBrands: [visaBrand], acceptedCardBrands: [])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        panValidationFlow.getStubbingProxy().getCardBrand().thenReturn(nil)
        XCTAssertEqual(panTextField.text, "")

        let panValidator = PanValidator(configurationProvider)
        let presenter = PanViewPresenter(panValidationFlow, panValidator, panFormattingEnabled: true)

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, "abc")
        XCTAssertEqual(panTextField.text, "")
        verify(panValidationFlow).getCardBrand()
        verifyNoMoreInteractions(panValidationFlow)

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, "-*+")
        XCTAssertEqual(panTextField.text, "")
    }

    func testCanTypeValidVisaPan() {
        let cardBrandsConfiguration = CardBrandsConfiguration(allCardBrands: [visaBrand], acceptedCardBrands: [])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        panValidationFlow.getStubbingProxy().getCardBrand().thenReturn(visaBrand)

        let panValidator = PanValidator(configurationProvider)
        let presenter = PanViewPresenter(panValidationFlow, panValidator, panFormattingEnabled: false)

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, validVisaPan)
        XCTAssertEqual(panTextField.text, validVisaPan)
        verify(panValidationFlow).notifyMerchantIfNotAlreadyNotified()
        verify(panValidationFlow).validate(pan: validVisaPan)
    }

    func testCanTypeVisaPanThatFailsLuhnCheck() {
        let cardBrandsConfiguration = CardBrandsConfiguration(allCardBrands: [visaBrand], acceptedCardBrands: [])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        panValidationFlow.getStubbingProxy().getCardBrand().thenReturn(visaBrand)

        let panValidator = PanValidator(configurationProvider)
        let presenter = PanViewPresenter(panValidationFlow, panValidator, panFormattingEnabled: false)

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, visaPanThatFailsLuhnCheck)
        XCTAssertEqual(panTextField.text, visaPanThatFailsLuhnCheck)
        verify(panValidationFlow).notifyMerchantIfNotAlreadyNotified()
        verify(panValidationFlow).validate(pan: visaPanThatFailsLuhnCheck)
    }

    func testCanTypeVisaPanAsLongAsMaxLengthAllowed() {
        let cardBrandsConfiguration = CardBrandsConfiguration(allCardBrands: [visaBrand], acceptedCardBrands: [])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        panValidationFlow.getStubbingProxy().getCardBrand().thenReturn(visaBrand)

        let panValidator = PanValidator(configurationProvider)
        let presenter = PanViewPresenter(panValidationFlow, panValidator, panFormattingEnabled: false)

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, validVisaPanAsLongAsMaxLengthAllowed)
        XCTAssertEqual(panTextField.text, validVisaPanAsLongAsMaxLengthAllowed)
        verify(panValidationFlow).notifyMerchantIfNotAlreadyNotified()
        verify(panValidationFlow).validate(pan: validVisaPanAsLongAsMaxLengthAllowed)
    }

    func testCannotTypeVisaPanThatExceedsMaximiumLength() {
        let cardBrandsConfiguration = CardBrandsConfiguration(allCardBrands: [visaBrand], acceptedCardBrands: [])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        panValidationFlow.getStubbingProxy().getCardBrand().thenReturn(visaBrand)

        let panValidator = PanValidator(configurationProvider)
        let presenter = PanViewPresenter(panValidationFlow, panValidator, panFormattingEnabled: false)

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, visaPanTooLong)
        XCTAssertEqual(panTextField.text, "")
        verify(panValidationFlow).getCardBrand()
        verifyNoMoreInteractions(panValidationFlow)
    }

    //  This test is important because the Visa pattern excludes explictly the Maestro pattern so we want
    // to make sure that it does not prevent the user from typing a maestro PAN
    func testCanTypeStartOfMaestroPan() {
        let cardBrandsConfiguration = CardBrandsConfiguration(allCardBrands: [visaBrand, maestroBrand], acceptedCardBrands: [])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        panValidationFlow.getStubbingProxy().getCardBrand().thenReturn(maestroBrand)

        let panValidator = PanValidator(configurationProvider)
        let presenter = PanViewPresenter(panValidationFlow, panValidator, panFormattingEnabled: false)

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, "493698123")
        XCTAssertEqual(panTextField.text, "493698123")
        verify(panValidationFlow).notifyMerchantIfNotAlreadyNotified()
        verify(panValidationFlow).validate(pan: "493698123")
    }

    func testCanTypePanOfUnknownBrandAsLongAsMaxLengthAllowed() {
        let cardBrandsConfiguration = CardBrandsConfiguration(allCardBrands: [], acceptedCardBrands: [])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        panValidationFlow.getStubbingProxy().getCardBrand().thenReturn(nil)

        let panValidator = PanValidator(configurationProvider)
        let presenter = PanViewPresenter(panValidationFlow, panValidator, panFormattingEnabled: false)

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, "1234567890123456789")
        XCTAssertEqual(panTextField.text, "1234567890123456789")
        verify(panValidationFlow).notifyMerchantIfNotAlreadyNotified()
        verify(panValidationFlow).validate(pan: "1234567890123456789")
    }

    func testCannotTypePanOfUnknownBrandThatExceedsMaximiumLength() {
        let cardBrandsConfiguration = CardBrandsConfiguration(allCardBrands: [visaBrand, maestroBrand], acceptedCardBrands: [])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        panValidationFlow.getStubbingProxy().getCardBrand().thenReturn(nil)

        let panValidator = PanValidator(configurationProvider)
        let presenter = PanViewPresenter(panValidationFlow, panValidator, panFormattingEnabled: false)

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, "12345678901234567890")
        XCTAssertEqual(panTextField.text, "")
        verify(panValidationFlow).getCardBrand()
        verifyNoMoreInteractions(panValidationFlow)
    }

    // card spacing feature
    func testCanTypeValidVisaPanWithSpaces() {
        let cardBrandsConfiguration = CardBrandsConfiguration(allCardBrands: [visaBrand], acceptedCardBrands: [])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        panValidationFlow.getStubbingProxy().getCardBrand().thenReturn(visaBrand)

        let panValidator = PanValidator(configurationProvider)
        let presenter = PanViewPresenter(panValidationFlow, panValidator, panFormattingEnabled: false)

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, validVisaPanWithSpaces)
        XCTAssertEqual(panTextField.text, validVisaPanWithSpaces)
        verify(panValidationFlow).notifyMerchantIfNotAlreadyNotified()
        verify(panValidationFlow).validate(pan: validVisaPanWithSpaces)
    }

    func testCanTypeVisaPanWithSpacesAsLongAsMaxLengthAllowed() {
        let cardBrandsConfiguration = CardBrandsConfiguration(allCardBrands: [visaBrand], acceptedCardBrands: [])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        panValidationFlow.getStubbingProxy().getCardBrand().thenReturn(visaBrand)

        let panValidator = PanValidator(configurationProvider)
        let presenter = PanViewPresenter(panValidationFlow, panValidator, panFormattingEnabled: false)

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, validVisaPanAsLongAsMaxLengthAllowedWithSpaces)
        XCTAssertEqual(panTextField.text, validVisaPanAsLongAsMaxLengthAllowedWithSpaces)
        verify(panValidationFlow).notifyMerchantIfNotAlreadyNotified()
        verify(panValidationFlow).validate(pan: validVisaPanAsLongAsMaxLengthAllowedWithSpaces)
    }

    func testCanTypeUnknownPanWithSpacesAsLongAsMaxLengthAllowed() {
        let cardBrandsConfiguration = CardBrandsConfiguration(allCardBrands: [visaBrand], acceptedCardBrands: [])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        panValidationFlow.getStubbingProxy().getCardBrand().thenReturn(nil)

        let panValidator = PanValidator(configurationProvider)
        let presenter = PanViewPresenter(panValidationFlow, panValidator, panFormattingEnabled: false)

        enterPanInUITextField(presenter: presenter, uiTextField: panTextField, "1234 5678 9012 3456 789")
        XCTAssertEqual(panTextField.text, "1234 5678 9012 3456 789")
        verify(panValidationFlow).notifyMerchantIfNotAlreadyNotified()
        verify(panValidationFlow).validate(pan: "1234 5678 9012 3456 789")
    }
}
