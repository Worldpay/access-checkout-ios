import XCTest
import Mockingjay
@testable import AccessCheckoutSDK

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
    
    class MockDiscovery: Discovery {
        var serviceEndpoint = URL(string: "https://access.worldpay.com/verifiedTokens")
        
        /// Starts discovery of services
        func discover(serviceLinks: ApiLinks, urlSession: URLSession, onComplete: (() -> Void)?) {
            onComplete?()
        }
    }
 
    private let urlSession = URLSession(configuration: URLSessionConfiguration.default)
    private let getSessionRequestStub = http(.post, uri: "https://access.worldpay.com/verifiedTokens")
    private let mockDiscovery = MockDiscovery()
    
    override func setUp() {
    }

    override func tearDown() {
        removeAllStubs()
    }
    
    func testCreateSession_success() {
        let expectedHref = "http://access.worldpay.com/verifiedTokens/sessions/encrypted-data"
        let data = getSampleResponseWith(href: expectedHref)
        stub(getSessionRequestStub, jsonData(data, status: 201, headers: nil))
        
        let client = VerifiedTokensApiClient(discovery: mockDiscovery, merchantIdentifier: "")
        
        let tokenExpectation = expectation(description: "token")
        client.createSession(pan: "1234",
                          expiryMonth: 1,
                          expiryYear: 0,
                          cvv: "123",
                          urlSession: urlSession) { result in
                            switch result {
                            case .success(let href):
                                XCTAssertEqual(href, expectedHref)
                            case .failure(let error):
                                XCTFail(error.localizedDescription)
                            }
                            tokenExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // Error tests
    
    private func stubError(accessCheckoutClientError: AccessCheckoutClientError, expectError: @escaping (AccessCheckoutClientError?) -> Void) {
        guard let data = try? JSONEncoder().encode(accessCheckoutClientError) else {
            XCTFail()
            return
        }
        stub(getSessionRequestStub, jsonData(data))
        
        let client = VerifiedTokensApiClient(discovery: mockDiscovery, merchantIdentifier: "")
        client.createSession(pan: "",
                             expiryMonth: 0,
                             expiryYear: 0,
                             cvv: "",
                             urlSession: urlSession) { result in
                                switch result {
                                case .success:
                                    expectError(nil)
                                case .failure(let error):
                                    expectError(error)
                                }
        }
    }
    
    func testCreateSession_bodyIsEmpty() {
        let errorExpectation = expectation(description: "error")
        let expectedError = AccessCheckoutClientError.bodyIsEmpty(message: "")
        stubError(accessCheckoutClientError: expectedError) { error in
            XCTAssertEqual(expectedError, error)
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateSession_bodyIsNotJson() {
        let errorExpectation = expectation(description: "error")
        let expectedError = AccessCheckoutClientError.bodyIsNotJson(message: "")
        stubError(accessCheckoutClientError: expectedError) { error in
            XCTAssertEqual(expectedError, error)
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateSession_bodyDoesNotMatchSchema() {
        let errorExpectation = expectation(description: "error")
        let expectedError = AccessCheckoutClientError.bodyDoesNotMatchSchema(message: "",
                                                                             validationErrors: nil)
        stubError(accessCheckoutClientError: expectedError) { error in
            XCTAssertEqual(expectedError, error)
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateSession_validationErrors() {
        let errorExpectation = expectation(description: "error")
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
        stubError(accessCheckoutClientError: expectedError) { error in
            XCTAssertEqual(expectedError, error)
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateSession_resourceNotFound() {
        let errorExpectation = expectation(description: "error")
        let expectedError = AccessCheckoutClientError.resourceNotFound(message: "")
        stubError(accessCheckoutClientError: expectedError) { error in
            XCTAssertEqual(expectedError, error)
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateSession_endpointNotFound() {
        let errorExpectation = expectation(description: "error")
        let expectedError = AccessCheckoutClientError.endpointNotFound(message: "")
        stubError(accessCheckoutClientError: expectedError) { error in
            XCTAssertEqual(expectedError, error)
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateSession_methodNotAllowed() {
        let errorExpectation = expectation(description: "error")
        let expectedError = AccessCheckoutClientError.methodNotAllowed(message: "")
        stubError(accessCheckoutClientError: expectedError) { error in
            XCTAssertEqual(expectedError, error)
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateSession_unsupportedAcceptHeader() {
        let errorExpectation = expectation(description: "error")
        let expectedError = AccessCheckoutClientError.unsupportedAcceptHeader(message: "")
        stubError(accessCheckoutClientError: expectedError) { error in
            XCTAssertEqual(expectedError, error)
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateSession_unsupportedContentType() {
        let errorExpectation = expectation(description: "error")
        let expectedError = AccessCheckoutClientError.unsupportedContentType(message: "")
        stubError(accessCheckoutClientError: expectedError) { error in
            XCTAssertEqual(expectedError, error)
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateSession_sessionNotFound() {
        let errorExpectation = expectation(description: "error")
        let expectedError = AccessCheckoutClientError.sessionNotFound(message: "")
        stubError(accessCheckoutClientError: expectedError) { error in
            XCTAssertEqual(expectedError, error)
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateSession_tooManyTokensForNamespace() {
        let errorExpectation = expectation(description: "error")
        let expectedError = AccessCheckoutClientError.tooManyTokensForNamespace(message: "")
        stubError(accessCheckoutClientError: expectedError) { error in
            XCTAssertEqual(expectedError, error)
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateSession_unrecognizedCardBrand() {
        let errorExpectation = expectation(description: "error")
        let expectedError = AccessCheckoutClientError.unrecognizedCardBrand(message: "")
        stubError(accessCheckoutClientError: expectedError) { error in
            XCTAssertEqual(expectedError, error)
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateSession_tokenExpiryDateExceededMaximum() {
        let errorExpectation = expectation(description: "error")
        let expectedError = AccessCheckoutClientError.tokenExpiryDateExceededMaximum(message: "")
        stubError(accessCheckoutClientError: expectedError) { error in
            XCTAssertEqual(expectedError, error)
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateSession_unsupportedCardBrand() {
        let errorExpectation = expectation(description: "error")
        let expectedError = AccessCheckoutClientError.unsupportedCardBrand(message: "")
        stubError(accessCheckoutClientError: expectedError) { error in
            XCTAssertEqual(expectedError, error)
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateSession_fieldHasInvalidValue() {
        let errorExpectation = expectation(description: "error")
        let expectedError = AccessCheckoutClientError.fieldHasInvalidValue(message: "", jsonPath: nil)
        stubError(accessCheckoutClientError: expectedError) { error in
            XCTAssertEqual(expectedError, error)
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateSession_unsupportedVerificationCurrency() {
        let errorExpectation = expectation(description: "error")
        let expectedError = AccessCheckoutClientError.unsupportedVerificationCurrency(message: "", jsonPath: "")
        stubError(accessCheckoutClientError: expectedError) { error in
            XCTAssertEqual(expectedError, error)
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateSession_maximumUpdatesExceeded() {
        let errorExpectation = expectation(description: "error")
        let expectedError = AccessCheckoutClientError.maximumUpdatesExceeded(message: "")
        stubError(accessCheckoutClientError: expectedError) { error in
            XCTAssertEqual(expectedError, error)
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateSession_apiRateLimitExceeded() {
        let errorExpectation = expectation(description: "error")
        let expectedError = AccessCheckoutClientError.apiRateLimitExceeded(message: "")
        stubError(accessCheckoutClientError: expectedError) { error in
            XCTAssertEqual(expectedError, error)
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateSession_unauthorized() {
        let errorExpectation = expectation(description: "error")
        let expectedError = AccessCheckoutClientError.unauthorized(message: "")
        stubError(accessCheckoutClientError: expectedError) { error in
            XCTAssertEqual(expectedError, error)
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateSession_invalidCredentials() {
        let errorExpectation = expectation(description: "error")
        let expectedError = AccessCheckoutClientError.invalidCredentials(message: "")
        stubError(accessCheckoutClientError: expectedError) { error in
            XCTAssertEqual(expectedError, error)
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateSession_internalServerError() {
        let errorExpectation = expectation(description: "error")
        let expectedError = AccessCheckoutClientError.internalServerError(message: "")
        stubError(accessCheckoutClientError: expectedError) { error in
            XCTAssertEqual(expectedError, error)
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateSession_notTokenizable() {
        let errorExpectation = expectation(description: "error")
        let expectedError = AccessCheckoutClientError.notTokenizable(message: "")
        stubError(accessCheckoutClientError: expectedError) { error in
            XCTAssertEqual(expectedError, error)
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateSession_internalErrorTokenNotCreated() {
        let errorExpectation = expectation(description: "error")
        let expectedError = AccessCheckoutClientError.internalErrorTokenNotCreated(message: "")
        stubError(accessCheckoutClientError: expectedError) { error in
            XCTAssertEqual(expectedError, error)
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateSession_undiscoverable() {
        let errorExpectation = expectation(description: "error")
        let expectedError = AccessCheckoutClientError.undiscoverable(message: "")
        stubError(accessCheckoutClientError: expectedError) { error in
            XCTAssertEqual(expectedError, error)
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateSession_accessDenied() {
        let errorExpectation = expectation(description: "error")
        let expectedError = AccessCheckoutClientError.accessDenied(message: "")
        stubError(accessCheckoutClientError: expectedError) { error in
            XCTAssertEqual(expectedError, error)
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateSession_unknown() {
        let errorExpectation = expectation(description: "error")
        let expectedError = AccessCheckoutClientError.unknown(message: "")
        stubError(accessCheckoutClientError: expectedError) { error in
            XCTAssertEqual(expectedError, error)
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
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
}
