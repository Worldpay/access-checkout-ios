import XCTest
import Foundation
@testable import AccessCheckoutSDK

class CvvOnlyFlowRetrieveSessionTests: XCTestCase {
    var view:CvvOnlyFlowViewPageObject?
    
    override func setUp() {
        continueAfterFailure = false
    }
    
    func testSuccessfullyCreatesAndDisplaysACvvSession() {
        let expectedTitle = "Session"
        let expectedMessage = "https://try.access.worldpay.com/sessions/some-uri"
        
        let app = appLauncher().discoveryStub(respondsWith: "Discovery-success")
            .sessionsStub(respondsWith: "sessions-success")
            .sessionsPaymentsCvcStub(respondsWith: "sessions-paymentsCvc-success")
            .launch()
        let view = NavigationViewPageObject(app).navigateToCvvOnlyFlow()
        view.typeTextIntoCvv("123")
        view.submit()
        
        let alert = view.alert
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(expectedTitle, alert.title)
        XCTAssertEqual(expectedMessage, alert.message)
    }
    
    func testClearsCvvWhenAlertWithSessionIsClosed() {
        let app = appLauncher().discoveryStub(respondsWith: "Discovery-success")
            .sessionsStub(respondsWith: "sessions-success")
            .sessionsPaymentsCvcStub(respondsWith: "sessions-paymentsCvc-success")
            .launch()
        let view = NavigationViewPageObject(app).navigateToCvvOnlyFlow()
        view.typeTextIntoCvv("123")
        view.submit()
        
        let alert = view.alert
        XCTAssertTrue(alert.exists)
        
        alert.close()
        XCTAssertFalse(alert.exists)
        
        waitFor(timeoutInSeconds: 0.5)
        XCTAssertEqual(view.cvvField.placeholderValue, view.cvvText)
    }
    
    func testSuccessfullyDisplaysErrorFromService() {
        let expectedTitle = "Error"
        let validationError = AccessCheckoutClientValidationError.stringFailedRegexCheck(message: "Some validation error message", jsonPath: "$.cvv")
        let error = AccessCheckoutClientError.bodyDoesNotMatchSchema(message: "Sessions paymentsCvc error", validationErrors: [validationError])
        let expectedMessage = formatStringAsStaticTextLabel(error.localizedDescription)
        
        let app = appLauncher().discoveryStub(respondsWith: "Discovery-success")
            .sessionsStub(respondsWith: "sessions-success")
            .sessionsPaymentsCvcStub(respondsWith: "sessions-paymentsCvc-error")
            .launch()
        let view = NavigationViewPageObject(app).navigateToCvvOnlyFlow()
        view.typeTextIntoCvv("123")
        view.submit()
        
        let alert = view.alert
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(expectedTitle, alert.title)
        XCTAssertEqual(expectedMessage, alert.message)
    }
    
    func testDoesNotClearCvvWhenAlertWithErrorIsClosed() {
        let app = appLauncher().discoveryStub(respondsWith: "Discovery-success")
            .sessionsStub(respondsWith: "sessions-success")
            .sessionsPaymentsCvcStub(respondsWith: "sessions-paymentsCvc-error")
            .launch()
        let view = NavigationViewPageObject(app).navigateToCvvOnlyFlow()
        view.typeTextIntoCvv("123")
        view.submit()
        
        let alert = view.alert
        XCTAssertTrue(alert.exists)
        
        alert.close()
        XCTAssertFalse(alert.exists)
        
        waitFor(timeoutInSeconds: 0.5)
        XCTAssertEqual("123", view.cvvText)
    }
    
    private func formatStringAsStaticTextLabel(_ string: String) -> String {
        // The XCUI framework seems to replace carriage returns by spaces for alert labels
        // This function is designed to format strings the same way so that we can search staticTexts accordingly
        return string.replacingOccurrences(of:"\n", with:" ")
    }
    
    private func waitFor(timeoutInSeconds:Double) {
        let exp = expectation(description: "Waiting for \(timeoutInSeconds)")
        XCTWaiter.wait(for: [exp], timeout: timeoutInSeconds)
    }
}
