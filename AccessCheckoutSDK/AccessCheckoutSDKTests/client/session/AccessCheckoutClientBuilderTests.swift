import XCTest

@testable import AccessCheckoutSDK

class AccessCheckoutClientBuilderTests: XCTestCase {
    func testBuildsAnAccessCheckoutClientUsingCheckoutId() throws {
        let builder = AccessCheckoutClientBuilder().checkoutId("123")
            .accessBaseUrl("https://access.worldpay.com")

        let result: AccessCheckoutClient = try builder.build()

        XCTAssertNotNil(result)
    }

    func testShouldValidateBaseUrl() throws {
        let builder = AccessCheckoutClientBuilder().checkoutId("123")
            .accessBaseUrl("some-url")

        XCTAssertThrowsError(try builder.build()) { error in
            guard case .notPermitted = error as? BaseUrlSanitiserError else {
                return XCTFail("Expected BaseUrlSanitiserError.notPermitted")
            }
            XCTAssertEqual(
                "base url 'some-url' is not permitted",
                error.localizedDescription
            )
        }
    }

    func testCannotBuildAnAccessCheckoutClientWithoutCallToCheckoutId() throws {
        let builder = AccessCheckoutClientBuilder().accessBaseUrl("some-url")
        let expectedMessage = "Expected checkout ID to be provided but was not"

        XCTAssertThrowsError(try builder.build()) { error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }

    func testCannotBuildAnAccessCheckoutClientWithoutAccessBaseUrl() throws {
        let builder = AccessCheckoutClientBuilder().checkoutId("123")
        let expectedMessage = "Expected base url to be provided but was not"

        XCTAssertThrowsError(try builder.build()) { error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }
}
