@testable import AccessCheckoutSDK
import XCTest

class CardDetailsBuilderTests: XCTestCase {
    func testBuildsCardDetailsWithPanCvcAndExpiryDateAndFormatsExpiryYearOn4Digits() throws {
        let cardDetailsBuilder = CardDetailsBuilder().pan("1234123412341234")
            .expiryDate("10/23")
            .cvc("123")
        
        let cardDetails = try cardDetailsBuilder.build()
        
        XCTAssertEqual("1234123412341234", cardDetails.pan)
        XCTAssertEqual(10, cardDetails.expiryMonth)
        XCTAssertEqual(2023, cardDetails.expiryYear)
        XCTAssertEqual("123", cardDetails.cvc)
    }
    
    func testBuildsCardDetailsWithPanCvcAndAlternativeFormatForExpiryDateAndFormatsExpiryYearOn4Digits() throws {
        let cardDetailsBuilder = CardDetailsBuilder().pan("1234123412341234")
            .expiryDate("1023")
            .cvc("123")
        
        let cardDetails = try cardDetailsBuilder.build()
        
        XCTAssertEqual("1234123412341234", cardDetails.pan)
        XCTAssertEqual(10, cardDetails.expiryMonth)
        XCTAssertEqual(2023, cardDetails.expiryYear)
        XCTAssertEqual("123", cardDetails.cvc)
    }
    
    func testThrowsErrorWhenExpiryDateIsInIncorrectFormat() throws {
        let expectedError = AccessCheckoutClientInitialisationError.invalidExpiryDateFormat(message: "Expiry date format is invalid. Formats supported are MM/YY or MMYY")
        let cardDetailsBuilder = CardDetailsBuilder().pan("1234123412341234")
            .expiryDate("102023")
            .cvc("123")
        
        XCTAssertThrowsError(try cardDetailsBuilder.build()) { error in
            XCTAssertEqual(expectedError, error as! AccessCheckoutClientInitialisationError)
        }
    }
    
    func testBuildsCardDetailsWithJustACvc() throws {
        let cardDetailsBuilder = CardDetailsBuilder().cvc("123")
        
        let cardDetails = try cardDetailsBuilder.build()
        
        XCTAssertNil(cardDetails.pan)
        XCTAssertNil(cardDetails.expiryMonth)
        XCTAssertNil(cardDetails.expiryYear)
        XCTAssertEqual("123", cardDetails.cvc)
    }
}
