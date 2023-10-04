@testable import AccessCheckoutSDK
import XCTest

class CardDetailsBuilderTests: XCTestCase {
    // MARK: tests covering SAQ-A compliant way of instiantiating card details

    func testBuildsCardDetailsUsingUITextFields() throws {
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
    
    func testBuildsCardDetailsUsingUITextFieldsWhenPanHasSpaces() throws {
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
    
    func testBuildsCardDetailsUsingUITextFieldsWhenExpiryDateHasNoSlash() throws {
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
    
    func testBuildsCardDetailsUsingUITextFieldsWhenPassingOnlyUITextFieldForCvc() throws {
        let cvcUITextField = UIUtils.createAccessCheckoutUITextField(withText: "123")
        let cardDetailsBuilder = CardDetailsBuilder().cvc(cvcUITextField)
        
        let cardDetails = try cardDetailsBuilder.build()
        
        XCTAssertNil(cardDetails.pan)
        XCTAssertNil(cardDetails.expiryMonth)
        XCTAssertNil(cardDetails.expiryYear)
        XCTAssertEqual("123", cardDetails.cvc)
    }
    
    func testThrowsErrorWhenUsingUITextFieldsWhenExpiryDateIsInIncorrectFormat() throws {
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
    
    // MARK: tests covering non SAQ-A compliant way of instiantiating card details

    func testBuildsCardDetailsUsingStringValues() throws {
        let cardDetailsBuilder = CardDetailsBuilder().pan("1234123412341234")
            .expiryDate("10/23")
            .cvc("123")
        
        let cardDetails = try cardDetailsBuilder.build()
        
        XCTAssertEqual("1234123412341234", cardDetails.pan)
        XCTAssertEqual(10, cardDetails.expiryMonth)
        XCTAssertEqual(2023, cardDetails.expiryYear)
        XCTAssertEqual("123", cardDetails.cvc)
    }
    
    func testBuildsCardDetailsUsingStringValuesWhenPanHasSpaces() throws {
        let cardDetailsBuilder = CardDetailsBuilder().pan("1234 1234 1234 1234")
            .expiryDate("1023")
            .cvc("123")
        
        let cardDetails = try cardDetailsBuilder.build()
        
        XCTAssertEqual("1234123412341234", cardDetails.pan)
        XCTAssertEqual(10, cardDetails.expiryMonth)
        XCTAssertEqual(2023, cardDetails.expiryYear)
        XCTAssertEqual("123", cardDetails.cvc)
    }
    
    func testBuildsCardDetailsUsingStringValuesWhenExpiryDateHasNoSlash() throws {
        let cardDetailsBuilder = CardDetailsBuilder().pan("1234123412341234")
            .expiryDate("1023")
            .cvc("123")
        
        let cardDetails = try cardDetailsBuilder.build()
        
        XCTAssertEqual("1234123412341234", cardDetails.pan)
        XCTAssertEqual(10, cardDetails.expiryMonth)
        XCTAssertEqual(2023, cardDetails.expiryYear)
        XCTAssertEqual("123", cardDetails.cvc)
    }
    
    func testBuildsCardDetailsUsingStringValuesWhenPassingOnlyStringValueForCvc() throws {
        let cardDetailsBuilder = CardDetailsBuilder().cvc("123")
        
        let cardDetails = try cardDetailsBuilder.build()
        
        XCTAssertNil(cardDetails.pan)
        XCTAssertNil(cardDetails.expiryMonth)
        XCTAssertNil(cardDetails.expiryYear)
        XCTAssertEqual("123", cardDetails.cvc)
    }
    
    func testThrowsErrorWhenUsingStringValuesWhenExpiryDateIsInIncorrectFormat() throws {
        let expectedMessage = "Expected expiry date in format MM/YY or MMYY but found 10/2023"
        let cardDetailsBuilder = CardDetailsBuilder().pan("1234123412341234")
            .expiryDate("10/2023")
            .cvc("123")
        
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
