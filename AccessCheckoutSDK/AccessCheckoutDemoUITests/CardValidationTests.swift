import XCTest
@testable import AccessCheckoutSDK

class CardValidationTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: Fields existance
    func testCardNumberTextField_exists() {
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubCardConfiguration", "CardConfiguration"])
        app.launch()
        XCTAssertTrue(app.textFields["pan"].exists)
    }
    
    func testExpiryDateView_exists() {
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubCardConfiguration", "CardConfiguration"])
        app.launch()
        XCTAssertTrue(app.otherElements["expiryDate"].exists)
    }
    
    func testCVVTextField_exists() {
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubCardConfiguration", "CardConfiguration"])
        app.launch()
        XCTAssertTrue(app.textFields["cvv"].exists)
    }
    
    func testCVVTextFieldPlaceholder_exists() {
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubCardConfiguration", "CardConfiguration"])
        app.launch()
        XCTAssertTrue(app.textFields["cvv"].placeholderValue == "CVV")
    }
    
    func testCardNumberImageView_exists() {
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubCardConfiguration", "CardConfiguration"])
        app.launch()
        XCTAssertTrue(app.images["cardBrandImage"].exists)
    }
    
    // MARK: PAN validation
    
    func testPAN_noValidator() {
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubCardConfiguration", ""])
        app.launch()
    }
    
    func testPAN_alpha() {
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubCardConfiguration", "CardConfiguration"])
        app.launch()
        let text = "A"
        let panField = app.textFields["pan"]
        panField.tap()
        panField.typeText(text)
        XCTAssertNotEqual(panField.value as? String, text)
    }
    
    func testExpiryMonth_alpha() {
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubCardConfiguration", "CardConfiguration"])
        app.launch()
        let text = "A"
        let expiryMonthField = app.textFields["expiryMonth"]
        expiryMonthField.tap()
        expiryMonthField.typeText(text)
        XCTAssertNotEqual(expiryMonthField.value as? String, text)
    }
    
    func testExpiryYear_alpha() {
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubCardConfiguration", "CardConfiguration"])
        app.launch()
        let text = "A"
        let expiryYearField = app.textFields["expiryYear"]
        expiryYearField.tap()
        expiryYearField.typeText(text)
        XCTAssertNotEqual(expiryYearField.value as? String, text)
    }
    
    func testCVV_alpha() {
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubCardConfiguration", "CardConfiguration"])
        app.launch()
        let text = "A"
        let cvvField = app.textFields["cvv"]
        cvvField.tap()
        cvvField.typeText(text)
        XCTAssertNotEqual(cvvField.value as? String, text)
        
    }
    
    func testPAN_maxLength() {
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubCardConfiguration", "CardConfiguration"])
        app.launch()
        let text = "111122223333444455556666"
        let panField = app.textFields["pan"]
        panField.tap()
        panField.typeText(text)
        XCTAssertEqual((panField.value as? String)?.count, 19)
    }
    
    func testExpiryMonth_maxLength() {
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubCardConfiguration", "CardConfiguration"])
        app.launch()
        let text = "1212"
        let field = app.textFields["expiryMonth"]
        field.tap()
        field.typeText(text)
        XCTAssertEqual((field.value as? String)?.count, 2)
        
    }
    
    func testExpiryYear_maxLength() {
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubCardConfiguration", "CardConfiguration"])
        app.launch()
        let text = "1212"
        let field = app.textFields["expiryYear"]
        field.tap()
        field.typeText(text)
        XCTAssertEqual((field.value as? String)?.count, 2)
    }
    
    func testCVV_maxLength() {
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubCardConfiguration", "CardConfiguration"])
        app.launch()
        let text = "123456"
        let field = app.textFields["cvv"]
        field.tap()
        field.typeText(text)
        XCTAssertEqual((field.value as? String)?.count, 4)
    }

    // MARK: Card brand images
    
    func testBrandImage_visa() {
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubCardConfiguration", "CardConfiguration"])
        app.launch()
        let brandName = "visa"
        let field = app.textFields["pan"]
        field.tap()
        field.typeText("4")
        XCTAssertEqual(app.images["cardBrandImage"].label, NSLocalizedString(brandName,
                                                                             bundle: Bundle(for: type(of: self)),
                                                                             comment: ""))
    }
    
    func testBrandImage_mastercard() {
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubCardConfiguration", "CardConfiguration"])
        app.launch()
        let brandName = "mastercard"
        let field = app.textFields["pan"]
        field.tap()
        field.typeText("5")
        XCTAssertEqual(app.images["cardBrandImage"].label, NSLocalizedString(brandName,
                                                                             bundle: Bundle(for: type(of: self)),
                                                                             comment: ""))
    }
    
    func testBrandImage_amex() {
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubCardConfiguration", "CardConfiguration"])
        app.launch()
        let brandName = "amex"
        let field = app.textFields["pan"]
        field.tap()
        field.typeText("34")
        XCTAssertEqual(app.images["cardBrandImage"].label, NSLocalizedString(brandName,
                                                                             bundle: Bundle(for: type(of: self)),
                                                                             comment: ""))
    }
    
    func testBrandImage_unknown() {
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubCardConfiguration", "CardConfiguration"])
        app.launch()
        
        let field = app.textFields["pan"]
        field.tap()
        field.typeText("0")
        XCTAssertEqual(app.images["cardBrandImage"].label, NSLocalizedString("unknown_card_brand",
                                                                             bundle: Bundle(for: type(of: self)),
                                                                             comment: ""))
    }
    
    // MARK: Dynamic CVV
    
    func testCVV_brandValidLength() {
        
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubCardConfiguration", "CardConfiguration"])
        app.launch()
        
        let pan = app.textFields["pan"]
        pan.tap()
        pan.typeText("4")

        let insertedCVV = "123456789"
        let cvv = app.textFields["cvv"]
        cvv.tap()
        cvv.typeText(insertedCVV)

        XCTAssertEqual(cvv.value as? String, String(insertedCVV.prefix(3)))
    }

    func testPAN_removeDigits() {
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubCardConfiguration", "CardConfiguration"])
        app.launch()
        
        let field = app.textFields["pan"]
        field.tap()
        field.typeText("1000")
        field.typeText(XCUIKeyboardKey.delete.rawValue)
        field.typeText(XCUIKeyboardKey.delete.rawValue)
        field.typeText(XCUIKeyboardKey.delete.rawValue)
        XCTAssertEqual(field.value as? String, "1")
    }
    
    func testExpiryMonth_removeDigits() {
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubCardConfiguration", "CardConfiguration"])
        app.launch()
        
        let field = app.textFields["expiryMonth"]
        field.tap()
        field.typeText("12")
        field.typeText(XCUIKeyboardKey.delete.rawValue)
        XCTAssertEqual(field.value as? String, "1")
    }
    
    func testExpiryYear_removeDigits() {
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubCardConfiguration", "CardConfiguration"])
        app.launch()
        
        let field = app.textFields["expiryYear"]
        field.tap()
        field.typeText("42")
        field.typeText(XCUIKeyboardKey.delete.rawValue)
        XCTAssertEqual(field.value as? String, "4")
    }

    func testCVV_removeDigits() {
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubCardConfiguration", "CardConfiguration"])
        app.launch()
        
        let field = app.textFields["cvv"]
        field.tap()
        field.typeText("1234")
        field.typeText(XCUIKeyboardKey.delete.rawValue)
        field.typeText(XCUIKeyboardKey.delete.rawValue)
        field.typeText(XCUIKeyboardKey.delete.rawValue)
        XCTAssertEqual(field.value as? String, "1")
    }
    
    // MARK: Field validity
    
    func testPANAccessibilityLabel_validComplete() {
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubCardConfiguration", "CardConfiguration"])
        app.launch()
        
        let field = app.textFields["pan"]
        field.tap()
        field.typeText("4111111111111111")
        XCTAssertEqual(field.label, "valid")
    }
    
    func testPANAccessibilityLabel_validPartial() {
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubCardConfiguration", "CardConfiguration"])
        app.launch()
        
        let field = app.textFields["pan"]
        field.tap()
        field.typeText("4111")
        XCTAssertEqual(field.label, "valid")
    }
    
    func testCVVAccessibilityLabel_validComplete() {
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubCardConfiguration", "CardConfiguration"])
        app.launch()
        
        let field = app.textFields["cvv"]
        field.tap()
        field.typeText("1234")
        XCTAssertEqual(field.label, "valid")
    }
    
    func testCVVAccessibilityLabel_validPartial() {
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubCardConfiguration", "CardConfiguration"])
        app.launch()
        
        let field = app.textFields["cvv"]
        field.tap()
        field.typeText("1")
        XCTAssertEqual(field.label, "valid")
    }
    
    func testCVVAccessibilityLabel_invalid() {
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-stubCardConfiguration", "CardConfiguration"])
        app.launch()
        
        let cvv = app.textFields["cvv"]
        cvv.tap()
        cvv.typeText("1234")
        let field = app.textFields["pan"]
        field.tap()
        field.typeText("4")
        XCTAssertEqual(cvv.label, "invalid")
    }
    
}
