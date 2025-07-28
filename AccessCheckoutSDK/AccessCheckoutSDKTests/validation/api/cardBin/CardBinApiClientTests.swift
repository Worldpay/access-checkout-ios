import XCTest

@testable import AccessCheckoutSDK

class CardBinApiClientTests: XCTestCase {
    private var expectationToFulfill: XCTestExpectation?

    func testCallsRestClientWithRequestCreatedByUrlRequestFactory() {
        let expectedURLRequest = createExpectedURLRequest(
            url: "some-url",
            cardNumber: "444433332222",
            checkoutId: "00000000-0000-0000-0000-000000000000"
        )

        expectationToFulfill = expectation(
            description: "should have called mock rest client with expected request")

        let cardBinResponse = CardBinResponse(
            brand: ["visa", "mastercard"],
            fundingType: "debit",
            luhnCompliant: true
        )

        let mockRestClient = RestClientMock(replyWith: cardBinResponse)

        let apiClient = CardBinApiClient(
            url: "some-url",
            checkoutId: "00000000-0000-0000-0000-000000000000",
            restClient: mockRestClient
        )

        apiClient.retrieveBinInfo(cardNumber: "444433332222") { _ in
                XCTAssertEqual(mockRestClient.requestSent, expectedURLRequest)
                self.expectationToFulfill!.fulfill()
            }

        wait(for: [expectationToFulfill!], timeout: 1)
    }

    func testCallsCompletionHandlerWithTheResponseReceivedFromRestClient() {
        expectationToFulfill = expectation(
            description: "should have called completion handler with response from rest client")

        let expectedCardBinResponse = CardBinResponse(
            brand: ["visa", "mastercard"],
            fundingType: "debit",
            luhnCompliant: true
        )

        let mockRestClient = RestClientMock(replyWith: expectedCardBinResponse)
        let apiClient = CardBinApiClient(
            url: "some-url",
            checkoutId: "00000000-0000-0000-0000-000000000000",
            restClient: mockRestClient
        )

        apiClient.retrieveBinInfo(cardNumber: "444433332222") { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.brand, expectedCardBinResponse.brand)
                XCTAssertEqual(response.fundingType, expectedCardBinResponse.fundingType)
                XCTAssertEqual(response.luhnCompliant, expectedCardBinResponse.luhnCompliant)
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

        let expectedError = AccessCheckoutError.unexpectedApiError(message: "Network error")
        let mockRestClient = RestClientMock(replyWith: expectedError)
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
                XCTAssertEqual(error, expectedError)
            }
            self.expectationToFulfill!.fulfill()
        }

        wait(for: [expectationToFulfill!], timeout: 1)
    }

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
