import XCTest
@testable import AccessCheckout

class VerifiedTokensTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSubmit_isEnabled() {
        
        let app = XCUIApplication()
        app.launch()
        let submit = app.buttons["submit"]
        
        // Initial state
        XCTAssertFalse(submit.isEnabled)
        
        let pan = app.textFields["pan"]
        pan.tap()
        pan.typeText("4111111111111111")
        
        let month = app.textFields["expiryMonth"]
        month.tap()
        month.typeText("01")
        
        let year = app.textFields["expiryYear"]
        year.tap()
        year.typeText("99")
        
        let cvv = app.textFields["cvv"]
        cvv.tap()
        cvv.typeText("123")
        
        // Valid state
        XCTAssertTrue(submit.isEnabled)
        
        let deleteKey = app.keys["Delete"]
        deleteKey.tap()
        
        // Invalid state
        XCTAssertFalse(submit.isEnabled)
    }

    func testResponseSuccess() {
        
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubDiscovery", "Discovery-success",
                                                "-stubVerifiedTokens", "VerifiedTokens-success",
                                                "-stubVerifiedTokensSession", "VerifiedTokensSession-success"])
        app.launch()
        
        let pan = app.textFields["pan"]
        pan.tap()
        pan.typeText("4111111111111111")
        
        let month = app.textFields["expiryMonth"]
        month.tap()
        month.typeText("01")
        
        let year = app.textFields["expiryYear"]
        year.tap()
        year.typeText("99")
        
        let cvv = app.textFields["cvv"]
        cvv.tap()
        cvv.typeText("123")
        
        app.buttons["submit"].tap()
        
        let alert = app.alerts.firstMatch
        let exists = alert.waitForExistence(timeout: 5)
        XCTAssertTrue(exists)
        XCTAssertEqual(alert.label, "Session")
    }
    
    func testResponse_internalServerError() {
        
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubDiscovery", "Discovery-success",
                                                "-stubVerifiedTokens", "VerifiedTokens-success",
                                                "-stubVerifiedTokensSession", "VerifiedTokens-internalServerError"])
        app.launch()
        
        let pan = app.textFields["pan"]
        pan.tap()
        pan.typeText("4111111111111111")
        
        let month = app.textFields["expiryMonth"]
        month.tap()
        month.typeText("01")
        
        let year = app.textFields["expiryYear"]
        year.tap()
        year.typeText("99")
        
        let cvv = app.textFields["cvv"]
        cvv.tap()
        cvv.typeText("123")
        
        app/*@START_MENU_TOKEN@*/.buttons["submit"]/*[[".buttons[\"Submit\"]",".buttons[\"submit\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let alertElement = app.alerts.element
        let exists = alertElement.waitForExistence(timeout: 5)
        XCTAssertTrue(exists)
        XCTAssert(alertElement.label.contains(AccessCheckoutClientError.internalServerError(message: nil).errorName))
    }
    
    func testResponse_bodyDoesNotMatchSchema_panFailedLuhnCheck() {
        
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubDiscovery", "Discovery-success",
                                                "-stubVerifiedTokens", "VerifiedTokens-success",
                                                "-stubVerifiedTokensSession", "VerifiedTokens-bodyDoesNotMatchSchema-panFailedLuhnCheck"])
        app.launch()
        
        let pan = app.textFields["pan"]
        pan.tap()
        pan.typeText("4111111111111111")
        
        let month = app.textFields["expiryMonth"]
        month.tap()
        month.typeText("01")
        
        let year = app.textFields["expiryYear"]
        year.tap()
        year.typeText("99")
        
        let cvv = app.textFields["cvv"]
        cvv.tap()
        cvv.typeText("123")
        
        app/*@START_MENU_TOKEN@*/.buttons["submit"]/*[[".buttons[\"Submit\"]",".buttons[\"submit\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let alertElement = app.alerts.element
        let exists = alertElement.waitForExistence(timeout: 5)
        XCTAssertTrue(exists)
        XCTAssert(alertElement.label.contains(AccessCheckoutClientError.bodyDoesNotMatchSchema(message: nil, validationErrors: nil).errorName))
        XCTAssert(alertElement.label.contains(AccessCheckoutClientValidationError.panFailedLuhnCheck(message: nil, jsonPath: nil).errorName))
        XCTAssert(alertElement.label.contains(VerifiedTokenRequest.Key.cardNumber.rawValue))
    }
    
    func testResponse_bodyDoesNotMatchSchema_fieldIsMissing_cardNumber() {
        
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubDiscovery", "Discovery-success",
                                                "-stubVerifiedTokens", "VerifiedTokens-success",
                                                "-stubVerifiedTokensSession", "VerifiedTokens-bodyDoesNotMatchSchema-fieldIsMissing-cardNumber"])
        app.launch()
        
        let pan = app.textFields["pan"]
        pan.tap()
        pan.typeText("4111111111111111")
        
        let month = app.textFields["expiryMonth"]
        month.tap()
        month.typeText("01")
        
        let year = app.textFields["expiryYear"]
        year.tap()
        year.typeText("99")
        
        let cvv = app.textFields["cvv"]
        cvv.tap()
        cvv.typeText("123")
        
        app/*@START_MENU_TOKEN@*/.buttons["submit"]/*[[".buttons[\"Submit\"]",".buttons[\"submit\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let alertElement = app.alerts.element
        let exists = alertElement.waitForExistence(timeout: 5)
        XCTAssertTrue(exists)
        XCTAssert(alertElement.label.contains(AccessCheckoutClientError.bodyDoesNotMatchSchema(message: nil, validationErrors: nil).errorName))
        XCTAssert(alertElement.label.contains(AccessCheckoutClientValidationError.fieldIsMissing(message: nil, jsonPath: nil).errorName))
        XCTAssert(alertElement.label.contains(VerifiedTokenRequest.Key.cardNumber.rawValue))
    }

    func testResponse_unknown_variation1() {
        
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubDiscovery", "Discovery-success",
                                                "-stubVerifiedTokens", "VerifiedTokens-success",
                                                "-stubVerifiedTokensSession", "VerifiedTokens-unknown-variation1"])
        app.launch()
        
        let pan = app.textFields["pan"]
        pan.tap()
        pan.typeText("4111111111111111")
        
        let month = app.textFields["expiryMonth"]
        month.tap()
        month.typeText("01")
        
        let year = app.textFields["expiryYear"]
        year.tap()
        year.typeText("99")
        
        let cvv = app.textFields["cvv"]
        cvv.tap()
        cvv.typeText("123")
        
        app/*@START_MENU_TOKEN@*/.buttons["submit"]/*[[".buttons[\"Submit\"]",".buttons[\"submit\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let alertElement = app.alerts.element
        let exists = alertElement.waitForExistence(timeout: 5)
        XCTAssertTrue(exists)
        XCTAssert(alertElement.label.contains(AccessCheckoutClientError.unknown(message: nil).errorName))
        XCTAssert(alertElement.label.contains("variation1"))
    }
    
    func testResponse_unknown_variation2() {
        
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubDiscovery", "Discovery-success",
                                                "-stubVerifiedTokens", "VerifiedTokens-success",
                                                "-stubVerifiedTokensSession", "VerifiedTokens-unknown-variation2"])
        app.launch()
        
        let pan = app.textFields["pan"]
        pan.tap()
        pan.typeText("4111111111111111")
        
        let month = app.textFields["expiryMonth"]
        month.tap()
        month.typeText("01")
        
        let year = app.textFields["expiryYear"]
        year.tap()
        year.typeText("99")
        
        let cvv = app.textFields["cvv"]
        cvv.tap()
        cvv.typeText("123")
        
        app/*@START_MENU_TOKEN@*/.buttons["submit"]/*[[".buttons[\"Submit\"]",".buttons[\"submit\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let alertElement = app.alerts.element
        let exists = alertElement.waitForExistence(timeout: 5)
        XCTAssertTrue(exists)
        XCTAssert(alertElement.label.contains(AccessCheckoutClientError.unknown(message: nil).errorName))
        XCTAssert(alertElement.label.contains("variation2"))
    }
    
    func testResponse_unknown_variation3() {
        
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubDiscovery", "Discovery-success",
                                                "-stubVerifiedTokens", "VerifiedTokens-success",
                                                "-stubVerifiedTokensSession", "VerifiedTokens-unknown-variation3"])
        app.launch()
        
        let pan = app.textFields["pan"]
        pan.tap()
        pan.typeText("4111111111111111")
        
        let month = app.textFields["expiryMonth"]
        month.tap()
        month.typeText("01")
        
        let year = app.textFields["expiryYear"]
        year.tap()
        year.typeText("99")
        
        let cvv = app.textFields["cvv"]
        cvv.tap()
        cvv.typeText("123")
        
        app/*@START_MENU_TOKEN@*/.buttons["submit"]/*[[".buttons[\"Submit\"]",".buttons[\"submit\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let alertElement = app.alerts.element
        let exists = alertElement.waitForExistence(timeout: 5)
        XCTAssertTrue(exists)
        XCTAssert(alertElement.label.contains(AccessCheckoutClientError.unknown(message: nil).errorName))
        XCTAssert(alertElement.label.contains("variation3"))
    }
    
    func testResponse_unknown_variation4() {
        
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubDiscovery", "Discovery-success",
                                                "-stubVerifiedTokens", "VerifiedTokens-success",
                                                "-stubVerifiedTokensSession", "VerifiedTokens-unknown-variation4"])
        app.launch()
        
        let pan = app.textFields["pan"]
        pan.tap()
        pan.typeText("4111111111111111")
        
        let month = app.textFields["expiryMonth"]
        month.tap()
        month.typeText("01")
        
        let year = app.textFields["expiryYear"]
        year.tap()
        year.typeText("99")
        
        let cvv = app.textFields["cvv"]
        cvv.tap()
        cvv.typeText("123")
        
        app/*@START_MENU_TOKEN@*/.buttons["submit"]/*[[".buttons[\"Submit\"]",".buttons[\"submit\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let alertElement = app.alerts.element
        let exists = alertElement.waitForExistence(timeout: 5)
        XCTAssertTrue(exists)
        XCTAssert(alertElement.label.contains(AccessCheckoutClientError.unknown(message: nil).errorName))
        XCTAssert(alertElement.label.contains("variation4"))
    }
}
