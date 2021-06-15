@testable import AccessCheckoutSDK
import Foundation
import XCTest

class RestrictedCardFlowValidationTests: XCTestCase {
    private let backspace = String(XCUIKeyboardKey.delete.rawValue)
    
    let app = XCUIApplication()
    var view: RestrictedCardFlowViewPageObject?
    
    override func setUp() {
        continueAfterFailure = false
        
        app.launch()
        view = NavigationViewPageObject(app).navigateToRestrictedCardFlow()
    }
    
    // MARK: Testing always displays card brand images independently of brand being accepted
    
    func testDisplaysAcceptedBrand_visa() {
        view!.typeTextIntoPan("4")
        
        XCTAssertTrue(view!.imageIs("visa"))
    }
    
    func testDisplaysAcceptedBrand_mastercard() {
        view!.typeTextIntoPan("55")
        
        XCTAssertTrue(view!.imageIs("mastercard"))
    }
    
    func testDisplaysAcceptedBrand_amex() {
        view!.typeTextIntoPan("34")
        
        XCTAssertTrue(view!.imageIs("amex"))
    }
    
    func testDisplaysNonAcceptedBrand_jcb() {
        view!.typeTextIntoPan("352")
        
        XCTAssertTrue(view!.imageIs("jcb"))
    }
    
    func testDisplaysUnknownBrand() {
        view!.typeTextIntoPan("0")
        
        XCTAssertTrue(view!.imageIs("unknown_card_brand"))
    }
    
    // MARK: Testing accepted cards
    
    func testPartialPanIsInvalid_visa() {
        view!.typeTextIntoPan("4")
        
        XCTAssertTrue(view!.imageIs("visa"))
        XCTAssertEqual(view!.panIsValidLabel.label, "invalid")
    }
    
    func testCompletePanIsValid_visa() {
        view!.typeTextIntoPan("4444333322221111")
        
        XCTAssertTrue(view!.imageIs("visa"))
        XCTAssertEqual(view!.panIsValidLabel.label, "valid")
    }
    
    func testPartialPanIsInvalid_mastercard() {
        view!.typeTextIntoPan("55")
        
        XCTAssertTrue(view!.imageIs("mastercard"))
        XCTAssertEqual(view!.panIsValidLabel.label, "invalid")
    }
    
    func testCompletePanIsValid_mastercard() {
        view!.typeTextIntoPan("5555555555554444")
        
        XCTAssertTrue(view!.imageIs("mastercard"))
        XCTAssertEqual(view!.panIsValidLabel.label, "valid")
    }
    
    func testPartialPanIsInvalid_amex() {
        view!.typeTextIntoPan("34")
        
        XCTAssertTrue(view!.imageIs("amex"))
        XCTAssertEqual(view!.panIsValidLabel.label, "invalid")
    }
    
    func testCompletePanIsValid_amex() {
        view!.typeTextIntoPan("343434343434343")
        
        XCTAssertTrue(view!.imageIs("amex"))
        XCTAssertEqual(view!.panIsValidLabel.label, "valid")
    }
    
    // MARK: Testing non accepted card
    
    func testPartialPanIsInvalid_jccb() {
        view!.typeTextIntoPan("352")
        
        XCTAssertTrue(view!.imageIs("jcb"))
        XCTAssertEqual(view!.panIsValidLabel.label, "invalid")
    }
    
    func testCompletePanIsInValid_jcb() {
        view!.typeTextIntoPan("3528000700000000")
        
        XCTAssertTrue(view!.imageIs("jcb"))
        XCTAssertEqual(view!.panIsValidLabel.label, "invalid")
        
    }
    
    // MARK: Testing PAN formatting
    
    func testDoesNotFormatPan() {
        view!.typeTextIntoPan("4111111111111111")
        
        XCTAssertEqual(view!.panText, "4111 1111 1111 1111")
    }
}
