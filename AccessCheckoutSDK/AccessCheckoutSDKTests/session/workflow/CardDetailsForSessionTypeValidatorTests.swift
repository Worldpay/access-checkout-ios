@testable import AccessCheckoutSDK
import XCTest

class CardDetailsForSessionTypeValidatorTests: XCTestCase {
    let validator = CardDetailsForSessionTypeValidator()

    func testThrowsExceptionForVerifiedTokensSessionTypeWhenPanIsNotProvided() throws {
        let expectedMessage = "Expected pan to be provided but was not"
        let sessionType = SessionType.card
        let cardDetails = try CardDetailsBuilder().expiryDate("12/20")
            .cvc("123")
            .build()

        XCTAssertThrowsError(try validator.validate(cardDetails: cardDetails, for: sessionType)) { error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }

    func testThrowsExceptionForVerifiedTokensSessionTypeWhenExpiryDateIsNotProvided() throws {
        let expectedMessage = "Expected expiry date to be provided but was not"
        let sessionType = SessionType.card
        let cardDetails = try CardDetailsBuilder().pan("pan")
            .cvc("123")
            .build()

        XCTAssertThrowsError(try validator.validate(cardDetails: cardDetails, for: sessionType)) { error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }

    func testFailsToRetrieveSessionIfCvcIsNotProvided() throws {
        let expectedMessage = "Expected cvc to be provided but was not"
        let sessionType = SessionType.card
        let cardDetails = try CardDetailsBuilder().pan("pan")
            .expiryDate("12/20")
            .build()

        XCTAssertThrowsError(try validator.validate(cardDetails: cardDetails, for: sessionType)) { error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }

    func testThrowsExceptionForCvcSessionTypeWhenCvcIsNotProvided() throws {
        let expectedMessage = "Expected cvc to be provided but was not"
        let sessionType = SessionType.cvc
        let cardDetails = try CardDetailsBuilder().build()

        XCTAssertThrowsError(try validator.validate(cardDetails: cardDetails, for: sessionType)) { error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }
}
