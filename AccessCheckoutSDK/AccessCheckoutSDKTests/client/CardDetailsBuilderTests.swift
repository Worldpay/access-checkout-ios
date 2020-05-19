@testable import AccessCheckoutSDK
import XCTest

class CardDetailsBuilderTests: XCTestCase {
    func testBuildsCardDetailsWithPanCvvAndExpiryDate() {
        let cardDetailsBuilder = CardDetailsBuilder().pan("1234123412341234")
            .expiryDate(month: "10", year: "23")
            .cvv("123")
        
        let cardDetails = cardDetailsBuilder.build()
        
        XCTAssertEqual("1234123412341234", cardDetails.pan)
        XCTAssertEqual(10, cardDetails.expiryMonth)
        XCTAssertEqual(23, cardDetails.expiryYear)
        XCTAssertEqual("123", cardDetails.cvv)
    }
    
    func testBuildsCardDetailsWithJustACvv() {
        let cardDetailsBuilder = CardDetailsBuilder().cvv("123")
        
        let cardDetails = cardDetailsBuilder.build()
        
        XCTAssertNil(cardDetails.pan)
        XCTAssertNil(cardDetails.expiryMonth)
        XCTAssertNil(cardDetails.expiryYear)
        XCTAssertEqual("123", cardDetails.cvv)
    }
}
