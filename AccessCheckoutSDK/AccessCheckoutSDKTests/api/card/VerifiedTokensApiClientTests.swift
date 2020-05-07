@testable import AccessCheckoutSDK
import XCTest
import Mockingjay
import PromiseKit

class VerifiedTokensApiClientTests: XCTestCase {
    private let baseUrl = "http://localhost"
    private let pan = "a-pan"
    private let expiryMonth:UInt = 12
    private let expiryYear:UInt = 24
    private let cvv = "123"
    
    private let mockDiscovery = VerifiedTokensApiDiscoveryMock()
    private let mockURLRequestFactory = VerifiedTokensSessionURLRequestFactoryMock()
    
    private let expectedSession = "a-session"
    private let expectedDiscoveredUrl = "http://and-end-point"
    
    private let urlRequestFactoryResult = URLRequest(url: URL(string: "a-url")!)
    private var expectationToFulfill:XCTestExpectation?
    
    override func setUp() {
        mockURLRequestFactory.willReturn(self.urlRequestFactoryResult)
        expectationToFulfill = expectation(description: "")
    }
    
    func testDiscoversApiAndCreatesSession() {
        mockDiscovery.willReturn(Promise.value(expectedDiscoveredUrl))
        let mockRestClient = RestClientMock(replyWith: successResponse(withSession: expectedSession))
        
        let client = VerifiedTokensApiClient(discovery: mockDiscovery, urlRequestFactory: mockURLRequestFactory, restClient: mockRestClient)
        
        firstly {
            client.createSession(baseUrl: baseUrl, merchantId: "", pan: pan, expiryMonth: expiryMonth, expiryYear: expiryYear, cvv: cvv)
        }.done() { session in
            XCTAssertEqual(self.expectedSession, session)
            XCTAssertEqual(self.urlRequestFactoryResult, mockRestClient.requestSent)
            XCTAssertEqual(self.pan, self.mockURLRequestFactory.panPassed)
            XCTAssertEqual(self.expiryMonth, self.mockURLRequestFactory.expiryMonthPassed)
            XCTAssertEqual(self.expiryYear, self.mockURLRequestFactory.expiryYearPassed)
            XCTAssertEqual(self.cvv, self.mockURLRequestFactory.cvvPassed)
            XCTAssertEqual(self.expectedDiscoveredUrl, self.mockURLRequestFactory.urlPassed)
        }.catch() { error in
            XCTFail("Creation of session shoul have succeeded")
        }.finally {
            self.expectationToFulfill!.fulfill()
        }
        
        wait(for: [expectationToFulfill!], timeout: 1)
    }
    
    func testReturnsDiscoveryErrorWhenApiDiscoveryFails() {
        let expectedError = AccessCheckoutClientError.unknown(message: "an-error")
        mockDiscovery.willReturn(Promise<String>(error: expectedError))
        let mockRestClient = RestClientMock(replyWith: successResponse(withSession: expectedSession))
        
        let client = VerifiedTokensApiClient(discovery: mockDiscovery, urlRequestFactory: mockURLRequestFactory, restClient: mockRestClient)
        
        firstly {
            client.createSession(baseUrl: baseUrl, merchantId: "", pan: pan, expiryMonth: expiryMonth, expiryYear: expiryYear, cvv: cvv)
        }.done() { session in
            XCTFail("Creation of session should have failed")
        }.catch() { error in
            XCTAssertEqual(expectedError, error as! AccessCheckoutClientError)
        }.finally {
            self.expectationToFulfill!.fulfill()
        }
        
        wait(for: [expectationToFulfill!], timeout: 1)
    }
    
    func testReturnsSessionNotFound_whenExpectedSessionIsNotInResponse() {
        mockDiscovery.willReturn(Promise.value(expectedDiscoveredUrl))
        let mockRestClient = RestClientMock(replyWith: responseWithoutExpectedLink())
        
        let client = VerifiedTokensApiClient(discovery: mockDiscovery, urlRequestFactory: mockURLRequestFactory, restClient: mockRestClient)
        
        firstly {
            client.createSession(baseUrl: baseUrl, merchantId: "", pan: pan, expiryMonth: expiryMonth, expiryYear: expiryYear, cvv: cvv)
        }.done() { session in
            XCTFail("Creation of session should have failed")
        }.catch() { error in
            XCTAssertEqual(AccessCheckoutClientError.sessionNotFound(message: "Failed to find link \(ApiLinks.sessions.result) in response"), error as! AccessCheckoutClientError)
        }.finally {
            self.expectationToFulfill!.fulfill()
        }
        
        wait(for: [expectationToFulfill!], timeout: 1)
    }
    
    func testReturnsServiceError_whenServiceErrorsOut() {
        mockDiscovery.willReturn(Promise.value(expectedDiscoveredUrl))
        let expectedError = AccessCheckoutClientError.unknown(message: "some-error")
        let mockRestClient = RestClientMock<String>(errorWith: expectedError)
        
        let client = VerifiedTokensApiClient(discovery: mockDiscovery, urlRequestFactory: mockURLRequestFactory, restClient: mockRestClient)
        
        firstly {
            client.createSession(baseUrl: baseUrl, merchantId: "", pan: pan, expiryMonth: expiryMonth, expiryYear: expiryYear, cvv: cvv)
        }.done() { session in
            XCTFail("Creation of session should have failed")
        }.catch() { error in
            XCTAssertEqual(expectedError, error as! AccessCheckoutClientError)
        }.finally {
            self.expectationToFulfill!.fulfill()
        }
        
        wait(for: [expectationToFulfill!], timeout: 1)
    }
    
    private func successResponse(withSession: String) -> ApiResponse {
        let responseAsString =
                """
                    {
                        "_links": {
                            "verifiedTokens:session": {
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

