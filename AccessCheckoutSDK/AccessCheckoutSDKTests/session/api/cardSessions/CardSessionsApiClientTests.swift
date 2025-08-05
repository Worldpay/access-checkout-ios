import XCTest

@testable import AccessCheckoutSDK

class CardSessionsApiClientTests: XCTestCase {
    private let baseUrl = "http://localhost"
    private let pan = "a-pan"
    private let expiryMonth: UInt = 12
    private let expiryYear: UInt = 24
    private let cvc = "123"

    private let mockDiscovery = CardSessionsApiDiscoveryMock()
    private let mockURLRequestFactory = CardSessionURLRequestFactoryMock()

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

        let client = CardSessionsApiClient(
            discovery: mockDiscovery, urlRequestFactory: mockURLRequestFactory,
            restClient: mockRestClient)

        client.createSession(
            baseUrl: baseUrl, checkoutId: "", pan: pan, expiryMonth: expiryMonth,
            expiryYear: expiryYear, cvc: cvc
        ) { result in
            switch result {
            case .success(let session):
                XCTAssertEqual(self.expectedSession, session)
                XCTAssertEqual(self.urlRequestFactoryResult, mockRestClient.requestSent)
                XCTAssertEqual(self.pan, self.mockURLRequestFactory.panPassed)
                XCTAssertEqual(self.expiryMonth, self.mockURLRequestFactory.expiryMonthPassed)
                XCTAssertEqual(self.expiryYear, self.mockURLRequestFactory.expiryYearPassed)
                XCTAssertEqual(self.cvc, self.mockURLRequestFactory.cvcPassed)
                XCTAssertEqual(self.expectedDiscoveredUrl, self.mockURLRequestFactory.urlPassed)
            case .failure:
                XCTFail("Creation of session shoul have succeeded")
            }
            self.expectationToFulfill!.fulfill()
        }

        wait(for: [expectationToFulfill!], timeout: 1)
    }

    func testReturnsDiscoveryErrorWhenApiDiscoveryFails() {
        let expectedError = StubUtils.createError(errorName: "some error", message: "some message")
        mockDiscovery.willComplete(with: expectedError)
        let mockRestClient = RestClientMock(
            replyWith: successResponse(withSession: expectedSession))

        let client = CardSessionsApiClient(
            discovery: mockDiscovery, urlRequestFactory: mockURLRequestFactory,
            restClient: mockRestClient)

        client.createSession(
            baseUrl: baseUrl, checkoutId: "", pan: pan, expiryMonth: expiryMonth,
            expiryYear: expiryYear, cvc: cvc
        ) { result in
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
        let expectedError = StubUtils.createError(
            errorName: "sessionLinkNotFound",
            message: "Failed to find link \(ApiLinks.cvcSessions.result) in response")
        let mockRestClient = RestClientMock(replyWith: responseWithoutExpectedLink())
        mockDiscovery.willComplete(with: expectedDiscoveredUrl)

        let client = CardSessionsApiClient(
            discovery: mockDiscovery, urlRequestFactory: mockURLRequestFactory,
            restClient: mockRestClient)

        client.createSession(
            baseUrl: baseUrl, checkoutId: "", pan: pan, expiryMonth: expiryMonth,
            expiryYear: expiryYear, cvc: cvc
        ) { result in
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
        let expectedError = StubUtils.createError(errorName: "some error", message: "some message")
        let mockRestClient = RestClientMock<ApiResponse>(errorWith: expectedError)

        let client = CardSessionsApiClient(
            discovery: mockDiscovery, urlRequestFactory: mockURLRequestFactory,
            restClient: mockRestClient)

        client.createSession(
            baseUrl: baseUrl, checkoutId: "", pan: pan, expiryMonth: expiryMonth,
            expiryYear: expiryYear, cvc: cvc
        ) { result in
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
