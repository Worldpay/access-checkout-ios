import XCTest
@testable import AccessCheckoutSDK

class CardPaymentFlowRetrieveSessionTests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    func testResponseSuccess() {
        let app = appLauncher().discoveryStub(respondsWith: "Discovery-success")
            .verifiedTokensStub(respondsWith: "VerifiedTokens-success")
            .verifiedTokensSessionStub(respondsWith: "VerifiedTokensSession-success")
            .launch()
        let view = CardPaymentFlowViewPageObject(app)

        fillUpFormWithValidValues(using: view)
        view.submit()
        waitFor(timeoutInSeconds: 0.05)
        
        let alert = view.alert
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.title, "Session")
    }
    
    func testResponse_internalServerError() {
        let app = appLauncher().discoveryStub(respondsWith: "Discovery-success")
            .verifiedTokensStub(respondsWith: "VerifiedTokens-success")
            .verifiedTokensSessionStub(respondsWith: "VerifiedTokens-internalServerError")
            .launch()
        let view = CardPaymentFlowViewPageObject(app)
        
        fillUpFormWithValidValues(using: view)
        view.submit()
        waitFor(timeoutInSeconds: 0.05)
        
        let alert = view.alert
        XCTAssertTrue(alert.exists)
        XCTAssert(alert.title.contains(AccessCheckoutClientError.internalServerError(message: nil).errorName))
    }
    
    func testResponse_bodyDoesNotMatchSchema_panFailedLuhnCheck() {
        let app = appLauncher().discoveryStub(respondsWith: "Discovery-success")
            .verifiedTokensStub(respondsWith: "VerifiedTokens-success")
            .verifiedTokensSessionStub(respondsWith: "VerifiedTokens-bodyDoesNotMatchSchema-panFailedLuhnCheck")
            .launch()
        let view = CardPaymentFlowViewPageObject(app)
        
        fillUpFormWithValidValues(using: view)
        view.submit()
        waitFor(timeoutInSeconds: 0.05)
        
        let alert = view.alert
        XCTAssertTrue(alert.exists)
        XCTAssert(alert.title.contains(AccessCheckoutClientError.bodyDoesNotMatchSchema(message: nil, validationErrors: nil).errorName))
        XCTAssert(alert.title.contains(AccessCheckoutClientValidationError.panFailedLuhnCheck(message: nil, jsonPath: nil).errorName))
        XCTAssert(alert.title.contains(VerifiedTokensSessionRequest.Key.cardNumber.rawValue))
    }
    
    func testResponse_bodyDoesNotMatchSchema_fieldIsMissing_cardNumber() {
        let app = appLauncher().discoveryStub(respondsWith: "Discovery-success")
            .verifiedTokensStub(respondsWith: "VerifiedTokens-success")
            .verifiedTokensSessionStub(respondsWith: "VerifiedTokens-bodyDoesNotMatchSchema-fieldIsMissing-cardNumber")
            .launch()
        let view = CardPaymentFlowViewPageObject(app)
        
        fillUpFormWithValidValues(using: view)
        view.submit()
        waitFor(timeoutInSeconds: 0.05)
        
        let alert = view.alert
        XCTAssertTrue(alert.exists)
        XCTAssert(alert.title.contains(AccessCheckoutClientError.bodyDoesNotMatchSchema(message: nil, validationErrors: nil).errorName))
        XCTAssert(alert.title.contains(AccessCheckoutClientValidationError.fieldIsMissing(message: nil, jsonPath: nil).errorName))
        XCTAssert(alert.title.contains(VerifiedTokensSessionRequest.Key.cardNumber.rawValue))
    }

    func testResponse_unknown_variation1() {
        let app = appLauncher().discoveryStub(respondsWith: "Discovery-success")
            .verifiedTokensStub(respondsWith: "VerifiedTokens-success")
            .verifiedTokensSessionStub(respondsWith: "VerifiedTokens-unknown-variation1")
            .launch()
        let view = CardPaymentFlowViewPageObject(app)
        
        fillUpFormWithValidValues(using: view)
        view.submit()
        waitFor(timeoutInSeconds: 0.05)
        
        let alert = view.alert
        XCTAssertTrue(alert.exists)
        XCTAssert(alert.title.contains(AccessCheckoutClientError.unknown(message: nil).errorName))
        XCTAssert(alert.title.contains("variation1"))
    }
    
    func testResponse_unknown_variation2() {
        let app = appLauncher().discoveryStub(respondsWith: "Discovery-success")
            .verifiedTokensStub(respondsWith: "VerifiedTokens-success")
            .verifiedTokensSessionStub(respondsWith: "VerifiedTokens-unknown-variation2")
            .launch()
        let view = CardPaymentFlowViewPageObject(app)
        
        fillUpFormWithValidValues(using: view)
        view.submit()
        waitFor(timeoutInSeconds: 0.05)
        
        let alert = view.alert
        XCTAssertTrue(alert.exists)
        XCTAssert(alert.title.contains(AccessCheckoutClientError.unknown(message: nil).errorName))
        XCTAssert(alert.title.contains("variation2"))
    }
    
    func testResponse_unknown_variation3() {
        let app = appLauncher().discoveryStub(respondsWith: "Discovery-success")
            .verifiedTokensStub(respondsWith: "VerifiedTokens-success")
            .verifiedTokensSessionStub(respondsWith: "VerifiedTokens-unknown-variation3")
            .launch()
        let view = CardPaymentFlowViewPageObject(app)
        
        fillUpFormWithValidValues(using: view)
        view.submit()
        waitFor(timeoutInSeconds: 0.05)
        
        let alert = view.alert
        XCTAssertTrue(alert.exists)
        XCTAssert(alert.title.contains(AccessCheckoutClientError.unknown(message: nil).errorName))
        XCTAssert(alert.title.contains("variation3"))
    }
    
    func testResponse_unknown_variation4() {
        let app = appLauncher().discoveryStub(respondsWith: "Discovery-success")
            .verifiedTokensStub(respondsWith: "VerifiedTokens-success")
            .verifiedTokensSessionStub(respondsWith: "VerifiedTokens-unknown-variation4")
            .launch()
        let view = CardPaymentFlowViewPageObject(app)
        
        fillUpFormWithValidValues(using: view)
        view.submit()
        waitFor(timeoutInSeconds: 0.05)
        
        let alert = view.alert
        XCTAssertTrue(alert.exists)
        XCTAssert(alert.title.contains(AccessCheckoutClientError.unknown(message: nil).errorName))
        XCTAssert(alert.title.contains("variation4"))
    }
    
    private func fillUpFormWithValidValues(using view:CardPaymentFlowViewPageObject) {
        view.typeTextIntoPan("4111111111111111")
        view.typeTextIntoExpiryMonth("01")
        view.typeTextIntoExpiryYear("99")
        view.typeTextIntoCvv("123")
    }
    
    private func waitFor(timeoutInSeconds:Double) {
        let exp = expectation(description: "Waiting for \(timeoutInSeconds)")
        XCTWaiter.wait(for: [exp], timeout: timeoutInSeconds)
    }
}
