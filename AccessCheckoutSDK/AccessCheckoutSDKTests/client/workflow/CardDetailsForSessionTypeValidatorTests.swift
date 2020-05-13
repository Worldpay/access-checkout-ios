@testable import AccessCheckoutSDK
import XCTest

class CardDetailsForSessionTypeValidatorTests: XCTestCase {
    let validator = CardDetailsForSessionTypeValidator()

    func testThrowsExceptionForVerifiedTokensSessionTypeWhenPanIsNotProvided() {
        let expectedError = AccessCheckoutClientInitialisationError.incompleteCardDetails_VTSession_PanIsMandatory
        let sessionType = SessionType.verifiedTokens
        let cardDetails = CardDetailsBuilder().expiryDate(month: "12", year: "20")
            .cvv("123")
            .build()

        XCTAssertThrowsError(try validator.validate(cardDetails: cardDetails, for: sessionType)) { error in
            XCTAssertEqual(expectedError, error as! AccessCheckoutClientInitialisationError)
        }
    }

    func testThrowsExceptionForVerifiedTokensSessionTypeWhenExpiryDateIsNotProvided() {
        let expectedError = AccessCheckoutClientInitialisationError.incompleteCardDetails_VTSession_ExpiryMonthIsMandatory
        let sessionType = SessionType.verifiedTokens
        let cardDetails = CardDetailsBuilder().pan("pan")
            .cvv("123")
            .build()

        XCTAssertThrowsError(try validator.validate(cardDetails: cardDetails, for: sessionType)) { error in
            XCTAssertEqual(expectedError, error as! AccessCheckoutClientInitialisationError)
        }
    }

    func testFailsToRetrieveSessionIfCvcIsNotProvided() {
        let expectedError = AccessCheckoutClientInitialisationError.incompleteCardDetails_VTSession_CvcIsMandatory
        let sessionType = SessionType.verifiedTokens
        let cardDetails = CardDetailsBuilder().pan("pan")
            .expiryDate(month: "12", year: "20")
            .build()

        XCTAssertThrowsError(try validator.validate(cardDetails: cardDetails, for: sessionType)) { error in
            XCTAssertEqual(expectedError, error as! AccessCheckoutClientInitialisationError)
        }
    }

    func testThrowsExceptionForCvcSessionTypeWhenCvcIsNotProvided() {
        let expectedError = AccessCheckoutClientInitialisationError.incompleteCardDetails_CvcSession_CvcIsMandatory
        let sessionType = SessionType.paymentsCvc
        let cardDetails = CardDetailsBuilder().build()

        XCTAssertThrowsError(try validator.validate(cardDetails: cardDetails, for: sessionType)) { error in
            XCTAssertEqual(expectedError, error as! AccessCheckoutClientInitialisationError)
        }
    }
}
