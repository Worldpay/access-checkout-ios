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
        let expectedMessage = "Expected merchant ID to be provided but was not"
        
        XCTAssertThrowsError(try builder.build()) { error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }
    
    func testCannotBuildAnAccessCheckoutClientWithoutAccessBaseUrl() throws {
        let builder = AccessCheckoutClientBuilder().merchantId("123")
        let expectedMessage = "Expected base url to be provided but was not"
        
        XCTAssertThrowsError(try builder.build()) { error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }
}
