import XCTest

@testable import AccessCheckoutSDK

class ServiceDiscoveryFactoryTests: XCTestCase {

    func testShouldReturnResponseFromDiscoveryRequest() {
        let expectedResponse = toApiResponse()
        let restClientMock = RestClientMock<ApiResponse>(replyWith: expectedResponse)
        let request = URLRequest(url: URL(string: "http://www.example.com")!)

        let factory = ServiceDiscoveryResponseFactory(restClient: restClientMock)

        factory.create(request: request) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(
                    response.links.endpoints["some:service"]?.href,
                    expectedResponse.links.endpoints["some:service"]?.href)
            case .failure(_):
                XCTFail("Response should have been returned")
            }
        }
    }

    func testShouldReturnAnErrorWhenAnErrorOccurredDuringDiscoveryRequest() {
        let expectedError = AccessCheckoutError.unexpectedApiError(message: "An error occurred")
        let restClientMock = RestClientMock<ApiResponse>(errorWith: expectedError)

        let request = URLRequest(url: URL(string: "http://www.example.com")!)
        let factory = ServiceDiscoveryResponseFactory(restClient: restClientMock)

        factory.create(request: request) { result in
            switch result {
            case .success(_):
                XCTFail("An error should have occurred")
            case .failure(let error):
                XCTAssertEqual(error, expectedError)
            }
        }
    }

    private func toApiResponse() -> ApiResponse {
        let jsonString = """
            {
                "_links": {
                    "some:service": {
                        "href": "http://www.a-service.co.uk"
                    },
                }
            }
            """

        let data = Data(jsonString.utf8)
        return try! JSONDecoder().decode(ApiResponse.self, from: data)
    }
}
