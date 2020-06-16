@testable import AccessCheckoutSDK
import XCTest

class CardDetailsBuilderTests: XCTestCase {
    func testBuildsCardDetailsWithPanCvvAndExpiryDateAndFormatsExpiryYearOn4Digits() throws {
        let cardDetailsBuilder = CardDetailsBuilder().pan("1234123412341234")
            .expiryDate("10/23")
            .cvv("123")
        
        let cardDetails = try cardDetailsBuilder.build()
        
        XCTAssertEqual("1234123412341234", cardDetails.pan)
        XCTAssertEqual(10, cardDetails.expiryMonth)
        XCTAssertEqual(2023, cardDetails.expiryYear)
        XCTAssertEqual("123", cardDetails.cvv)
    }
    
    func testBuildsCardDetailsWithPanCvvAndAlternativeFormatForExpiryDateAndFormatsExpiryYearOn4Digits() throws {
        let cardDetailsBuilder = CardDetailsBuilder().pan("1234123412341234")
            .expiryDate("1023")
            .cvv("123")
        
        let cardDetails = try cardDetailsBuilder.build()
        
        XCTAssertEqual("1234123412341234", cardDetails.pan)
        XCTAssertEqual(10, cardDetails.expiryMonth)
        XCTAssertEqual(2023, cardDetails.expiryYear)
        XCTAssertEqual("123", cardDetails.cvv)
    }
    
    func testThrowsErrorWhenExpiryDateIsInIncorrectFormat() throws {
        let expectedError = AccessCheckoutClientInitialisationError.invalidExpiryDateFormat(message: "Expiry date format is invalid. Formats supported are MM/YY or MMYY")
        let cardDetailsBuilder = CardDetailsBuilder().pan("1234123412341234")
            .expiryDate("102023")
            .cvv("123")
        
        XCTAssertThrowsError(try cardDetailsBuilder.build()) { error in
            XCTAssertEqual(expectedError, error as! AccessCheckoutClientInitialisationError)
        }
    }
    
    func testBuildsCardDetailsWithJustACvv() throws {
        let cardDetailsBuilder = CardDetailsBuilder().cvv("123")
        
        let cardDetails = try cardDetailsBuilder.build()
        
        XCTAssertNil(cardDetails.pan)
        XCTAssertNil(cardDetails.expiryMonth)
        XCTAssertNil(cardDetails.expiryYear)
        XCTAssertEqual("123", cardDetails.cvv)
    }
}
