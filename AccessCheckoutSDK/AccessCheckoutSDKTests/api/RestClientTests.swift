import Foundation
import XCTest

@testable import AccessCheckoutSDK

class RestClientTests: XCTestCase {
    private var serviceStubs: ServiceStubs?
    private let urlSession = URLSession(configuration: URLSessionConfiguration.default)
    private let restClient = RestClient<DummyResponse>()

    override func setUp() {
        serviceStubs = ServiceStubs()
    }

    override func tearDown() {
        serviceStubs?.stop()
    }

    func testRestClientSendsRequest() {
        let request = createRequest(url: "http://localhost/somewhere", method: "GET")
        let urlSessionDataTaskMock = URLSessionDataTaskMock()
        let urlSession = URLSessionMock(forRequest: request, usingDataTask: urlSessionDataTaskMock)

        _ = restClient.send(urlSession: urlSession, request: request) { _, _ in }

        XCTAssertTrue(urlSession.dataTaskCalled)
        XCTAssertTrue(urlSessionDataTaskMock.resumeCalled)
    }

    func testRestClientInCaseOfSuccessReturnsSuccessfulResponse() {
        let expectationToWaitFor = XCTestExpectation(description: "")
        let request = createRequest(url: "\(serviceStubs!.baseUrl)/somewhere", method: "GET")
        let jsonResponse = "{\"id\":1, \"name\":\"some name\"}"
        serviceStubs!.get200(path: "/somewhere", jsonResponse: jsonResponse)
            .start()

        _ = restClient.send(urlSession: urlSession, request: request) { result, _ in
            switch result {
            case .success(let response):
                XCTAssertEqual(1, response.id)
                XCTAssertEqual("some name", response.name)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectationToWaitFor.fulfill()
        }

        wait(for: [expectationToWaitFor], timeout: 1)
    }

    func testRestClientInCaseOfSuccessReturnStatusCode() {
        let expectationToWaitFor = XCTestExpectation(description: "")
        let request = createRequest(url: "\(serviceStubs!.baseUrl)/somewhere", method: "GET")
        let jsonResponse = "{\"id\":1, \"name\":\"some name\"}"
        serviceStubs!.get200(path: "/somewhere", jsonResponse: jsonResponse)
            .start()

        _ = restClient.send(urlSession: urlSession, request: request) { result, statusCode in
            switch result {
            case .success(_):
                XCTAssertEqual(200, statusCode)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectationToWaitFor.fulfill()
        }

        wait(for: [expectationToWaitFor], timeout: 1)
    }

    func testRestClientInCaseOfErrorReturnsError() {
        let expectationToWaitFor = XCTestExpectation(description: "")
        let request = createRequest(url: "\(serviceStubs!.baseUrl)/somewhere", method: "GET")
        let jsonResponse = """
            {
                "errorName": "bodyDoesNotMatchSchema",
                "message": "The json body provided does not match the expected schema"
            }
            """
        serviceStubs!.get400(path: "/somewhere", jsonResponse: jsonResponse)
            .start()

        _ = restClient.send(urlSession: urlSession, request: request) { result, _ in
            switch result {
            case .success:
                XCTFail("Expected failed response but received successful response")
            case .failure(let error):
                XCTAssertEqual(
                    "bodyDoesNotMatchSchema : The json body provided does not match the expected schema",
                    error.message)
            }
            expectationToWaitFor.fulfill()
        }

        wait(for: [expectationToWaitFor], timeout: 5)
    }

    func testRestClientInCaseOfErrorReturnsStatusCode() {
        let expectationToWaitFor = XCTestExpectation(description: "")
        let request = createRequest(url: "\(serviceStubs!.baseUrl)/somewhere", method: "GET")
        let jsonResponse = """
            {
                "errorName": "bodyDoesNotMatchSchema",
                "message": "The json body provided does not match the expected schema"
            }
            """
        serviceStubs!.get400(path: "/somewhere", jsonResponse: jsonResponse)
            .start()

        _ = restClient.send(urlSession: urlSession, request: request) { result, statusCode in
            switch result {
            case .success:
                XCTFail("Expected failed response but received successful response")
            case .failure(_):
                XCTAssertEqual(400, statusCode)
            }
            expectationToWaitFor.fulfill()
        }

        wait(for: [expectationToWaitFor], timeout: 5)
    }

    func testRestClientProvidesGenericErrorToPromiseWhenFailingToTranslateResponse() {
        let expectationToWaitFor = XCTestExpectation(description: "")
        let expectedError = StubUtils.createError(
            errorName: "responseDecodingFailed", message: "Failed to decode response data")
        let request = createRequest(url: "\(serviceStubs!.baseUrl)/somewhere", method: "GET")
        let textResponse = "some data returned"
        serviceStubs!.get200(path: "/somewhere", textResponse: textResponse)
            .start()

        _ = restClient.send(urlSession: urlSession, request: request) { result, _ in
            switch result {
            case .success:
                XCTFail("Expected failed response but received successful response")
            case .failure(let error):
                XCTAssertEqual(expectedError, error)
            }
            expectationToWaitFor.fulfill()
        }

        wait(for: [expectationToWaitFor], timeout: 1)
    }

    func testRestClientProvidesGenericErrorToPromiseWhenFailingToGetAResponse() {
        let expectationToWaitFor = XCTestExpectation(description: "")
        let request = createRequest(url: "http://localhost/somewhere", method: "GET")
        // On BitRise, the message returned when attempting to connect to an unknown host may occasionally be different
        // Hence why we need to assert on different error messages
        let expectedError1 = StubUtils.createError(
            errorName: "unexpectedApiError", message: "Could not connect to the server.")
        let expectedError2 = StubUtils.createError(
            errorName: "unexpectedApiError",
            message: "A server with the specified hostname could not be found.")

        _ = restClient.send(urlSession: urlSession, request: request) { result, _ in
            switch result {
            case .success:
                XCTFail("Expected failed response but received successful response")
            case .failure(let error):
                XCTAssert(error == expectedError1 || error == expectedError2)
            }
            expectationToWaitFor.fulfill()
        }

        wait(for: [expectationToWaitFor], timeout: 1)
    }

    func testRestClientReturnsUrlSessionTask() {
        let request = createRequest(url: "http://localhost/somewhere", method: "GET")
        let task: URLSessionTask = restClient.send(urlSession: urlSession, request: request) {
            result, statusCode in
        }

        XCTAssertNotNil(task)
    }

    func testDoesNotCallCompletionHandlerWhenTaskIsCancelled() {
        serviceStubs!.get200(path: "/somewhere", textResponse: "some response", delayInSeconds: 0.5)
            .start()

        var calledCompletionHandler = false

        let request = createRequest(url: "http://localhost/somewhere", method: "GET")
        let task: URLSessionTask = restClient.send(urlSession: urlSession, request: request) {
            result, statusCode in
            calledCompletionHandler = true
        }

        task.cancel()

        Thread.sleep(forTimeInterval: 1)

        XCTAssertTrue(!calledCompletionHandler)
    }

    private func createRequest(url: String, method: String) -> URLRequest {
        let urlInstance: URL? = URL(string: url)
        var request = URLRequest(url: urlInstance!)
        request.httpMethod = method
        return request
    }

    private func toData(_ stringData: String) -> Data {
        return stringData.data(using: .utf8)!
    }

    class DummyResponse: Codable {
        var id: Int
        var name: String
    }
}
