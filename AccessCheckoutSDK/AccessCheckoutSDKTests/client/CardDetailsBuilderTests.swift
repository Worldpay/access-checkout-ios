@testable import AccessCheckoutSDK
import XCTest

class CardDetailsBuilderTests : XCTestCase {
    
    func testBuildsCardDetailsWithPanCvvAndExpiryDate() {
        let cardDetailsBuilder = CardDetails.builder().pan("1234123412341234")
            .expiryMonth("10")
            .expiryYear("23")
            .cvv("123")
        
        let cardDetails = cardDetailsBuilder.build()
        
        XCTAssertEqual("1234123412341234", cardDetails.pan)
        XCTAssertEqual("10", cardDetails.expiryMonth)
        XCTAssertEqual("23", cardDetails.expiryYear)
        XCTAssertEqual("123", cardDetails.cvv)
    }
    
    func testBuildsCardDetailsWithJustACvv() {
        let cardDetailsBuilder = CardDetails.builder().cvv("123")
        
        let cardDetails = cardDetailsBuilder.build()
        
        XCTAssertNil(cardDetails.pan)
        XCTAssertNil(cardDetails.expiryMonth)
        XCTAssertNil(cardDetails.expiryYear)
        XCTAssertEqual("123", cardDetails.cvv)
    }
}
