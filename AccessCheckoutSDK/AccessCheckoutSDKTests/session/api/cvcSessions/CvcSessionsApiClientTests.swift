import XCTest

@testable import AccessCheckoutSDK

class CvcSessionsApiClientTests: XCTestCase {
    private let baseUrl = "http://localhost"
    private let cvc = "123"

    private let mockDiscovery = SessionsApiDiscoveryMock()
    private let mockURLRequestFactory = PaymentsCvcSessionURLRequestFactoryMock()

    private let expectedSession = "a-session"
    private let expectedDiscoveredUrl = "http://and-end-point"

    private let urlRequestFactoryResult = URLRequest(url: URL(string: "a-url")!)
    private var expectationToFulfill: XCTestExpectation?

    override func setUp() {
        mockURLRequestFactory.willReturn(urlRequestFactoryResult)
        expectationToFulfill = expectation(description: "")
    }

    func testDiscoversApiAndCreatesSession() {
        mockDiscovery.willComplete(with: expectedDiscoveredUrl)
        let mockRestClient = RestClientMock(
            replyWith: successResponse(withSession: expectedSession))

        let client = CvcSessionsApiClient(
            discovery: mockDiscovery, urlRequestFactory: mockURLRequestFactory,
            restClient: mockRestClient)

        client.createSession(baseUrl: baseUrl, checkoutId: "", cvc: cvc) { result in
            switch result {
            case .success(let session):
                XCTAssertEqual(self.expectedSession, session)
                XCTAssertEqual(self.urlRequestFactoryResult, mockRestClient.requestSent)
                XCTAssertEqual(self.cvc, self.mockURLRequestFactory.cvcPassed)
                XCTAssertEqual(
                    self.expectedDiscoveredUrl, self.mockURLRequestFactory.urlStringPassed)
            case .failure:
                XCTFail("Creation of session shoul have succeeded")
            }
            self.expectationToFulfill!.fulfill()
        }

        wait(for: [expectationToFulfill!], timeout: 1)
    }

    func testReturnsDiscoveryErrorWhenApiDiscoveryFails() {
        let expectedError = StubUtils.createError(errorName: "an error", message: "a message")
        mockDiscovery.willComplete(with: expectedError)
        let mockRestClient = RestClientMock(
            replyWith: successResponse(withSession: expectedSession))

        let client = CvcSessionsApiClient(
            discovery: mockDiscovery, urlRequestFactory: mockURLRequestFactory,
            restClient: mockRestClient)

        client.createSession(baseUrl: baseUrl, checkoutId: "", cvc: cvc) { result in
            switch result {
            case .success:
                XCTFail("Creation of session should have failed")
            case .failure(let error):
                XCTAssertEqual(expectedError, error)
            }
            self.expectationToFulfill!.fulfill()
        }

        wait(for: [expectationToFulfill!], timeout: 1)
    }

    func testReturnsSessionNotFound_whenExpectedSessionIsNotInResponse() {
        mockDiscovery.willComplete(with: expectedDiscoveredUrl)
        let mockRestClient = RestClientMock(replyWith: responseWithoutExpectedLink())
        let expectedError = StubUtils.createError(
            errorName: "sessionLinkNotFound",
            message: "Failed to find link \(ApiLinks.cvcSessions.result) in response")

        let client = CvcSessionsApiClient(
            discovery: mockDiscovery, urlRequestFactory: mockURLRequestFactory,
            restClient: mockRestClient)

        client.createSession(baseUrl: baseUrl, checkoutId: "", cvc: cvc) { result in
            switch result {
            case .success:
                XCTFail("Creation of session should have failed")
            case .failure(let error):
                XCTAssertEqual(expectedError, error)
            }
            self.expectationToFulfill!.fulfill()
        }

        wait(for: [expectationToFulfill!], timeout: 1)
    }

    func testReturnsServiceError_whenServiceErrorsOut() {
        mockDiscovery.willComplete(with: expectedDiscoveredUrl)
        let expectedError = StubUtils.createError(errorName: "an error", message: "a message")
        let mockRestClient = RestClientMock<String>(errorWith: expectedError)

        let client = CvcSessionsApiClient(
            discovery: mockDiscovery, urlRequestFactory: mockURLRequestFactory,
            restClient: mockRestClient)

        client.createSession(baseUrl: baseUrl, checkoutId: "", cvc: cvc) { result in
            switch result {
            case .success:
                XCTFail("Creation of session should have failed")
            case .failure(let error):
                XCTAssertEqual(expectedError, error)
            }
            self.expectationToFulfill!.fulfill()
        }

        wait(for: [expectationToFulfill!], timeout: 1)
    }

    private func successResponse(withSession: String) -> ApiResponse {
        let responseAsString =
            """
                {
                    "_links": {
                        "sessions:session": {
                            "href": "\(withSession)"
                        }
                    }
                }
            """

        let responseAsData = responseAsString.data(using: .utf8)!
        return try! JSONDecoder().decode(ApiResponse.self, from: responseAsData)
    }

    private func responseWithoutExpectedLink() -> ApiResponse {
        let responseAsString =
            """
                {
                    "_links": {
                        "otherservice:session": {
                            "href": "http://somewhere"
                        }
                    }
                }
            """

        let responseAsData = responseAsString.data(using: .utf8)!
        return try! JSONDecoder().decode(ApiResponse.self, from: responseAsData)
    }
}
