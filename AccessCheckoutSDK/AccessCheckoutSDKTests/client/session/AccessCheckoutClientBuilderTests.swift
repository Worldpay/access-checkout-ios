@testable import AccessCheckoutSDK
import XCTest

class AccessCheckoutClientBuilderTests: XCTestCase {
    func testBuildsAnAccessCheckoutClient() throws {
        let builder = AccessCheckoutClientBuilder().merchantId("123")
            .accessBaseUrl("some-url")
        
        let result: AccessCheckoutClient = try builder.build()
        
        XCTAssertNotNil(result)
    }
    
    func testCannotBuildAnAccessCheckoutClientWithoutMerchantId() throws {
        let builder = AccessCheckoutClientBuilder().accessBaseUrl("some-url")
        let expectedError = AccessCheckoutIllegalArgumentError(message: "Expected merchant ID to be provided but was not")
        
        XCTAssertThrowsError(try builder.build()) { error in
            XCTAssertEqual(error as! AccessCheckoutIllegalArgumentError, expectedError)
        }
    }
    
    func testCannotBuildAnAccessCheckoutClientWithoutAccessBaseUrl() throws {
        let builder = AccessCheckoutClientBuilder().merchantId("123")
        let expectedError = AccessCheckoutIllegalArgumentError(message: "Expected base url to be provided but was not")
        
        XCTAssertThrowsError(try builder.build()) { error in
            XCTAssertEqual(error as! AccessCheckoutIllegalArgumentError, expectedError)
        }
    }
}
