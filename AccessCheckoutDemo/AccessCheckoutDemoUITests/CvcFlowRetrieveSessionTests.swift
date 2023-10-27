import XCTest
@testable import AccessCheckoutSDK

class CvcFlowRetrieveSessionTests: XCTestCase {
    private let expectedCvcSessionRegex = "http:\\/\\/localhost:\\d{4}\\/sessions\\/[a-zA-Z0-9\\-]+"
    
    private var view: CvcFlowViewPageObject?
    private let serviceStubs = ServiceStubs()
    
    override func setUp() {
        continueAfterFailure = false
        
        _ = serviceStubs
            .cardConfiguration()
            .discovery(respondWith: .discoverySuccess)
            .verifiedTokensRoot(respondWith: .verifiedTokensRootSuccess)
            .sessionsRoot(respondWith: .sessionsRootSuccess)
    }
    
    func testSuccessfullyCreatesAndDisplaysACvcSession() {
        serviceStubs
            .sessionsPaymentsCvc(respondWith: .sessionsPaymentsCvcSuccess)
            .start()
        let app = appLauncher().launch(enableStubs: true)
        
        let expectedTitle = "Payments CVC Session"
        
        let view = NavigationViewPageObject(app).navigateToCvcFlow()
        view.typeTextIntoCvc("123")
        view.submit()

        let alert = view.alert
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(expectedTitle, alert.title)
        XCTAssertNotNil(alert.message.range(of: expectedCvcSessionRegex, options: .regularExpression))
    }
    
    func testClearsCvcAndDisablesButtonWhenAlertWithSessionIsClosed() {
        serviceStubs
            .sessionsPaymentsCvc(respondWith: .sessionsPaymentsCvcSuccess)
            .start()
        let app = appLauncher().launch(enableStubs: true)

        let view = NavigationViewPageObject(app).navigateToCvcFlow()
        view.typeTextIntoCvc("123")
        view.submit()
        
        let alert = view.alert
        XCTAssertTrue(alert.exists)
        
        alert.close()
        XCTAssertFalse(alert.exists)
        
        waitFor(timeoutInSeconds: 0.5)
        XCTAssertEqual(view.cvcField.placeholderValue, view.cvcText)
        XCTAssertEqual(view.submitButton.isEnabled, false)
    }
    
    func testSuccessfullyDisplaysErrorFromService() {
        let expectedTitle = "Error"
        let jsonError = """
        {
            "errorName": "bodyDoesNotMatchSchema",
            "message": "Sessions paymentsCvc error",
            "validationErrors": [{
                "errorName": "stringFailedRegexCheck",
                "message": "Some validation error message",
                "jsonPath": "$.cvv"
            }]
        }
        """
        
        let error = try! JSONDecoder().decode(AccessCheckoutError.self, from: jsonError.data(using: .utf8)!)
        let expectedMessage = formatStringAsStaticTextLabel(error.localizedDescription)
        
        serviceStubs
            .sessionsPaymentsCvc(respondWith: .sessionsPaymentsCvcError)
            .start()
        let app = appLauncher().launch(enableStubs: true)

        let view = NavigationViewPageObject(app).navigateToCvcFlow()
        view.typeTextIntoCvc("123")
        view.submit()
        
        let alert = view.alert
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(expectedTitle, alert.title)
        XCTAssertEqual(expectedMessage, alert.message)
    }
    
    func testDoesNotClearCvcWhenAlertWithErrorIsClosed() {
        serviceStubs
            .sessionsPaymentsCvc(respondWith: .sessionsPaymentsCvcError)
            .start()
        let app = appLauncher().launch(enableStubs: true)

        let view = NavigationViewPageObject(app).navigateToCvcFlow()
        view.typeTextIntoCvc("123")
        view.submit()
        
        let alert = view.alert
        XCTAssertTrue(alert.exists)
        
        alert.close()
        XCTAssertFalse(alert.exists)
        
        waitFor(timeoutInSeconds: 0.05)
        XCTAssertEqual("123", view.cvcText)
    }
    
    private func formatStringAsStaticTextLabel(_ string: String) -> String {
        // The XCUI framework seems to replace carriage returns by spaces for alert labels
        // This function is designed to format strings the same way so that we can search staticTexts accordingly
        return string.replacingOccurrences(of: "\n", with: " ")
    }
    
    private func waitFor(timeoutInSeconds: Double) {
        let exp = expectation(description: "Waiting for \(timeoutInSeconds)")
        _ = XCTWaiter.wait(for: [exp], timeout: timeoutInSeconds)
    }
}
