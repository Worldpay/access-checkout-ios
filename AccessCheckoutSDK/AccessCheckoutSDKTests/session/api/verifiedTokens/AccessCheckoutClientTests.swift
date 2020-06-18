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
    
    private func stubError(accessCheckoutClientError: AccessCheckoutClientError) {
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
    
    func testCreateSession_bodyIsEmpty() {
        let expectedError = AccessCheckoutClientError.bodyIsEmpty(message: "")
        stubError(accessCheckoutClientError: expectedError)
    }
    
    func testCreateSession_bodyIsNotJson() {
        let expectedError = AccessCheckoutClientError.bodyIsNotJson(message: "")
        stubError(accessCheckoutClientError: expectedError)
    }
    
    func testCreateSession_bodyDoesNotMatchSchema() {
        let expectedError = AccessCheckoutClientError.bodyDoesNotMatchSchema(message: "",
                                                                             validationErrors: nil)
        stubError(accessCheckoutClientError: expectedError)
    }
    
    func testCreateSession_validationErrors() {
        let validationErrors: [AccessCheckoutClientValidationError] = [.unrecognizedField(message: "", jsonPath: ""),
                                                                       .fieldHasInvalidValue(message: "", jsonPath: ""),
                                                                       .fieldIsMissing(message: "", jsonPath: ""),
                                                                       .stringIsTooShort(message: "", jsonPath: ""),
                                                                       .stringIsTooLong(message: "", jsonPath: ""),
                                                                       .panFailedLuhnCheck(message: "", jsonPath: ""),
                                                                       .fieldMustBeInteger(message: "", jsonPath: ""),
                                                                       .integerIsTooSmall(message: "", jsonPath: ""),
                                                                       .integerIsTooLarge(message: "", jsonPath: ""),
                                                                       .fieldMustBeNumber(message: "", jsonPath: ""),
                                                                       .stringFailedRegexCheck(message: "", jsonPath: ""),
                                                                       .dateHasInvalidFormat(message: "", jsonPath: "")]
        let expectedError = AccessCheckoutClientError.bodyDoesNotMatchSchema(message: "",
                                                                             validationErrors: validationErrors)
        stubError(accessCheckoutClientError: expectedError)
    }
    
    func testCreateSession_resourceNotFound() {
        let expectedError = AccessCheckoutClientError.resourceNotFound(message: "")
        stubError(accessCheckoutClientError: expectedError)
    }
    
    func testCreateSession_endpointNotFound() {
        let expectedError = AccessCheckoutClientError.endpointNotFound(message: "")
        stubError(accessCheckoutClientError: expectedError)
    }
    
    func testCreateSession_methodNotAllowed() {
        let expectedError = AccessCheckoutClientError.methodNotAllowed(message: "")
        stubError(accessCheckoutClientError: expectedError)
    }
    
    func testCreateSession_unsupportedAcceptHeader() {
        let expectedError = AccessCheckoutClientError.unsupportedAcceptHeader(message: "")
        stubError(accessCheckoutClientError: expectedError)
    }
    
    func testCreateSession_unsupportedContentType() {
        let expectedError = AccessCheckoutClientError.unsupportedContentType(message: "")
        stubError(accessCheckoutClientError: expectedError)
    }
    
    func testCreateSession_sessionNotFound() {
        let expectedError = AccessCheckoutClientError.sessionNotFound(message: "")
        stubError(accessCheckoutClientError: expectedError)
    }
    
    func testCreateSession_tooManyTokensForNamespace() {
        let expectedError = AccessCheckoutClientError.tooManyTokensForNamespace(message: "")
        stubError(accessCheckoutClientError: expectedError)
    }
    
    func testCreateSession_unrecognizedCardBrand() {
        let expectedError = AccessCheckoutClientError.unrecognizedCardBrand(message: "")
        stubError(accessCheckoutClientError: expectedError)
    }
    
    func testCreateSession_tokenExpiryDateExceededMaximum() {
        let expectedError = AccessCheckoutClientError.tokenExpiryDateExceededMaximum(message: "")
        stubError(accessCheckoutClientError: expectedError)
    }
    
    func testCreateSession_unsupportedCardBrand() {
        let expectedError = AccessCheckoutClientError.unsupportedCardBrand(message: "")
        stubError(accessCheckoutClientError: expectedError)
    }
    
    func testCreateSession_fieldHasInvalidValue() {
        let expectedError = AccessCheckoutClientError.fieldHasInvalidValue(message: "", jsonPath: nil)
        stubError(accessCheckoutClientError: expectedError)
    }
    
    func testCreateSession_unsupportedVerificationCurrency() {
        let expectedError = AccessCheckoutClientError.unsupportedVerificationCurrency(message: "", jsonPath: "")
        stubError(accessCheckoutClientError: expectedError)
    }
    
    func testCreateSession_maximumUpdatesExceeded() {
        let expectedError = AccessCheckoutClientError.maximumUpdatesExceeded(message: "")
        stubError(accessCheckoutClientError: expectedError)
    }
    
    func testCreateSession_apiRateLimitExceeded() {
        let expectedError = AccessCheckoutClientError.apiRateLimitExceeded(message: "")
        stubError(accessCheckoutClientError: expectedError)
    }
    
    func testCreateSession_unauthorized() {
        let expectedError = AccessCheckoutClientError.unauthorized(message: "")
        stubError(accessCheckoutClientError: expectedError)
    }
    
    func testCreateSession_invalidCredentials() {
        let expectedError = AccessCheckoutClientError.invalidCredentials(message: "")
        stubError(accessCheckoutClientError: expectedError)
    }
    
    func testCreateSession_internalServerError() {
        let expectedError = AccessCheckoutClientError.internalServerError(message: "")
        stubError(accessCheckoutClientError: expectedError)
    }
    
    func testCreateSession_notTokenizable() {
        let expectedError = AccessCheckoutClientError.notTokenizable(message: "")
        stubError(accessCheckoutClientError: expectedError)
    }
    
    func testCreateSession_internalErrorTokenNotCreated() {
        let expectedError = AccessCheckoutClientError.internalErrorTokenNotCreated(message: "")
        stubError(accessCheckoutClientError: expectedError)
    }
    
    func testCreateSession_undiscoverable() {
        let expectedError = AccessCheckoutClientError.undiscoverable(message: "")
        stubError(accessCheckoutClientError: expectedError)
    }
    
    func testCreateSession_accessDenied() {
        let expectedError = AccessCheckoutClientError.accessDenied(message: "")
        stubError(accessCheckoutClientError: expectedError)
    }
    
    func testCreateSession_unknown() {
        let expectedError = AccessCheckoutClientError.unknown(message: "")
        stubError(accessCheckoutClientError: expectedError)
    }
    
    func testParser_canDecodeJsonResponse() {
        do {
            _ = try JSONDecoder().decode(ApiResponse.self, from: getSampleResponse())
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    fileprivate func getSampleResponseWith(href: String) -> Data {
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
    
    fileprivate func getSampleResponse() -> Data {
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
