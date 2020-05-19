@testable import AccessCheckoutSDK
import XCTest

class ApiResponseLinkLookupTests : XCTestCase {
    func testReturnsValueOfLink() {
        let apiResponseLinkLookup = ApiResponseLinkLookup()
        let jsonString = """
        {
            "_links": {
                "some:link": {
                    "href": "http://www.some-service.co.uk"
                },
                "a:link": {
                    "href": "http://www.a-service.co.uk"
                }
            }
        }
        """
        let apiResponse = toApiResponse(jsonString)
        
        let result = apiResponseLinkLookup.lookup(link: "a:link", in: apiResponse)
        
        XCTAssertEqual("http://www.a-service.co.uk", result)
    }
    
    func testReturnsNilIfLinkIsNotFound() {
        let apiResponseLinkLookup = ApiResponseLinkLookup()
        let jsonString = """
        {
            "_links": {
                "some:link": {
                    "href": "http://www.some-service.co.uk"
                }
            }
        }
        """
        let apiResponse = toApiResponse(jsonString)
        
        let result = apiResponseLinkLookup.lookup(link: "a:link", in: apiResponse)
        
        XCTAssertNil(result)
    }
    
    private func toApiResponse(_ jsonString: String) -> ApiResponse {
        let data = Data(jsonString.utf8)
        return try! JSONDecoder().decode(ApiResponse.self, from: data)
    }
}
