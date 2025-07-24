import XCTest

@testable import AccessCheckoutSDK

class CardBinApiClientTests: XCTestCase {
    private var expectationToFulfill: XCTestExpectation?

    func testCallsRestClientWithRequestCreatedByUrlRequestFactory() {
        let expectedURLRequest = createExpectedURLRequest(
            url: "some-url",
            cardNumber: "444433332222",
            checkoutId: "123"
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
            checkoutId: "123",
            restClient: mockRestClient
        )

        apiClient.retrieveBinInfo(cardNumber: "444433332222") { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.brand, ["visa", "mastercard"])
                XCTAssertEqual(response.fundingType, "debit")
                XCTAssertTrue(response.luhnCompliant)

                XCTAssertEqual(mockRestClient.requestSent, expectedURLRequest)
            case .failure:
                XCTFail("Retrieval of card bin info should have succeeded")
            }
            self.expectationToFulfill!.fulfill()
        }

        wait(for: [expectationToFulfill!], timeout: 1)
    }

    func testCallsCompletionHandlerWithTheResponseReceivedFromRestClient() {

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
