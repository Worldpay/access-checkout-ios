import Foundation
import Mockingjay
import XCTest
import PromiseKit
@testable import AccessCheckoutSDK

class RestClientTests: XCTestCase {
    private let urlSession = URLSession(configuration: URLSessionConfiguration.default)
    private let restClient = RestClient()
    
    override func tearDown() {
        removeAllStubs()
    }
    
    func testRestClientSendsRequest() {
        let request = createRequest(url: "http://localhost/somewhere", method: "GET")
        let urlSessionDataTaskMock:URLSessionDataTaskMock = URLSessionDataTaskMock()
        let urlSession:URLSessionMock = URLSessionMock(forRequest: request, usingDataTask: urlSessionDataTaskMock)
        
        let result = restClient.send(urlSession: urlSession, request: request, responseType: DummyResponse.self);
        
        XCTAssertNotNil(result)
        XCTAssertTrue(urlSession.dataTaskCalled)
        XCTAssertTrue(urlSessionDataTaskMock.resumeCalled)
    }
    
    func testRestClientProvidesSuccessfulResponseToPromise() {
        let expectationToWaitFor = XCTestExpectation(description: "")
        let request = createRequest(url: "http://localhost/somewhere", method: "GET")
        stub(http(.get, uri: "http://localhost/somewhere"), jsonData(toData("{\"id\":1, \"name\":\"some name\"}"), status: 200))
        
        firstly  {
            restClient.send(urlSession: urlSession, request: request, responseType: DummyResponse.self)
        }.done() { response in
            XCTAssertEqual(1, response.id)
            XCTAssertEqual("some name", response.name)
        }.catch() { error in
            XCTFail(error.localizedDescription)
        }.finally() {
            expectationToWaitFor.fulfill()
        }
        
        wait(for: [expectationToWaitFor], timeout: 1)
    }
    
    func testRestClientProvidesTranslatedErrorToPromise() {
        let expectationToWaitFor = XCTestExpectation(description: "")
        let request = createRequest(url: "http://localhost/somewhere", method: "GET")
        stub(http(.get, uri: "http://localhost/somewhere"), jsonData(toData("""
                {
                    "errorName": "bodyDoesNotMatchSchema",
                    "message": "The json body provided does not match the expected schema",
                    "validationErrors": [{
                      "errorName": "fieldHasInvalidValue",
                      "message": "Cvc is invalid",
                      "jsonPath": "$.cvc"
                    }]
                }
            """), status: 400))
        
        firstly  {
            restClient.send(urlSession: urlSession, request: request, responseType: DummyResponse.self)
        }.done() { response in
            XCTFail("Expected failed response but received successful response")
        }.catch() { error in
            XCTAssertEqual("bodyDoesNotMatchSchema", (error as! AccessCheckoutClientError).errorName)
        }.finally() {
            expectationToWaitFor.fulfill()
        }
        
        wait(for: [expectationToWaitFor], timeout: 1)
    }
    
    func testRestClientProvidesGenericErrorToPromiseWhenFailingToTranslateResponse() {
        let expectationToWaitFor = XCTestExpectation(description: "")
        let expectedError = AccessCheckoutClientError.unknown(message: "Failed to decode response data")
        let request = createRequest(url: "http://localhost/somewhere", method: "GET")
        stub(http(.get, uri: "http://localhost/somewhere"), jsonData(toData("some data returned"), status: 200))
        
        firstly  {
            restClient.send(urlSession: urlSession, request: request, responseType: DummyResponse.self)
        }.done() { response in
            XCTFail("Expected failed response but received successful response")
        }.catch() { error in
            XCTAssertEqual(expectedError, (error as! AccessCheckoutClientError))
        }.finally() {
            expectationToWaitFor.fulfill()
        }
        
        wait(for: [expectationToWaitFor], timeout: 1)
    }
    
    func testRestClientProvidesGenericErrorToPromiseWhenFailingToGetAResponse() {
        let expectationToWaitFor = XCTestExpectation(description: "")
        let expectedError = AccessCheckoutClientError.unknown(message: "Could not connect to the server.")
        let request = createRequest(url: "http://localhost/somewhere", method: "GET")
        
        firstly  {
            restClient.send(urlSession: urlSession, request: request, responseType: DummyResponse.self)
        }.done() { response in
            XCTFail("Expected failed response but received successful response")
        }.catch() { error in
            XCTAssertEqual(expectedError, (error as! AccessCheckoutClientError))
        }.finally() {
            expectationToWaitFor.fulfill()
        }
        
        wait(for: [expectationToWaitFor], timeout: 1)
    }
    
    private func createRequest(url:String, method:String) -> URLRequest{
        let urlInstance:URL? = URL(string: url)
        var request = URLRequest(url: urlInstance!)
        request.httpMethod = method
        return request
    }
    
    private func toData(_ stringData:String) -> Data {
        return stringData.data(using: .utf8)!
    }
    
    class DummyResponse : Codable {
        var id:Int
        var name:String
    }
}
