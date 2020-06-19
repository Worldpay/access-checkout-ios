@testable import AccessCheckoutSDK
import XCTest

class CardDetailsForSessionTypeValidatorTests: XCTestCase {
    let validator = CardDetailsForSessionTypeValidator()

    func testThrowsExceptionForVerifiedTokensSessionTypeWhenPanIsNotProvided() throws {
        let expectedError = AccessCheckoutIllegalArgumentError.incompleteCardDetails_VTSession_PanIsMandatory
        let sessionType = SessionType.verifiedTokens
        let cardDetails = try CardDetailsBuilder().expiryDate("12/20")
            .cvc("123")
            .build()

        XCTAssertThrowsError(try validator.validate(cardDetails: cardDetails, for: sessionType)) { error in
            XCTAssertEqual(expectedError, error as! AccessCheckoutIllegalArgumentError)
        }
    }

    func testThrowsExceptionForVerifiedTokensSessionTypeWhenExpiryDateIsNotProvided() throws {
        let expectedError = AccessCheckoutIllegalArgumentError.incompleteCardDetails_VTSession_ExpiryDateIsMandatory
        let sessionType = SessionType.verifiedTokens
        let cardDetails = try CardDetailsBuilder().pan("pan")
            .cvc("123")
            .build()

        XCTAssertThrowsError(try validator.validate(cardDetails: cardDetails, for: sessionType)) { error in
            XCTAssertEqual(expectedError, error as! AccessCheckoutIllegalArgumentError)
        }
    }

    func testFailsToRetrieveSessionIfCvcIsNotProvided() throws {
        let expectedError = AccessCheckoutIllegalArgumentError.incompleteCardDetails_VTSession_CvcIsMandatory
        let sessionType = SessionType.verifiedTokens
        let cardDetails = try CardDetailsBuilder().pan("pan")
            .expiryDate("12/20")
            .build()

        XCTAssertThrowsError(try validator.validate(cardDetails: cardDetails, for: sessionType)) { error in
            XCTAssertEqual(expectedError, error as! AccessCheckoutIllegalArgumentError)
        }
    }

    func testThrowsExceptionForCvcSessionTypeWhenCvcIsNotProvided() throws {
        let expectedError = AccessCheckoutIllegalArgumentError.incompleteCardDetails_CvcSession_CvcIsMandatory
        let sessionType = SessionType.paymentsCvc
        let cardDetails = try CardDetailsBuilder().build()

        XCTAssertThrowsError(try validator.validate(cardDetails: cardDetails, for: sessionType)) { error in
            XCTAssertEqual(expectedError, error as! AccessCheckoutIllegalArgumentError)
        }
    }
}