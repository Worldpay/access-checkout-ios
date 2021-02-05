@testable import AccessCheckoutSDK
import XCTest

class CvcOnlyValidationConfigBuilderTests: XCTestCase {
    private let builder = CvcOnlyValidationConfig.builder()
    private let cvcTextField = UITextField()
    private let validationDelegate = MockAccessCheckoutCvcOnlyValidationDelegate()

    func testCanCreateConfig() {
        let config = try! CvcOnlyValidationConfig.builder()
            .cvc(cvcTextField)
            .validationDelegate(validationDelegate)
            .build()

        XCTAssertEqual(cvcTextField, config.cvcTextField)
        XCTAssertTrue(config.validationDelegate is MockAccessCheckoutCvcOnlyValidationDelegate)
    }

    func testThrowsErrorWhenCvcIsNotSpecified() throws {
        _ = builder.validationDelegate(validationDelegate)
        let expectedMessage = "Expected cvc to be provided but was not"

        XCTAssertThrowsError(try builder.build()) { error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }

    func testThrowsErrorWhenValidationDelegateIsNotSpecified() throws {
        _ = builder.cvc(cvcTextField)
        let expectedMessage = "Expected validation delegate to be provided but was not"

        XCTAssertThrowsError(try builder.build()) { error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }
}
