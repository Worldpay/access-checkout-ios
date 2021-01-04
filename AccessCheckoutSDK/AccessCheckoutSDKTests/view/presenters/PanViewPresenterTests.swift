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
        let presenter = PanViewPresenter(panValidationFlow, panValidatorMock)

        presenter.onEditing(text: pan)

        verify(panValidationFlow).validate(pan: pan)
    }

    func testOnEditEndNotifiesMerchantOfValidationStateIfNotAlreadyNotified() {
        let pan = "123"
        let presenter = PanViewPresenter(panValidationFlow, panValidatorMock)

        presenter.onEditEnd(text: pan)

        verify(panValidationFlow).notifyMerchantIfNotAlreadyNotified()
    }

    func testCanChangeTextChecksIfTheTextCanBeEnteredAndDoesNotTriggerValidationFlow() {
        let text = "123"
        let presenter = PanViewPresenter(panValidationFlow, panValidatorMock)

        _ = presenter.canChangeText(with: text)

        verify(panValidatorMock).canValidate(text)
        verifyNoMoreInteractions(panValidationFlow)
    }

    func testCanChangeTextWithEmptyText() {
        let presenter = PanViewPresenter(panValidationFlow, panValidatorMock)

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
    private let validVisaPanAsLongAsMaxLengthAllowed = TestFixtures.validVisaPanAsLongAsMaxLengthAllowed
    private let visaPanThatFailsLuhnCheck = TestFixtures.visaPanThatFailsLuhnCheck
    private let visaPanTooLong = TestFixtures.visaPanTooLong
    
    func testOnEndEditingNotifiesMerchant() {
        let pan = "123"
        panTextField.text = pan
        let presenter = PanViewPresenter(panValidationFlow, panValidatorMock)

        presenter.textFieldDidEndEditing(panTextField)
        verify(panValidationFlow).notifyMerchantIfNotAlreadyNotified()
    }
    
    // MARK: testing what the end user can and cannot type
    func testCanClearText() {
        _ = initialiseCustomCardValidation(configurationProvider: configurationProvider, cardBrands: [visaBrand])
        let range = NSRange(location: 0, length: 0)
        let presenter = PanViewPresenter(panValidationFlow, panValidatorMock)

        XCTAssertTrue(presenter.textField(panTextField, shouldChangeCharactersIn: range, replacementString: ""))
    }
    
    func testCannotTypeNonNumericalCharacters() {
        _ = initialiseCustomCardValidation(configurationProvider: configurationProvider, cardBrands: [visaBrand])
        let panValidator = PanValidator(configurationProvider)
        let presenter = PanViewPresenter(panValidationFlow, panValidator)

        XCTAssertFalse(canEnterPanInUITextField(presenter: presenter, uiTextField: panTextField, "abc"))
        XCTAssertFalse(canEnterPanInUITextField(presenter: presenter, uiTextField: panTextField, "-*+"))
    }
    
    func testCanTypeValidVisaPan() {
        _ = initialiseCustomCardValidation(configurationProvider: configurationProvider, cardBrands: [visaBrand])
        let panValidator = PanValidator(configurationProvider)
        let presenter = PanViewPresenter(panValidationFlow, panValidator)

        XCTAssertTrue(canEnterPanInUITextField(presenter: presenter, uiTextField: panTextField, validVisaPan))
    }

    func testCanTypeVisaPanThatFailsLuhnCheck() {
        _ = initialiseCustomCardValidation(configurationProvider: configurationProvider, cardBrands: [visaBrand])
        let panValidator = PanValidator(configurationProvider)
        let presenter = PanViewPresenter(panValidationFlow, panValidator)
        
        XCTAssertTrue(canEnterPanInUITextField(presenter: presenter, uiTextField: panTextField, visaPanThatFailsLuhnCheck))
    }

    func testCanTypeVisaPanAsLongAsMaxLengthAllowed() {
        _ = initialiseCustomCardValidation(configurationProvider: configurationProvider, cardBrands: [visaBrand])
        let panValidator = PanValidator(configurationProvider)
        let presenter = PanViewPresenter(panValidationFlow, panValidator)
        
        XCTAssertTrue(canEnterPanInUITextField(presenter: presenter, uiTextField: panTextField, validVisaPanAsLongAsMaxLengthAllowed))
    }

    func testCannotTypeVisaPanThatExceedsMaximiumLength() {
        _ = initialiseCustomCardValidation(configurationProvider: configurationProvider, cardBrands: [visaBrand])
        let panValidator = PanValidator(configurationProvider)
        let presenter = PanViewPresenter(panValidationFlow, panValidator)
        
        XCTAssertFalse(canEnterPanInUITextField(presenter: presenter, uiTextField: panTextField, visaPanTooLong))
    }

    //  This test is important because the Visa pattern excludes explictly the Maestro pattern so we want
    // to make sure that it does not prevent the user from typing a maestro PAN
    func testCanTypeStartOfMaestroPan() {
        _ = initialiseCustomCardValidation(configurationProvider: configurationProvider, cardBrands: [visaBrand, maestroBrand])
        let panValidator = PanValidator(configurationProvider)
        let presenter = PanViewPresenter(panValidationFlow, panValidator)

        XCTAssertTrue(canEnterPanInUITextField(presenter: presenter, uiTextField: panTextField,"493698123"))
    }

    func testCanTypePanOfUnknownBrandAsLongAsMaxLengthAllowed() {
        _ = initialiseCustomCardValidation(configurationProvider: configurationProvider, cardBrands: [])
        let panValidator = PanValidator(configurationProvider)
        let presenter = PanViewPresenter(panValidationFlow, panValidator)
        
        XCTAssertTrue(canEnterPanInUITextField(presenter: presenter, uiTextField: panTextField,"1234567890123456789"))
    }

    func testCannotTypePanOfUnknownBrandThatExceedsMaximiumLength() {
        _ = initialiseCustomCardValidation(configurationProvider: configurationProvider, cardBrands: [])
        let panValidator = PanValidator(configurationProvider)
        let presenter = PanViewPresenter(panValidationFlow, panValidator)
        
        XCTAssertFalse(canEnterPanInUITextField(presenter: presenter, uiTextField: panTextField,"12345678901234567890"))
    }
}
