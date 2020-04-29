import Foundation
import Mockingjay
import XCTest
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
        
        restClient.send(urlSession: urlSession, request: request, responseType: DummyResponse.self, completionHandler: { result in });
        
        XCTAssertTrue(urlSession.dataTaskCalled)
        XCTAssertTrue(urlSessionDataTaskMock.resumeCalled)
    }
    
    func testRestClientProvidesSuccessfulResponseToCompletionHandler() {
        let expectationToWaitFor = XCTestExpectation(description: "")
        let request = createRequest(url: "http://localhost/somewhere", method: "GET")
        stub(http(.get, uri: "http://localhost/somewhere"), jsonData(toData("{\"id\":1, \"name\":\"some name\"}"), status: 200))
        
        restClient.send(urlSession: urlSession, request: request, responseType: DummyResponse.self, completionHandler: { result in
            switch result {
            case .success(let dummyResponse):
                XCTAssertEqual(1, dummyResponse.id)
                XCTAssertEqual("some name", dummyResponse.name)
                
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            expectationToWaitFor.fulfill()
        });
        
        wait(for: [expectationToWaitFor], timeout: 1)
    }
    
    func testRestClientProvidesTranslatedErrorToCompletionHandler() {
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
        
        restClient.send(urlSession: urlSession, request: request, responseType: DummyResponse.self, completionHandler: { result in
            switch result {
            case .success(_):
                XCTFail("Expected failed response but received successful response")
            case .failure(let error):
                XCTAssertEqual("bodyDoesNotMatchSchema", (error as AccessCheckoutClientError).errorName)
            }
            
            expectationToWaitFor.fulfill()
        });
        
        wait(for: [expectationToWaitFor], timeout: 1)
    }
    
    func testRestClientProvidesGenericErrorToCompletionHandlerWhenFailingToTranslateResponse() {
        let expectationToWaitFor = XCTestExpectation(description: "")
        let request = createRequest(url: "http://localhost/somewhere", method: "GET")
        stub(http(.get, uri: "http://localhost/somewhere"), jsonData(toData("some data returned"), status: 200))
        
        restClient.send(urlSession: urlSession, request: request, responseType: DummyResponse.self, completionHandler: { result in
            switch result {
            case .success(_):
                XCTFail("Expected failed response but received successful response")
            case .failure(let error):
                XCTAssertEqual("Error: unknown Message: Failed to decode response data", (error as AccessCheckoutClientError).errorDescription)
            }
            
            expectationToWaitFor.fulfill()
        });
        
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
}

class DummyResponse : Codable {
    var id:Int
    var name:String
}
