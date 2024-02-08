@testable import AccessCheckoutSDK
import XCTest

class CardDetailsBuilderTests: XCTestCase {
    // MARK: tests covering SAQ-A compliant way of instiantiating card details

    func testBuildsCardDetailsSuccessfully() throws {
        let panUITextField = UIUtils.createAccessCheckoutUITextField(withText: "1234123412341234")
        let expiryDateUITextField = UIUtils.createAccessCheckoutUITextField(withText: "10/23")
        let cvcUITextField = UIUtils.createAccessCheckoutUITextField(withText: "123")
        
        let cardDetailsBuilder = CardDetailsBuilder().pan(panUITextField)
            .expiryDate(expiryDateUITextField)
            .cvc(cvcUITextField)
        
        let cardDetails = try cardDetailsBuilder.build()
        
        XCTAssertEqual("1234123412341234", cardDetails.pan)
        XCTAssertEqual(10, cardDetails.expiryMonth)
        XCTAssertEqual(2023, cardDetails.expiryYear)
        XCTAssertEqual("123", cardDetails.cvc)
    }
    
    func testBuildsCardDetailsAndRemoveSpacesWhenPanHasSpaces() throws {
        let panUITextField = UIUtils.createAccessCheckoutUITextField(withText: "1234 1234 1234 1234")
        let expiryDateUITextField = UIUtils.createAccessCheckoutUITextField(withText: "10/23")
        let cvcUITextField = UIUtils.createAccessCheckoutUITextField(withText: "123")
    
        let cardDetailsBuilder = CardDetailsBuilder().pan(panUITextField)
            .expiryDate(expiryDateUITextField)
            .cvc(cvcUITextField)
        
        let cardDetails = try cardDetailsBuilder.build()
        
        XCTAssertEqual("1234123412341234", cardDetails.pan)
        XCTAssertEqual(10, cardDetails.expiryMonth)
        XCTAssertEqual(2023, cardDetails.expiryYear)
        XCTAssertEqual("123", cardDetails.cvc)
    }
    
    func testBuildsCardDetailsWithCorrectExpiryDateWhenExpiryDateHasNoSlash() throws {
        let panUITextField = UIUtils.createAccessCheckoutUITextField(withText: "1234123412341234")
        let expiryDateUITextField = UIUtils.createAccessCheckoutUITextField(withText: "1023")
        let cvcUITextField = UIUtils.createAccessCheckoutUITextField(withText: "123")
        
        let cardDetailsBuilder = CardDetailsBuilder().pan(panUITextField)
            .expiryDate(expiryDateUITextField)
            .cvc(cvcUITextField)
        
        let cardDetails = try cardDetailsBuilder.build()
        
        XCTAssertEqual("1234123412341234", cardDetails.pan)
        XCTAssertEqual(10, cardDetails.expiryMonth)
        XCTAssertEqual(2023, cardDetails.expiryYear)
        XCTAssertEqual("123", cardDetails.cvc)
    }
    
    func testBuildsCardDetailsWhenPassingOnlyCvc() throws {
        let cvcUITextField = UIUtils.createAccessCheckoutUITextField(withText: "123")
        let cardDetailsBuilder = CardDetailsBuilder().cvc(cvcUITextField)
        
        let cardDetails = try cardDetailsBuilder.build()
        
        XCTAssertNil(cardDetails.pan)
        XCTAssertNil(cardDetails.expiryMonth)
        XCTAssertNil(cardDetails.expiryYear)
        XCTAssertEqual("123", cardDetails.cvc)
    }
    
    func testThrowsErrorWhenExpiryDateIsInIncorrectFormat() throws {
        let panUITextField = UIUtils.createAccessCheckoutUITextField(withText: "1234123412341234")
        let expiryDateUITextField = UIUtils.createAccessCheckoutUITextField(withText: "10/2023")
        let cvcUITextField = UIUtils.createAccessCheckoutUITextField(withText: "123")
        
        let expectedMessage = "Expected expiry date in format MM/YY or MMYY but found 10/2023"
        let cardDetailsBuilder = CardDetailsBuilder().pan(panUITextField)
            .expiryDate(expiryDateUITextField)
            .cvc(cvcUITextField)
        
        XCTAssertThrowsError(try cardDetailsBuilder.build()) { error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }
    
    // MARK: tests covering attempt to build an empty instance of card details

    func testCanBuildEmptyCardDetails() throws {
        let cardDetails = try CardDetailsBuilder().build()
        
        XCTAssertNil(cardDetails.pan)
        XCTAssertNil(cardDetails.expiryMonth)
        XCTAssertNil(cardDetails.expiryYear)
        XCTAssertNil(cardDetails.cvc)
    }
}
