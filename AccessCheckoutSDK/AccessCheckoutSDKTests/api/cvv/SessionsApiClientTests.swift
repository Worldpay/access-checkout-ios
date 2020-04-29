import XCTest
import Mockingjay
@testable import AccessCheckoutSDK

class SessionsApiClientTests: XCTestCase {

    private let urlSession = URLSession(configuration: URLSessionConfiguration.default)
    private let mockDiscovery = DiscoveryMock()
    private let mockURLRequestFactory = SessionsSessionURLRequestFactoryMock()
    private let expectedSession = "http://access.worldpay.com/sessions/sessions/encrypted-data"
    private let validCvv = "123"
    
    func testCreatesASession_andReceivesExpectedSession() {
        let response = try? successResponse(withSession: expectedSession)
        let mockRestClient = RestClientMock(replyWith: response)
        let client = SessionsApiClient(discovery: mockDiscovery, merchantIdentifier: "", urlRequestFactory: mockURLRequestFactory,
                                                 restClient: mockRestClient)
        let testExpectation = expectation(description: "")
        
        client.createSession(cvv: validCvv, urlSession: urlSession) { result in
            switch result {
                case .success(let session):
                    XCTAssertEqual(session, self.expectedSession)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
            }
            testExpectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testCallDiscovery_whenSessionCreated_andEndPointNotKnown() {
        let testExpectation = expectation(description: "")
        let response = try? successResponse(withSession: expectedSession)
        let mockRestClient = RestClientMock(replyWith: response)
        let client = SessionsApiClient(discovery: mockDiscovery, merchantIdentifier: "", urlRequestFactory: mockURLRequestFactory, restClient: mockRestClient)
        
        client.createSession(cvv: validCvv, urlSession: urlSession) { result in
            switch result {
                case .success(_):
                    XCTAssertTrue(self.mockDiscovery.discoverCalled)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
            }
            testExpectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testDoesNotCallDiscovery_whenSessionCreated_andEndPointKnown() {
        let testExpectation = expectation(description: "")
        let response = try? successResponse(withSession: expectedSession)
        let mockRestClient = RestClientMock(replyWith: response)
        let client = SessionsApiClient(discovery: mockDiscovery, merchantIdentifier: "", urlRequestFactory: mockURLRequestFactory, restClient: mockRestClient)
        mockDiscovery.serviceEndpoint = URL(string: "url")
        
        client.createSession(cvv: validCvv, urlSession: urlSession) { result in
            switch result {
                case .success(_):
                    XCTAssertFalse(self.mockDiscovery.discoverCalled)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
            }
            testExpectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testCreatesCVVSessionURLRequest_whenSessionCreated_andEndPointDiscovered() {
        let testExpectation = expectation(description: "")
        let response = try? successResponse(withSession: expectedSession)
        let mockRestClient = RestClientMock(replyWith: response)
        let client = SessionsApiClient(discovery: mockDiscovery, merchantIdentifier: "", urlRequestFactory: mockURLRequestFactory, restClient: mockRestClient)

        client.createSession(cvv: validCvv, urlSession: urlSession) { result in
            switch result {
                case .success(_):
                    XCTAssertTrue(self.mockURLRequestFactory.createCalled)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
            }
            testExpectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testCreatesCVVSessionURLRequest_whenSessionCreated_usingCVVAndDiscoveredUrl() {
        let testExpectation = expectation(description: "")
        let response = try? successResponse(withSession: expectedSession)
        let mockRestClient = RestClientMock(replyWith: response)
        let client = SessionsApiClient(discovery: mockDiscovery, merchantIdentifier: "", urlRequestFactory: mockURLRequestFactory, restClient: mockRestClient)
        mockDiscovery.serviceEndpoint = URL(string: "some-url-discovered")
        
        client.createSession(cvv: validCvv, urlSession: urlSession) { result in
            switch result {
                case .success(_):
                    XCTAssertEqual(self.mockURLRequestFactory.cvvPassed, self.validCvv)
                    XCTAssertEqual(self.mockDiscovery.serviceEndpoint, self.mockURLRequestFactory.urlPassed)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
            }
            testExpectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testCallsRestClient_withExpectedRequest() {
        let testExpectation = expectation(description: "")
        let expectedURLRequest = URLRequest(url: URL(string: "some-url")!)
        mockURLRequestFactory.requestToReturn = expectedURLRequest
        let response = try? successResponse(withSession: expectedSession)
        let mockRestClient = RestClientMock(replyWith: response)
        let client = SessionsApiClient(discovery: mockDiscovery, merchantIdentifier: "", urlRequestFactory: mockURLRequestFactory, restClient: mockRestClient)
       
        client.createSession(cvv: validCvv, urlSession: urlSession) { result in
            switch result {
                case .success(_):
                    XCTAssertTrue(mockRestClient.sendMethodCalled)
                    XCTAssertEqual(expectedURLRequest, mockRestClient.requestSent)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
            }
            testExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testUndiscoverableErrorReturned_whenSessionEndpointIsNotDiscovered() {
        let testExpectation = expectation(description: "")
        let response = try? successResponse(withSession: expectedSession)
        let mockRestClient = RestClientMock(replyWith: response)
        let client = SessionsApiClient(discovery: mockDiscovery, merchantIdentifier: "", urlRequestFactory: mockURLRequestFactory, restClient: mockRestClient)
        mockDiscovery.failDiscovery = true
        let expectedError = AccessCheckoutClientError.undiscoverable(message: "Unable to discover service")

        client.createSession(cvv: validCvv, urlSession: urlSession) { result in
            switch result {
                case .success(_):
                    XCTFail("Should not have been successful")
                case .failure(let error):
                    XCTAssertEqual(error, expectedError)
            }
            testExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testEndpointNotFoundErrorReturned_whenExpectedSessionIsNotInResponse() {
        let testExpectation = expectation(description: "")
        let response = try? responseWithoutExpectedKey()
        let mockRestClient = RestClientMock(replyWith: response)
        let client = SessionsApiClient(discovery: mockDiscovery, merchantIdentifier: "", urlRequestFactory: mockURLRequestFactory, restClient: mockRestClient)
        let expectedError = AccessCheckoutClientError.endpointNotFound(message: "Endpoint not found in response")

        client.createSession(cvv: validCvv, urlSession: urlSession) { result in
            switch result {
                case .success(let error):
                    XCTFail(error)
                case .failure(let error):
                    XCTAssertEqual(error, expectedError)
            }
            testExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testEndpointNotFoundErrorReturned_whenEndPointAlreadyDiscovered_andExpectedSessionEndpointIsNotInResponse() {
        let testExpectation = expectation(description: "")
        let response = try? responseWithoutExpectedKey()
        let mockRestClient = RestClientMock(replyWith: response)
        let client = SessionsApiClient(discovery: mockDiscovery, merchantIdentifier: "", urlRequestFactory: mockURLRequestFactory, restClient: mockRestClient)
        mockDiscovery.serviceEndpoint = URL(string: "url")
        let expectedError = AccessCheckoutClientError.endpointNotFound(message: "Endpoint not found in response")

        client.createSession(cvv: validCvv, urlSession: urlSession) { result in
            switch result {
                case .success(let error):
                    XCTFail(error)
                case .failure(let error):
                    XCTAssertEqual(error, expectedError)
            }
            testExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testErrorReturned_whenCvvIsBlank() {
        let testExpectation = expectation(description: "")
        let response = try? successResponse(withSession: expectedSession)
        let mockRestClient = RestClientMock(replyWith: response)
        let client = SessionsApiClient(discovery: mockDiscovery, merchantIdentifier: "", urlRequestFactory: mockURLRequestFactory, restClient: mockRestClient)
        let expectedError = AccessCheckoutClientError.unknown(message: "CVV cannot be empty")
        
        client.createSession(cvv: "", urlSession: urlSession) { result in
            switch result {
                case .success(let error):
                    XCTFail(error)
                case .failure(let error):
                    XCTAssertEqual(error, expectedError)
            }
            testExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
    func testCvvSessionServiceErrorReturnedToClient() {
        let expectedError = AccessCheckoutClientError.accessDenied(message: "some error")
        let mockRestClient = RestClientMock<String>(replyWith: expectedError)
        let client = SessionsApiClient(discovery: mockDiscovery, merchantIdentifier: "", urlRequestFactory: mockURLRequestFactory,
                                                 restClient: mockRestClient)
        let testExpectation = expectation(description: "")
        
        client.createSession(cvv: validCvv, urlSession: urlSession) { result in
            switch result {
                case .success(_):
                    XCTFail("Should not have been successful")
                case .failure(let error):
                    XCTAssertEqual(expectedError, error)
            }
            testExpectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    private func successResponse(withSession: String) throws -> ApiResponse {
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
        return try JSONDecoder().decode(ApiResponse.self, from: responseAsData)
    }

    private func responseWithoutExpectedKey() throws -> ApiResponse {
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
