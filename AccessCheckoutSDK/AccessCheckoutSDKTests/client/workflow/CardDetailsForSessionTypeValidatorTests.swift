@testable import AccessCheckoutSDK
import XCTest

class CardDetailsForSessionTypeValidatorTests: XCTestCase {
    let validator = CardDetailsForSessionTypeValidator()

    func testThrowsExceptionForVerifiedTokensSessionTypeWhenPanIsNotProvided() {
        let expectedError = AccessCheckoutClientInitialisationError.incompleteCardDetails_VTSession_PanIsMandatory
        let sessionType = SessionType.verifiedTokens
        let cardDetails = CardDetails.builder().expiryMonth("12")
            .expiryYear("20")
            .cvv("123")
            .build()

        XCTAssertThrowsError(try validator.validate(cardDetails: cardDetails, for: sessionType)) { error in
            XCTAssertEqual(expectedError, error as! AccessCheckoutClientInitialisationError)
        }
    }

    func testThrowsExceptionForVerifiedTokensSessionTypeWhenExpiryMonthIsNotProvided() {
        let expectedError = AccessCheckoutClientInitialisationError.incompleteCardDetails_VTSession_ExpiryMonthIsMandatory
        let sessionType = SessionType.verifiedTokens
        let cardDetails = CardDetails.builder().pan("pan")
            .expiryYear("20")
            .cvv("123")
            .build()

        XCTAssertThrowsError(try validator.validate(cardDetails: cardDetails, for: sessionType)) { error in
            XCTAssertEqual(expectedError, error as! AccessCheckoutClientInitialisationError)
        }
    }

    func testThrowsExceptionForVerifiedTokensSessionTypeWhenExpiryYearIsNotProvided() {
        let expectedError = AccessCheckoutClientInitialisationError.incompleteCardDetails_VTSession_ExpiryYearIsMandatory
        let sessionType = SessionType.verifiedTokens
        let cardDetails = CardDetails.builder().pan("pan")
            .expiryMonth("12")
            .cvv("123")
            .build()

        XCTAssertThrowsError(try validator.validate(cardDetails: cardDetails, for: sessionType)) { error in
            XCTAssertEqual(expectedError, error as! AccessCheckoutClientInitialisationError)
        }
    }

    func testFailsToRetrieveSessionIfCvcIsNotProvided() {
        let expectedError = AccessCheckoutClientInitialisationError.incompleteCardDetails_VTSession_CvcIsMandatory
        let sessionType = SessionType.verifiedTokens
        let cardDetails = CardDetails.builder().pan("pan")
            .expiryMonth("12")
            .expiryYear("20")
            .build()

        XCTAssertThrowsError(try validator.validate(cardDetails: cardDetails, for: sessionType)) { error in
            XCTAssertEqual(expectedError, error as! AccessCheckoutClientInitialisationError)
        }
    }

    func testThrowsExceptionForCvcSessionTypeWhenCvcIsNotProvided() {
        let expectedError = AccessCheckoutClientInitialisationError.incompleteCardDetails_CvcSession_CvcIsMandatory
        let sessionType = SessionType.paymentsCvc
        let cardDetails = CardDetails.builder().build()

        XCTAssertThrowsError(try validator.validate(cardDetails: cardDetails, for: sessionType)) { error in
            XCTAssertEqual(expectedError, error as! AccessCheckoutClientInitialisationError)
        }
    }
}
