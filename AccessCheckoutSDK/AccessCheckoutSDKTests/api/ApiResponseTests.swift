@testable import AccessCheckoutSDK
import XCTest

class ApiResponseTests: XCTestCase {
    func testSuccessfullyDecodesAnApiResponse() throws {
        let expectedLink1Name = "link 1 name"
        let expectedLink1Href = "link 1 value"
        
        let expectedLink2Name = "link 2 name"
        let expectedLink2Href = "link 2 value"
        
        let expectedCurie1Href = "https://access.worldpay.com/rels/verifiedTokens/{rel}.json"
        let expectedCurie1Name = "verifiedTokens"
        let expectedCurie1Templated = true
        
        let responseAsJsonString = """
        {
            "_links": {
                "\(expectedLink1Name)": {
                    "href": "\(expectedLink1Href)"
                },
                "\(expectedLink2Name)": {
                    "href": "\(expectedLink2Href)"
                },
                "curies": [
                    {
                        "href": "\(expectedCurie1Href)",
                        "name": "\(expectedCurie1Name)",
                        "templated": \(expectedCurie1Templated)
                    }
                ]
            }
        }
        """
        
        let response = try decode(responseAsJsonString, into: ApiResponse.self)
        
        XCTAssertEqual(2, response.links.endpoints.count)
        XCTAssertEqual(expectedLink1Href, response.links.endpoints[expectedLink1Name]?.href)
        XCTAssertEqual(expectedLink2Href, response.links.endpoints[expectedLink2Name]?.href)
        
        XCTAssertEqual(1, response.links.curies?.count)
        XCTAssertEqual(expectedCurie1Href, response.links.curies?.first?.href)
        XCTAssertEqual(expectedCurie1Name, response.links.curies?.first?.name)
        XCTAssertEqual(expectedCurie1Templated, response.links.curies?.first?.templated)
    }
    
    private func decode<T: Decodable>(_ json: String, into: T.Type) throws -> T {
        let data = json.data(using: .utf8)!
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
