import XCTest

@testable import AccessCheckoutSDK

class CardBinApiClientTests: XCTestCase {
    private var expectationToFulfill: XCTestExpectation?
    private let expectedResponse = CardBinResponse(
        brand: ["visa", "mastercard"],
        fundingType: "debit",
        luhnCompliant: true
    )

    func testCallsRestClientWithRequestCreatedByUrlRequestFactory() {
        expectationToFulfill = expectation(
            description: "should have called mock rest client with expected request")

        let expectedURLRequest = createExpectedURLRequest(
            url: "some-url",
            cardNumber: "444433332222",
            checkoutId: "00000000-0000-0000-0000-000000000000"
        )

        let mockRestClient = RestClientMock(replyWith: expectedResponse)

        let apiClient = CardBinApiClient(
            url: "some-url",
            checkoutId: "00000000-0000-0000-0000-000000000000",
            restClient: mockRestClient
        )

        apiClient.retrieveBinInfo(cardNumber: "444433332222") { _ in
            XCTAssertEqual(expectedURLRequest, mockRestClient.requestSent)
            self.expectationToFulfill!.fulfill()
        }

        wait(for: [expectationToFulfill!], timeout: 1)
    }

    func testCallsCompletionHandlerWithTheResponseReceivedFromRestClient() {
        expectationToFulfill = expectation(
            description: "should have called completion handler with response from rest client")

        let mockRestClient = RestClientMock(replyWith: expectedResponse)
        let apiClient = CardBinApiClient(
            url: "some-url",
            checkoutId: "00000000-0000-0000-0000-000000000000",
            restClient: mockRestClient
        )

        apiClient.retrieveBinInfo(cardNumber: "444433332222") { result in
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
        expectationToFulfill = expectation(
            description: "should have called completion handler with error from rest client")

        let expectedError = AccessCheckoutError.unexpectedApiError(message: "Failed after 3")
        let mockRestClient = RestClientMock<CardBinResponse>(errorWith: expectedError)
        let apiClient = CardBinApiClient(
            url: "some-url",
            checkoutId: "00000000-0000-0000-0000-000000000000",
            restClient: mockRestClient
        )

        apiClient.retrieveBinInfo(cardNumber: "444433332222") { result in
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
        expectationToFulfill = expectation(
            description:
                "should return bin info from cache manager if it exists and rest client is not called"
        )

        let mockRestClient = RestClientMock<CardBinResponse>(replyWith: expectedResponse)

        let apiClient = CardBinApiClient(
            url: "some-url",
            checkoutId: "00000000-0000-0000-0000-000000000000",
            restClient: mockRestClient,
        )

        apiClient.retrieveBinInfo(cardNumber: "444433332222") { result in
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

        apiClient.retrieveBinInfo(cardNumber: "444433332222") { result in
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

    func testRetriesRequestThreeTimesOn5xxError() {
        expectationToFulfill = expectation(
            description: "should retry request three times on server error (5xx)"
        )

        let serverError = AccessCheckoutError.unexpectedApiError(message: "unexpectedApiError")
        let mockRestClient = RestClientMock<CardBinResponse>(
            errorWith: serverError, statusCode: 500)

        let apiClient = CardBinApiClient(
            url: "some-url",
            checkoutId: "00000000-0000-0000-0000-000000000000",
            restClient: mockRestClient
        )

        apiClient.retrieveBinInfo(cardNumber: "444433332222") { result in
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
        expectationToFulfill = expectation(
            description: "should not retry request on client error (4xx)"
        )

        let serverError = AccessCheckoutError.unexpectedApiError(message: "Bad request")
        let mockRestClient = RestClientMock<CardBinResponse>(
            errorWith: serverError, statusCode: 400)

        let apiClient = CardBinApiClient(
            url: "some-url",
            checkoutId: "00000000-0000-0000-0000-000000000000",
            restClient: mockRestClient
        )

        apiClient.retrieveBinInfo(cardNumber: "444433332222") { result in
            switch result {
            case .success:
                XCTFail("Retrieval of card bin info should have failed")
            case .failure(let error):
                XCTAssertEqual(
                    1, mockRestClient.numberOfCalls,
                    "Rest client should be called one time (no retries)")
                XCTAssertTrue(error.localizedDescription.contains("unexpectedApiError"), )
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
}
