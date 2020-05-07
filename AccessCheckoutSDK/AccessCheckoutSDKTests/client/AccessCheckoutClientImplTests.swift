@testable import AccessCheckoutSDK
import Mockingjay
import XCTest

class AccessCheckoutClientImplTests: XCTestCase {
    let baseUrl = "http://localhost"
    let verifiedTokensServicePath = "/verifiedTokens"
    let verifiedTokensServiceSessionsPath = "/verifiedTokens/sessions"
    let sessionsPath = "/sessions"
    let sessionsPaymentsCvcPath = "/sessions/paymentsCvc"

    func testRetrievesAVerifiedTokensSession() throws {
        stub(http(.get, uri: baseUrl), successfulDiscoveryResponse(baseUrl: baseUrl))
        stub(http(.get, uri: "\(baseUrl)\(verifiedTokensServicePath)"), successfulDiscoveryResponse(baseUrl: baseUrl))
        stub(http(.post, uri: "\(baseUrl)\(verifiedTokensServiceSessionsPath)"), successfulVerifiedTokensSessionResponse(session: "expected-verified-tokens-session"))

        let client = try! AccessCheckoutClientBuilder().merchantId("a-merchant-id")
            .accessBaseUrl(baseUrl)
            .build()
        let cardDetails = CardDetailsBuilder().pan("pan")
            .expiryMonth("12")
            .expiryYear("20")
            .cvv("123")
            .build()
        let sessionExpectation = expectation(description: "Session retrieved")

        try client.generateSession(cardDetails: cardDetails, sessionType: SessionType.verifiedTokens) { result in
            switch result {
                case .success(let session):
                    XCTAssertEqual("expected-verified-tokens-session", session)
                    sessionExpectation.fulfill()
                case .failure:
                    XCTFail("got an error back from services")
            }
        }

        wait(for: [sessionExpectation], timeout: 1)
    }

    func testRetrievesAPaymentsCvcSession() throws {
        stub(http(.get, uri: baseUrl), successfulDiscoveryResponse(baseUrl: baseUrl))
        stub(http(.get, uri: "\(baseUrl)\(sessionsPath)"), successfulDiscoveryResponse(baseUrl: baseUrl))
        stub(http(.post, uri: "\(baseUrl)\(sessionsPaymentsCvcPath)"), successfulPaymentsCvcSessionResponse(session: "expected-payments-cvc-session"))

        let client = try! AccessCheckoutClientBuilder().merchantId("a-merchant-id")
            .accessBaseUrl(baseUrl)
            .build()
        let cardDetails = CardDetailsBuilder().cvv("123")
            .build()
        let sessionExpectation = expectation(description: "Session retrieved")

        try client.generateSession(cardDetails: cardDetails, sessionType: SessionType.paymentsCvc) { result in
            switch result {
                case .success(let session):
                    XCTAssertEqual("expected-payments-cvc-session", session)
                    sessionExpectation.fulfill()
                case .failure:
                    XCTFail("got an error back from services")
            }
        }

        wait(for: [sessionExpectation], timeout: 1)
    }

    func testDoesNotRetrieveVerifiedTokensSessionWhenCardDetailsAreIncomplete() {
        let expectedError = AccessCheckoutClientInitialisationError.incompleteCardDetails(message: "Expiry Month is mandatory to retrieve a Verified Tokens session")
        let client = try! AccessCheckoutClientBuilder().merchantId("a-merchant-id")
            .accessBaseUrl(baseUrl)
            .build()
        let cardDetails = CardDetailsBuilder().pan("pan")
            .expiryYear("20")
            .cvv("123")
            .build()

        XCTAssertThrowsError(try client.generateSession(cardDetails: cardDetails, sessionType: .verifiedTokens) { _ in }) { error in
            XCTAssertEqual(expectedError, error as! AccessCheckoutClientInitialisationError)
        }
    }

    func testDoesNotRetrieveVPaymentsCvcSessionWhenCardDetailsAreIncomplete() {
        let expectedError = AccessCheckoutClientInitialisationError.incompleteCardDetails(message: "Cvc is mandatory to retrieve a Payments Cvc session")
        let client = try! AccessCheckoutClientBuilder().merchantId("a-merchant-id")
            .accessBaseUrl(baseUrl)
            .build()
        let cardDetails = CardDetailsBuilder().build()

        XCTAssertThrowsError(try client.generateSession(cardDetails: cardDetails, sessionType: .paymentsCvc) { _ in }) { error in
            XCTAssertEqual(expectedError, error as! AccessCheckoutClientInitialisationError)
        }
    }

    private func toData(_ stringData: String) -> Data {
        return stringData.data(using: .utf8)!
    }

    private func successfulDiscoveryResponse(baseUrl: String) -> (URLRequest) -> Response {
        return jsonData(toData("""
        {
            "_links": {
                "service:verifiedTokens": {
                    "href": "\(baseUrl)\(verifiedTokensServicePath)"
                },
                "verifiedTokens:sessions": {
                    "href": "\(baseUrl)\(verifiedTokensServiceSessionsPath)"
                },
                "service:sessions": {
                    "href": "\(baseUrl)\(sessionsPath)"
                },
                "sessions:paymentsCvc": {
                    "href": "\(baseUrl)\(sessionsPaymentsCvcPath)"
                }
            }
        }
        """), status: 200)
    }

    private func successfulVerifiedTokensSessionResponse(session: String) -> (URLRequest) -> Response {
        return jsonData(toData("""
        {
            "_links": {
                "verifiedTokens:session": {
                    "href": "\(session)"
                }
            }
        }
        """), status: 201)
    }

    private func successfulPaymentsCvcSessionResponse(session: String) -> (URLRequest) -> Response {
        return jsonData(toData("""
        {
            "_links": {
                "sessions:session": {
                    "href": "\(session)"
                }
            }
        }
        """), status: 201)
    }
}
