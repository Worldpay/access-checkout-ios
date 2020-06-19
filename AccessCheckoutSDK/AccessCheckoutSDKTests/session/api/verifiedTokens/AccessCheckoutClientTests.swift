@testable import AccessCheckoutSDK
import Mockingjay
import XCTest

class AccessCheckoutClientTests: XCTestCase {
    class MockBundle: Bundle {
        static let appVersion = "3.2.9"
        override func object(forInfoDictionaryKey key: String) -> Any? {
            if key == "CFBundleShortVersionString" {
                return MockBundle.appVersion
            } else {
                return super.object(forInfoDictionaryKey: key)
            }
        }
    }
    
    override func tearDown() {
        removeAllStubs()
    }
    
    // Error tests
    
    private func stubError(accessCheckoutClientError: AccessCheckoutError) {
        let errorExpectation = expectation(description: "error")
        
        guard let data = try? JSONEncoder().encode(accessCheckoutClientError) else {
            XCTFail()
            return
        }
        stub(http(.get, uri: "http://localhost"), successfulDiscoveryResponse())
        stub(http(.get, uri: "http://localhost/verifiedTokens"), successfulDiscoveryResponse())
        stub(http(.post, uri: "http://localhost/verifiedTokens/session"), jsonData(data))
        
        let client = VerifiedTokensApiClient()
        client.createSession(baseUrl: "http://localhost",
                             merchantId: "123",
                             pan: "",
                             expiryMonth: 0,
                             expiryYear: 0,
                             cvc: "") { result in
            switch result {
            case .success:
                XCTFail("Should have received an error but received a sucessful response")
            case .failure(let error):
                XCTAssertEqual(accessCheckoutClientError, error)
            }
            errorExpectation.fulfill()
        }
        
        wait(for: [errorExpectation], timeout: 1)
    }
    
    func testSuccessfullyReturnsASimpleApiErrorToTheMerchant() {
        let expectedError = StubUtils.createApiError(errorName: "an error", message: "an error message")
        stubError(accessCheckoutClientError: expectedError)
    }
    
    func testSuccessfullyReturnsAMoreComplexApiErrorToTheMerchant() {
        let validationError1 = StubUtils.createApiValidationError(errorName: "validation error 1", message: "error message 1", jsonPath: "field 1")
        let validationError2 = StubUtils.createApiValidationError(errorName: "validation error 2", message: "error message 2", jsonPath: "field 2")
        let expectedError = StubUtils.createApiError(errorName: "an error", message: "an error message", validationErrors: [validationError1, validationError2])
        
        stubError(accessCheckoutClientError: expectedError)
    }
    
    func testParser_canDecodeJsonResponse() {
        do {
            _ = try JSONDecoder().decode(ApiResponse.self, from: getSampleResponse())
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    private func getSampleResponseWith(href: String) -> Data {
        let responseAsString =
            """
                {
                    "_links": {
                        "verifiedTokens:session": {
                            "href": "\(href)"
                        },
                        "curies": [
                            {
                                "href": "https://access.worldpay.com/rels/verifiedTokens/{rel}.json",
                                "name": "verifiedTokens",
                                "templated": true
                            }
                        ]
                    }
                }
            """
        
        return responseAsString.data(using: .utf8)!
    }
    
    private func getSampleResponse() -> Data {
        return getSampleResponseWith(href: "https://access.worldpay.com/verifiedTokens/sessions/session123456789")
    }
    
    private func successfulDiscoveryResponse() -> (URLRequest) -> Response {
        return jsonData(toData("""
        {
            "_links": {
                "service:verifiedTokens": {
                    "href": "http://localhost/verifiedTokens"
                },
                "verifiedTokens:sessions": {
                    "href": "http://localhost/verifiedTokens/session"
                }
            }
        }
        """), status: 200)
    }
    
    private func toData(_ stringData: String) -> Data {
        return stringData.data(using: .utf8)!
    }
}
