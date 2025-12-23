import XCTest

@testable import AccessCheckoutSDK

class CardPaymentFlowRetrieveSessionsTests: BaseUITest {
    private let expectedCardSessionRegex =
        "http:\\/\\/localhost:\\d{4}\\/sessions\\/[a-zA-Z0-9\\-]+"
    private let expectedCvcSessionRegex = "http:\\/\\/localhost:\\d{4}\\/sessions\\/[a-zA-Z0-9\\-]+"

    private let serviceStubs = ServiceStubs()

    override func setUp() {
        super.setUp()
        _ =
            serviceStubs
            .cardConfiguration()
            .accessServicesRoot(respondWith: .accessServicesRootSuccess)
            .sessionsRoot(respondWith: .sessionsRootSuccess)
    }

    override func tearDown() {
        serviceStubs.stop()
    }

    func testRetrievesACardSession_whenPaymentsCvcSessionToggleIsOff() {
        serviceStubs
            .sessionsCard(respondWith: .cardSessionSuccess)
            .start()

        let app = AppLauncher.launch(enableStubs: true)
        let expectedTitle = "Card Session"

        let view = CardFlowViewPageObject(app)

        fillUpFormWithValidValues(using: view)
        view.submit()

        let alert = view.alert
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.title, expectedTitle)
        XCTAssertNotNil(
            alert.message.range(of: expectedCardSessionRegex, options: .regularExpression))
    }

    func testRetrievesACardSessionAndACvcSessionToken_whenPaymentsCvcSessionToggleIsOn() {
        serviceStubs
            .sessionsCard(respondWith: .cardSessionSuccess)
            .sessionsPaymentsCvc(respondWith: .cvcSessionSuccess)
            .start()

        let app = AppLauncher.launch(enableStubs: true)
        let view = CardFlowViewPageObject(app)
        let expectedTitle = "Card & CVC Sessions"

        fillUpFormWithValidValues(using: view)
        view.paymentsCvcSessionToggle.toggleOn()
        view.submit()

        let alert = view.alert
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.title, expectedTitle)
        XCTAssertNotNil(
            alert.message.range(of: expectedCardSessionRegex, options: .regularExpression))
        XCTAssertNotNil(
            alert.message.range(of: expectedCvcSessionRegex, options: .regularExpression))
    }

    func testClearsFormAndDisablesButtonWhenAlertWithSessionIsClosed() {
        serviceStubs
            .sessionsCard(respondWith: .cardSessionSuccess)
            .sessionsPaymentsCvc(respondWith: .cvcSessionSuccess)
            .start()

        let app = AppLauncher.launch(enableStubs: true)
        let view = CardFlowViewPageObject(app)
        let expectedTitle = "Card Session"

        fillUpFormWithValidValues(using: view)
        view.submit()

        let alert = view.alert
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.title, expectedTitle)

        alert.close()
        XCTAssertFalse(alert.exists)

        TestUtils.wait(seconds: 0.5)
        XCTAssertEqual(view.panField.placeholderValue, view.panText)
        XCTAssertEqual(view.expiryDateField.placeholderValue, view.expiryDateText)
        XCTAssertEqual(view.cvcField.placeholderValue, view.cvcText)
        XCTAssertEqual(view.submitButton.isEnabled, false)
    }

    func testResponse_bodyDoesNotMatchSchema_panFailedLuhnCheck() {
        serviceStubs
            .sessionsCard(respondWith: .cardSessionsPanFailedLuhnCheck)
            .start()

        let app = AppLauncher.launch(enableStubs: true)
        let view = CardFlowViewPageObject(app)

        fillUpFormWithValidValues(using: view)
        view.submit()

        let alert = view.alert
        XCTAssertTrue(alert.exists)
        XCTAssert(alert.title.contains("bodyDoesNotMatchSchema"))
        XCTAssert(alert.title.contains("panFailedLuhnCheck"))
        XCTAssert(alert.title.contains(CardSessionRequest.Key.cardNumber.rawValue))
    }

    private func fillUpFormWithValidValues(using view: CardFlowViewPageObject) {
        view.typeTextIntoPanCharByChar("4111111111111111")
        view.typeTextIntoExpiryDate("01/99")
        view.typeTextIntoCvc("123")
    }

    private func formatStringAsStaticTextLabel(_ string: String) -> String {
        // The XCUI framework seems to replace carriage returns by spaces for alert labels
        // This function is designed to format strings the same way so that we can search staticTexts accordingly
        return string.replacingOccurrences(of: "\n", with: " ")
    }
}
