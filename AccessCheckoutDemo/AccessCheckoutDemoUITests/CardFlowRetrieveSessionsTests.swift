import XCTest
@testable import AccessCheckoutSDK

class CardPaymentFlowRetrieveSessionsTests: XCTestCase {
    private let expectedVtSessionRegex = "http:\\/\\/localhost:\\d{4}\\/verifiedTokens\\/sessions\\/[a-zA-Z0-9\\-]+"
    private let expectedCvcSessionRegex = "http:\\/\\/localhost:\\d{4}\\/sessions\\/[a-zA-Z0-9\\-]+"
    
    private let serviceStubs = ServiceStubs()
    
    override func setUp() {
        continueAfterFailure = false
              
        _ = serviceStubs
            .cardConfiguration()
            .discovery(respondWith: .discoverySuccess)
            .verifiedTokensRoot(respondWith: .verifiedTokensRootSuccess)
            .sessionsRoot(respondWith: .sessionsRootSuccess)
    }
    
    override func tearDown() {
        serviceStubs.stop()
    }
    
    func testRetrievesAVerifiedTokensSession_whenPaymentsCvcSessionToggleIsOff() {
        serviceStubs
            .verifiedTokensSessions(respondWith: .verifiedTokensSessionSuccess)
            .start()
        
        let app = appLauncher().launch(enableStubs: true)
        let expectedTitle = "Verified Tokens Session"
        
        let view = CardFlowViewPageObject(app)
        
        fillUpFormWithValidValues(using: view)
        view.submit()
        
        let alert = view.alert
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.title, expectedTitle)
        XCTAssertNotNil(alert.message.range(of: expectedVtSessionRegex, options: .regularExpression))
    }

    func testRetrievesAVerifiedTokensSessionAndAPaymentsCvcSessionToken_whenPaymentsCvcSessionToggleIsOn() {
        serviceStubs
            .verifiedTokensSessions(respondWith: .verifiedTokensSessionSuccess)
            .sessionsPaymentsCvc(respondWith: .sessionsPaymentsCvcSuccess)
            .start()
        
        let app = appLauncher().launch(enableStubs: true)
        let view = CardFlowViewPageObject(app)
        let expectedTitle = "Verified Tokens & Payments CVC Sessions"

        fillUpFormWithValidValues(using: view)
        view.paymentsCvcSessionToggle.toggleOn()
        view.submit()

        let alert = view.alert
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.title, expectedTitle)
        XCTAssertNotNil(alert.message.range(of: expectedVtSessionRegex, options: .regularExpression))
        XCTAssertNotNil(alert.message.range(of: expectedCvcSessionRegex, options: .regularExpression))
    }

    func testClearsFormAndDisablesButtonWhenAlertWithSessionIsClosed() {
        serviceStubs
            .verifiedTokensSessions(respondWith: .verifiedTokensSessionSuccess)
            .sessionsPaymentsCvc(respondWith: .sessionsPaymentsCvcSuccess)
            .start()
        
        let app = appLauncher().launch(enableStubs: true)
        let view = CardFlowViewPageObject(app)
        let expectedTitle = "Verified Tokens Session"

        fillUpFormWithValidValues(using: view)
        view.submit()

        let alert = view.alert
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.title, expectedTitle)

        alert.close()
        XCTAssertFalse(alert.exists)

        waitFor(timeoutInSeconds: 0.5)
        XCTAssertEqual(view.panField.placeholderValue, view.panText)
        XCTAssertEqual(view.expiryDateField.placeholderValue, view.expiryDateText)
        XCTAssertEqual(view.cvcField.placeholderValue, view.cvcText)
        XCTAssertEqual(view.submitButton.isEnabled, false)
    }

    func testResponse_bodyDoesNotMatchSchema_panFailedLuhnCheck() {
        serviceStubs
            .verifiedTokensSessions(respondWith: .verifiedTokensSessionsPanFailedLuhnCheck)
            .start()
        
        let app = appLauncher().launch(enableStubs: true)
        let view = CardFlowViewPageObject(app)

        fillUpFormWithValidValues(using: view)
        view.submit()

        let alert = view.alert
        XCTAssertTrue(alert.exists)
        XCTAssert(alert.title.contains("bodyDoesNotMatchSchema"))
        XCTAssert(alert.title.contains("panFailedLuhnCheck"))
        XCTAssert(alert.title.contains(VerifiedTokensSessionRequest.Key.cardNumber.rawValue))
    }
    
    private func fillUpFormWithValidValues(using view: CardFlowViewPageObject) {
        view.typeTextIntoPan("4111111111111111")
        view.typeTextIntoExpiryDate("01/99")
        view.typeTextIntoCvc("123")
    }
    
    private func waitFor(timeoutInSeconds: Double) {
        let exp = expectation(description: "Waiting for \(timeoutInSeconds)")
        _ = XCTWaiter.wait(for: [exp], timeout: timeoutInSeconds)
    }
    
    private func formatStringAsStaticTextLabel(_ string: String) -> String {
        // The XCUI framework seems to replace carriage returns by spaces for alert labels
        // This function is designed to format strings the same way so that we can search staticTexts accordingly
        return string.replacingOccurrences(of: "\n", with: " ")
    }
}
