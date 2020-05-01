@testable import AccessCheckoutSDK
import XCTest

class ApiClientFactoryTests: XCTestCase {
    func testCreatesVerifiedTokensApiClient() {
        let factory = ApiClientFactory()
        
        let result = factory.createVerifiedTokensApiClient(baseUrl: "http://localhost", merchantId: "123")
        
        XCTAssertNotNil(result)
    }
    
    func testCreatesSessionsApiClient() {
        let factory = ApiClientFactory()
        
        let result = factory.createSessionsApiClient(baseUrl: "http://localhost", merchantId: "123")
        
        XCTAssertNotNil(result)
    }
}
