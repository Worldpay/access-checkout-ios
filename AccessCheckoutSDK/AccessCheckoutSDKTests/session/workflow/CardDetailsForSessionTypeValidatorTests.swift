import XCTest

@testable import AccessCheckoutSDK

class CardDetailsForSessionTypeValidatorTests: XCTestCase {
    let validator = CardDetailsForSessionTypeValidator()

    func testThrowsExceptionForCardSessionTypeWhenPanIsNotProvided() throws {
        let expectedMessage = "Expected pan to be provided but was not"
        let sessionType = SessionType.card
        let cardDetails = try CardDetailsBuilder()
            .expiryDate(UIUtils.createAccessCheckoutUITextField(withText: "12/20"))
            .cvc(UIUtils.createAccessCheckoutUITextField(withText: "123"))
            .build()

        XCTAssertThrowsError(try validator.validate(cardDetails: cardDetails, for: sessionType)) {
            error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }

    func testThrowsExceptionForCardSessionTypeWhenExpiryDateIsNotProvided() throws {
        let expectedMessage = "Expected expiry date to be provided but was not"
        let sessionType = SessionType.card
        let cardDetails = try CardDetailsBuilder()
            .pan(UIUtils.createAccessCheckoutUITextField(withText: "pan"))
            .cvc(UIUtils.createAccessCheckoutUITextField(withText: "123"))
            .build()

        XCTAssertThrowsError(try validator.validate(cardDetails: cardDetails, for: sessionType)) {
            error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }

    func testFailsToRetrieveSessionIfCvcIsNotProvided() throws {
        let expectedMessage = "Expected cvc to be provided but was not"
        let sessionType = SessionType.card
        let cardDetails = try CardDetailsBuilder()
            .pan(UIUtils.createAccessCheckoutUITextField(withText: "pan"))
            .expiryDate(UIUtils.createAccessCheckoutUITextField(withText: "12/20"))
            .build()

        XCTAssertThrowsError(try validator.validate(cardDetails: cardDetails, for: sessionType)) {
            error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }

    func testThrowsExceptionForCvcSessionTypeWhenCvcIsNotProvided() throws {
        let expectedMessage = "Expected cvc to be provided but was not"
        let sessionType = SessionType.cvc
        let cardDetails = try CardDetailsBuilder().build()

        XCTAssertThrowsError(try validator.validate(cardDetails: cardDetails, for: sessionType)) {
            error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }
}
