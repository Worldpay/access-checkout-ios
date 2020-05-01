@testable import AccessCheckoutSDK
import XCTest

class AccessCheckoutClientImplTests: XCTestCase {
    func testRetrievesAVerifiedTokensSession() {
        let client = try! AccessCheckoutClientBuilder().merchantId("123")
            .accessBaseUrl("some url")
            .build()
        let cardDetails = CardDetails.builder().build()
        let sessionExpectation = expectation(description: "Session retrieved")

        client.generateSession(cardDetails: cardDetails, sessionType: SessionType.verifiedTokens) { result in
            switch result {
                case .success(let session):
                    XCTAssertEqual("a-session", session)
                    sessionExpectation.fulfill()
                case .failure:
                    XCTFail("got an error back from services")
            }
        }

        wait(for: [sessionExpectation], timeout: 1)
    }

    func testRetrievesAPaymentsCvcSession() {
        let client = try! AccessCheckoutClientBuilder().merchantId("123")
            .accessBaseUrl("some url")
            .build()
        let cardDetails = CardDetails.builder().build()
        let sessionExpectation = expectation(description: "Session retrieved")

        client.generateSession(cardDetails: cardDetails, sessionType: SessionType.paymentsCvc) { result in
            switch result {
                case .success(let session):
                    XCTAssertEqual("a-session", session)
                    sessionExpectation.fulfill()
                case .failure:
                    XCTFail("got an error back from services")
            }
        }

        wait(for: [sessionExpectation], timeout: 1)
    }
}
