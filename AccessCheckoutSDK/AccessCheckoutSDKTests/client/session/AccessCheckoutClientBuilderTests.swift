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
        
        XCTAssertThrowsError(try builder.build()) { error in
            XCTAssertEqual(error as! AccessCheckoutIllegalArgumentError, AccessCheckoutIllegalArgumentError.missingMerchantId)
        }
    }
    
    func testCannotBuildAnAccessCheckoutClientWithoutAccessBaseUrl() throws {
        let builder = AccessCheckoutClientBuilder().merchantId("123")
        
        XCTAssertThrowsError(try builder.build()) { error in
            XCTAssertEqual(error as! AccessCheckoutIllegalArgumentError, AccessCheckoutIllegalArgumentError.missingAccessBaseUrl)
        }
    }
}
