import Cuckoo
import XCTest

@testable import AccessCheckoutSDK

class PanViewPresenterCobrandedCardsTests: XCTestCase {

    private var mockPanValidationFlow: MockPanValidationFlow!
    private var mockPanValidator: MockPanValidator!
    private var presenter: PanViewPresenter!

    override func setUp() {
        super.setUp()

        let configurationProvider = MockCardBrandsConfigurationProvider(
            CardBrandsConfigurationFactoryMock()
        )
        mockPanValidator = MockPanValidator(configurationProvider)

        let mockCardBinService = MockCardBinService(
            checkoutId: "0000-0000-0000-0000-000000000000",
            client: MockCardBinApiClient(),
            configurationProvider: configurationProvider
        )

        mockPanValidationFlow = MockPanValidationFlow(
            mockPanValidator,
            MockPanValidationStateHandler(),
            MockCvcValidationFlow(MockCvcValidator(), MockCvcValidationStateHandler()),
            mockCardBinService
        )

        stub(mockPanValidationFlow) { stub in
            when(stub.validate(pan: any())).thenDoNothing()
            when(stub.handleCobrandedCards(pan: any())).thenDoNothing()
            when(stub.notifyMerchant()).thenDoNothing()
        }

        presenter = PanViewPresenter(
            mockPanValidationFlow,
            mockPanValidator,
            panFormattingEnabled: false
        )
    }

    func testOnEditing_callsHandleCobrandedCards() {
        let pan = "444433332222"

        presenter.onEditing(text: pan)

        verify(mockPanValidationFlow).handleCobrandedCards(pan: pan)
        verify(mockPanValidationFlow).validate(pan: pan)
    }

    func testOnEditing_callsHandleCobrandedCardsWithShortPan() {
        let pan = "4444"

        presenter.onEditing(text: pan)

        verify(mockPanValidationFlow).handleCobrandedCards(pan: pan)
        verify(mockPanValidationFlow).validate(pan: pan)
    }

    func testTextFieldEditingChanged_triggersHandleCobrandedCards() {
        let textField = UITextField()
        textField.text = "444433332222"

        presenter.textFieldEditingChanged(textField)

        verify(mockPanValidationFlow).handleCobrandedCards(pan: "444433332222")
        verify(mockPanValidationFlow).validate(pan: "444433332222")
    }

}
