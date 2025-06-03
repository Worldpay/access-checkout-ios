import XCTest

@testable import AccessCheckoutSDK

class AccessCheckoutClientBuilderTests: XCTestCase {
    func testBuildsAnAccessCheckoutClientUsingCheckoutId() throws {
        let builder = AccessCheckoutClientBuilder().checkoutId("123")
            .accessBaseUrl("some-url")

        let result: AccessCheckoutClient = try builder.build()

        XCTAssertNotNil(result)
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
