import XCTest

@testable import AccessCheckoutSDK

class WpSdkHeaderTests: XCTestCase {
    let expectedErrorMessage =
        "Unsupported version format. This functionality only supports access-checkout-react-native semantic versions or default access-checkout-ios version."

    func testAllowsToOverrideVersionWithAccessCheckoutReactNativeVersion() throws {
        let newVersion = "access-checkout-react-native/10.3.15"

        try WpSdkHeader.overrideValue(with: newVersion)

        XCTAssertEqual(newVersion, WpSdkHeader.value)
    }

    func testThrowsErrorWhenSemanticVersionIsNotInXYZFormat() throws {
        let newVersion = "access-checkout-react-native/10.3"

        XCTAssertThrowsError(try WpSdkHeader.overrideValue(with: newVersion)) { error in
            XCTAssertEqual(expectedErrorMessage, (error as! WpSdkHeaderValueError).message)
        }
    }

    func testThrowsErrorWhenAccessCheckoutReactNativeDoesNotHaveCorrectCase() throws {
        let newVersion = "Access-Checkout-REACT-native/10.3.15"

        XCTAssertThrowsError(try WpSdkHeader.overrideValue(with: newVersion)) { error in
            XCTAssertEqual(expectedErrorMessage, (error as! WpSdkHeaderValueError).message)
        }
    }

    func testThrowsErrorWhenAttemptingToOverrideWithNonAccessCheckoutReactNativeVersion() throws {
        let newVersion = "something-else/10.3.15"

        XCTAssertThrowsError(try WpSdkHeader.overrideValue(with: newVersion)) { error in
            XCTAssertEqual(expectedErrorMessage, (error as! WpSdkHeaderValueError).message)
        }
    }

    func testAllowsToOverrideVersionWithDefaultAccessCheckoutIosVersion() throws {
        try WpSdkHeader.overrideValue(with: WpSdkHeader.defaultValue)

        XCTAssertEqual(WpSdkHeader.defaultValue, WpSdkHeader.value)
    }

    func testThrowsErrorWhenAttemptingToOverrideWithAccessCheckoutIosOfDifferentSemanticVersion()
        throws
    {
        let newVersion = "access-checkout-ios/1.2.3"

        XCTAssertThrowsError(try WpSdkHeader.overrideValue(with: newVersion)) { error in
            XCTAssertEqual(expectedErrorMessage, (error as! WpSdkHeaderValueError).message)
        }
    }

    override class func tearDown() {
        try! WpSdkHeader.overrideValue(with: WpSdkHeader.defaultValue)
    }
}
