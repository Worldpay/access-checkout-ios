import Cuckoo
import XCTest

@testable import AccessCheckoutSDK

class CardBinApiClientTests: XCTestCase {
    private var expectationToFulfill: XCTestExpectation?
    private let expectedResponse = CardBinResponse(
        brand: ["visa", "mastercard"],
        fundingType: "debit",
        luhnCompliant: true
    )
    private let testCardNumber = "444433332222"
    private let testCheckoutId = "00000000-0000-0000-0000-000000000000"
    private var request: CardBinRequest!

    let cardBinServiceUrl = "card-bin-service-url"
    let restClient = MockRetryRestClientDecorator<ApiResponse>()
    let apiResponseLookUpMock = MockApiResponseLinkLookup()

    override func setUp() {
        super.setUp()
        request = CardBinRequest(cardNumber: testCardNumber, checkoutId: testCheckoutId)

        try? ServiceDiscoveryProvider.initialise("some-url", restClient, apiResponseLookUpMock)
        ServiceDiscoveryProvider.clearCache()

        setUpDiscoveryResponses()
        setUpApiResponseLookups()
    }

    func testCallsRestClientWithRequestCreatedByUrlRequestFactory() {
        expectationToFulfill = expectation(description: "")

        let expectedURLRequest = self.createExpectedURLRequest(
            url: self.cardBinServiceUrl,
            cardNumber: self.testCardNumber,
            checkoutId: self.testCheckoutId
        )

        let mockRestClient = RestClientMock(replyWith: self.expectedResponse)
        let apiClient = CardBinApiClient(restClient: mockRestClient)

        apiClient.retrieveBinInfo(
            cardNumber: self.testCardNumber, checkoutId: self.testCheckoutId
        ) { _ in
            XCTAssertEqual(expectedURLRequest, mockRestClient.requestSent)
            self.expectationToFulfill!.fulfill()
        }

        wait(for: [expectationToFulfill!], timeout: 1)
    }

    func testCallsCompletionHandlerWithTheResponseReceivedFromRestClient() {
        expectationToFulfill = expectation(description: "")

        let mockRestClient = RestClientMock(replyWith: self.expectedResponse)
        let apiClient = CardBinApiClient(restClient: mockRestClient)

        apiClient.retrieveBinInfo(
            cardNumber: self.testCardNumber, checkoutId: self.testCheckoutId
        ) {
            result in
            switch result {
            case .success(let response):
                XCTAssertEqual(self.expectedResponse.brand, response.brand)
                XCTAssertEqual(self.expectedResponse.fundingType, response.fundingType)
                XCTAssertEqual(self.expectedResponse.luhnCompliant, response.luhnCompliant)
            case .failure:
                XCTFail("Retrieval of card bin info should have succeeded")
            }
            self.expectationToFulfill!.fulfill()
        }

        wait(for: [expectationToFulfill!], timeout: 1)
    }

    func testCallsCompletionHandlerWithErrorWhenRestClientFails() {
        expectationToFulfill = expectation(description: "")

        let mockRestClient = RestClientMock<CardBinResponse>(
            errorWith: AccessCheckoutError.unexpectedApiError(message: "some error"))
        let detailedErrorMessage = "Message: unexpectedApiError : some error\n Validation: "
        let expectedError = AccessCheckoutError.unexpectedApiError(
            message: "Failed after 3 attempt(s) with error \(detailedErrorMessage)")

        let apiClient = CardBinApiClient(restClient: mockRestClient)

        apiClient.retrieveBinInfo(
            cardNumber: self.testCardNumber, checkoutId: self.testCheckoutId
        ) {
            result in
            switch result {
            case .success:
                XCTFail("Retrieval of card bin info should have failed")
            case .failure(let error):
                XCTAssertEqual(expectedError, error)
            }
            self.expectationToFulfill!.fulfill()
        }

        wait(for: [expectationToFulfill!], timeout: 1)
    }

    func testCallsToCacheManagerWhenRetrievingBinInfo() {
        expectationToFulfill = expectation(description: "")

        let mockRestClient = RestClientMock<CardBinResponse>(replyWith: self.expectedResponse)
        let apiClient = CardBinApiClient(restClient: mockRestClient)

        apiClient.retrieveBinInfo(
            cardNumber: self.testCardNumber, checkoutId: self.testCheckoutId
        ) {
            result in
            switch result {
            case .success(let response):
                XCTAssertEqual(self.expectedResponse.brand, response.brand)
                XCTAssertEqual(
                    mockRestClient.numberOfCalls, 1,
                    "Rest client is called once on new card bin number")
            case .failure:
                XCTFail("Retrieval of card bin info failed")
            }
        }

        apiClient.retrieveBinInfo(
            cardNumber: self.testCardNumber, checkoutId: self.testCheckoutId
        ) {
            result in
            switch result {
            case .success(let response):
                XCTAssertEqual(self.expectedResponse.brand, response.brand)
                XCTAssertEqual(
                    mockRestClient.numberOfCalls, 1, "Rest client should not be called again")
                self.expectationToFulfill!.fulfill()
            case .failure:
                XCTFail("Retrieval of card bin info failed")
            }
        }

        wait(for: [expectationToFulfill!], timeout: 1)
    }

    func testAttemptsRequestThreeTimesOn5xxError() {
        expectationToFulfill = expectation(description: "")

        let serverError = AccessCheckoutError.unexpectedApiError(message: "unexpectedApiError")
        let mockRestClient = RestClientMock<CardBinResponse>(
            errorWith: serverError, statusCode: 500)

        let apiClient = CardBinApiClient(restClient: mockRestClient)

        apiClient.retrieveBinInfo(
            cardNumber: self.testCardNumber, checkoutId: self.testCheckoutId
        ) {
            result in
            switch result {
            case .success:
                XCTFail("Retrieval of card bin info should have failed")
            case .failure(let error):
                XCTAssertEqual(
                    3, mockRestClient.numberOfCalls, "Rest client should be called three times")
                XCTAssertTrue(error.localizedDescription.contains("unexpectedApiError"))
            }
            self.expectationToFulfill!.fulfill()
        }

        wait(for: [expectationToFulfill!], timeout: 1)
    }

    func testDoesNotRetryOnClientError() {
        expectationToFulfill = expectation(description: "")

        let serverError = AccessCheckoutError.unexpectedApiError(message: "Bad request")
        let mockRestClient = RestClientMock<CardBinResponse>(
            errorWith: serverError, statusCode: 400)

        let apiClient = CardBinApiClient(restClient: mockRestClient)

        apiClient.retrieveBinInfo(
            cardNumber: self.testCardNumber, checkoutId: self.testCheckoutId
        ) {
            result in
            switch result {
            case .success:
                XCTFail("Retrieval of card bin info should have failed")
            case .failure(let error):
                XCTAssertEqual(
                    1, mockRestClient.numberOfCalls,
                    "Rest client should be called one time (no retries)")
                XCTAssertTrue(error.localizedDescription.contains("unexpectedApiError"))
            }
            self.expectationToFulfill!.fulfill()
        }
        wait(for: [expectationToFulfill!], timeout: 1)
    }
}

extension CardBinApiClientTests {
    private func createExpectedURLRequest(
        url: String, cardNumber: String, checkoutId: String
    ) -> URLRequest {
        var urlRequest = URLRequest(url: URL(string: url)!)

        let payload = CardBinRequest(cardNumber: cardNumber, checkoutId: checkoutId)
        urlRequest.httpBody = try? JSONEncoder().encode(payload)
        urlRequest.httpMethod = "POST"

        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("checkoutios", forHTTPHeaderField: "WP-CallerId")
        urlRequest.addValue("1", forHTTPHeaderField: "WP-Api-Version")

        return urlRequest
    }

    private func setUpDiscoveryResponses() {
        restClient.getStubbingProxy()
            .send(urlSession: any(), request: any(), completionHandler: any())
            .then { _, _, completionHandler in
                completionHandler(.success(self.genericApiResponse()), nil)
                return URLSessionTask()
            }.then { _, _, completionHandler in
                completionHandler(.success(self.genericApiResponse()), nil)
                return URLSessionTask()
            }
    }

    // cuckoo requires stubbing all methods to avoid error
    private func setUpApiResponseLookups() {
        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: ApiLinks.cardSessions.service, in: any())
            .thenReturn("sessions-service-url")
        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: ApiLinks.cardBin.service, in: any())
            .thenReturn(cardBinServiceUrl)
        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: ApiLinks.cardSessions.endpoint, in: any())
            .thenReturn("sessions-card-href")
        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: ApiLinks.cvcSessions.endpoint, in: any())
            .thenReturn("sessions-cvc-href")
    }

    private func genericApiResponse() -> ApiResponse {
        let jsonString = """
            {
                "_links": {
                    "a:service": {
                        "href": "http://www.example.com"
                    }
                }
            }
            """
        let data = Data(jsonString.utf8)
        return try! JSONDecoder().decode(ApiResponse.self, from: data)
    }
}
