@testable import AccessCheckoutSDK
import Foundation
import XCTest

class CvcFlowRetrieveSessionTests: XCTestCase {
    private let expectedCvcSessionRegex = "https:\\/\\/npe\\.access\\.worldpay\\.com\\/sessions\\/[a-zA-Z0-9\\-]+"
    
    var view: CvcFlowViewPageObject?
    
    override func setUp() {
        continueAfterFailure = false
    }
    
    func testSuccessfullyCreatesAndDisplaysACvcSession() {
        let expectedTitle = "Payments CVC Session"
        
        let app = appLauncher().discoveryStub(respondsWith: "Discovery-success")
            .sessionsStub(respondsWith: "sessions-success")
            .sessionsPaymentsCvcStub(respondsWith: "sessions-paymentsCvc-success")
            .launch()
        let view = NavigationViewPageObject(app).navigateToCvcFlow()
        view.typeTextIntoCvc("123")
        view.submit()
        waitFor(timeoutInSeconds: 0.05)
        
        let alert = view.alert
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(expectedTitle, alert.title)
        XCTAssertNotNil(alert.message.range(of: expectedCvcSessionRegex, options: .regularExpression))
    }
    
    func testClearsCvcAndDisablesButtonWhenAlertWithSessionIsClosed() {
        let app = appLauncher().discoveryStub(respondsWith: "Discovery-success")
            .sessionsStub(respondsWith: "sessions-success")
            .sessionsPaymentsCvcStub(respondsWith: "sessions-paymentsCvc-success")
            .launch()
        let view = NavigationViewPageObject(app).navigateToCvcFlow()
        view.typeTextIntoCvc("123")
        view.submit()
        waitFor(timeoutInSeconds: 0.05)
        
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
        
        let app = appLauncher().discoveryStub(respondsWith: "Discovery-success")
            .sessionsStub(respondsWith: "sessions-success")
            .sessionsPaymentsCvcStub(respondsWith: "sessions-paymentsCvc-error")
            .launch()
        let view = NavigationViewPageObject(app).navigateToCvcFlow()
        view.typeTextIntoCvc("123")
        view.submit()
        waitFor(timeoutInSeconds: 0.05)
        
        let alert = view.alert
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(expectedTitle, alert.title)
        XCTAssertEqual(expectedMessage, alert.message)
    }
    
    func testDoesNotClearCvcWhenAlertWithErrorIsClosed() {
        let app = appLauncher().discoveryStub(respondsWith: "Discovery-success")
            .sessionsStub(respondsWith: "sessions-success")
            .sessionsPaymentsCvcStub(respondsWith: "sessions-paymentsCvc-error")
            .launch()
        let view = NavigationViewPageObject(app).navigateToCvcFlow()
        view.typeTextIntoCvc("123")
        view.submit()
        waitFor(timeoutInSeconds: 0.05)
        
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
