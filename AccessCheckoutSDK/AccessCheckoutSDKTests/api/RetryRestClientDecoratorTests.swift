import Cuckoo
import Foundation
import XCTest

@testable import AccessCheckoutSDK

class RetryRestClientDecoratorTests: XCTestCase {
    private var expectationToFulfill: XCTestExpectation?

    var baseRestClient = MockRestClient<ApiResponse>()
    var retryRestClient: RetryRestClientDecorator<ApiResponse>!

    override func setUp() {
        retryRestClient = RetryRestClientDecorator<ApiResponse>(baseRestClient: baseRestClient)
    }

    func testShouldReturnAnErrorAfterXAttemptsToSendRequest() {
        expectationToFulfill = expectation(description: "")

        let attempts = 6

        let responseError = AccessCheckoutError.unexpectedApiError(
            message: "some error message")
        let expectedError = AccessCheckoutError.unexpectedApiError(
            message:
                "Failed after \(attempts) attempt(s) with error \(responseError.message)"
        )

        setUpBaseRestClient(withError: responseError)

        let (request, urlSession) = createRequestAndUrlSession(
            url: "http://localhost/somewhere", method: "GET")

        retryRestClient = RetryRestClientDecorator<ApiResponse>(
            baseRestClient: baseRestClient, maxAttempts: attempts)

        _ = retryRestClient.send(urlSession: urlSession, request: request) { result, _ in
            switch result {
            case .success:
                XCTFail("Expected all request attempts to fail, but received a success")

                self.expectationToFulfill!.fulfill()
            case .failure(let error):
                verify(self.baseRestClient, times(attempts)).send(
                    urlSession: any(), request: any(), completionHandler: any())

                XCTAssertEqual(error, expectedError)

                self.expectationToFulfill!.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    func testShouldReturnAnErrorAfterDefaultAmountOfAttemptsHaveBeenMadeToSendRequest() {
        expectationToFulfill = expectation(description: "")

        let responseError = AccessCheckoutError.unexpectedApiError(
            message: "some error message")
        let expectedError = AccessCheckoutError.unexpectedApiError(
            message:
                "Failed after 3 attempt(s) with error \(responseError.message)"
        )

        setUpBaseRestClient(withError: responseError)

        let (request, urlSession) = createRequestAndUrlSession(
            url: "http://localhost/somewhere", method: "GET")

        _ = retryRestClient.send(urlSession: urlSession, request: request) { result, _ in
            switch result {
            case .success:
                XCTFail("Expected all request attempts to fail, but received a success")

                self.expectationToFulfill!.fulfill()
            case .failure(let error):
                verify(self.baseRestClient, times(3)).send(
                    urlSession: any(), request: any(), completionHandler: any())

                XCTAssertEqual(error, expectedError)

                self.expectationToFulfill!.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    func testShouldReturnResponseAfterTwoFailedAttemptsToSendRequest() {
        expectationToFulfill = expectation(description: "")

        let responseError = AccessCheckoutError.unexpectedApiError(
            message: "some error message")

        baseRestClient.getStubbingProxy()
            .send(urlSession: any(), request: any(), completionHandler: any())
            .then {
                _, _, completionHandler in
                completionHandler(.failure(responseError), nil)
                return URLSessionTask()
            }.then {
                _, _, completionHandler in
                completionHandler(.failure(responseError), nil)
                return URLSessionTask()
            }.then {
                _, _, completionHandler in
                completionHandler(.success(self.genericApiResponse()), nil)
                return URLSessionTask()
            }

        let (request, urlSession) = createRequestAndUrlSession(
            url: "http://localhost/somewhere", method: "GET")

        _ = retryRestClient.send(urlSession: urlSession, request: request) { result, _ in
            switch result {
            case .success(let response):
                verify(self.baseRestClient, times(3)).send(
                    urlSession: any(), request: any(), completionHandler: any())
                XCTAssertNotNil(response)
                self.expectationToFulfill!.fulfill()
            case .failure(let error):
                XCTFail(
                    "Expected request to succeed, but it failed with error: \(error.errorDescription!)"
                )

                self.expectationToFulfill!.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    private func setUpBaseRestClient(withError: AccessCheckoutError? = nil) {
        let result =
            (withError != nil)
            ? Result.failure(withError!)
            : Result.success(self.genericApiResponse())

        baseRestClient.getStubbingProxy()
            .send(urlSession: any(), request: any(), completionHandler: any())
            .then {
                _, _, completionHandler in
                completionHandler(result, nil)
                return URLSessionTask()
            }
    }

    private func genericApiResponse() -> ApiResponse {
        let jsonString = """
            {
                "_links": {
                    "a:service": {
                        "href": "http://www.a-service.co.uk"
                    },
                },
            }
            """

        let data = Data(jsonString.utf8)
        return try! JSONDecoder().decode(ApiResponse.self, from: data)
    }

    private func createRequestAndUrlSession(url: String, method: String) -> (URLRequest, URLSession)
    {
        let urlInstance: URL? = URL(string: url)
        var request = URLRequest(url: urlInstance!)
        request.httpMethod = method

        let urlSessionDataTaskMock = URLSessionDataTaskMock()
        let urlSession = URLSessionMock(forRequest: request, usingDataTask: urlSessionDataTaskMock)

        return (request, urlSession)
    }
}
