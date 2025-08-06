import XCTest

@testable import AccessCheckoutSDK

class ServiceDiscoveryFactoryTests: XCTestCase {

    func testShouldReturnResponseFromDiscoveryRequest() {
        let expectedResponse = toApiResponse()
        let restClientMock = RestClientMock<ApiResponse>(replyWith: expectedResponse)
        let request = URLRequest(url: URL(string: "http://www.example.com")!)

        let factory = ServiceDiscoveryResponseFactory(restClient: restClientMock)

        factory.create(request: request) {
            result in
            XCTAssertEqual(
                result?.links.endpoints["some:service"]?.href,
                expectedResponse.links.endpoints["some:service"]?.href)
        }
    }

    func testShouldReturnNilWhenAFailureOccurredDuringDiscoveryRequest() {
        let expectedError = AccessCheckoutError.unexpectedApiError(message: "An error occurred")

        let restClientMock = RestClientMock<ApiResponse>(errorWith: expectedError)

        let request = URLRequest(url: URL(string: "http://www.example.com")!)
        let factory = ServiceDiscoveryResponseFactory(restClient: restClientMock)

        factory.create(request: request) {
            result in
            XCTAssertNil(result)
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
