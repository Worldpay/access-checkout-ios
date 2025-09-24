import Cuckoo
import Foundation
import Swifter
import XCTest

@testable import AccessCheckoutSDK

class CardBinApiClientTestsWithStubService: XCTestCase {
    private var serviceStubs: ServiceStubs = ServiceStubs()
    private var cardBinApiClient: CardBinApiClient!

    let restClient = MockRetryRestClientDecorator<ApiResponse>()
    let apiResponseLookUpMock = MockApiResponseLinkLookup()

    private let checkoutId = "00000000-0000-0000-000000000000"
    private let visaTestPan = "444433332222"

    override func setUp() {
        serviceStubs = ServiceStubs()

        try? ServiceDiscoveryProvider.initialise("some-url", restClient, apiResponseLookUpMock)
        ServiceDiscoveryProvider.clearCache()

        setUpDiscoveryResponses()
        setUpApiResponseLookups()

        cardBinApiClient = CardBinApiClient()
    }

    override func tearDown() {
        serviceStubs.stop()
        ServiceDiscoveryProvider.clearCache()
    }

    func testClientSupportsCancellingRequestInFlight() {
        let expectation = self.expectation(description: "Discovery should complete")

        ServiceDiscoveryProvider.discoverAll { _ in
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        serviceStubs.post200(path: "/somewhere", textResponse: "some response", delayInSeconds: 0.5)
            .start()

        var calledCompletionHandler = false

        cardBinApiClient.retrieveBinInfo(cardNumber: visaTestPan, checkoutId: checkoutId) {
            result in
            calledCompletionHandler = true
        }
        cardBinApiClient.abort()

        Thread.sleep(forTimeInterval: 1)

        XCTAssertFalse(calledCompletionHandler)
    }

    func testClientSupportsCancellingRequestInFlightWhenRetrying() {
        let expectation = self.expectation(description: "Discovery should complete")

        ServiceDiscoveryProvider.discoverAll { _ in
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        serviceStubs.post500(path: "/somewhere", delayInSeconds: 0.2)
            .start()

        var calledCompletionHandler = false

        cardBinApiClient.retrieveBinInfo(cardNumber: visaTestPan, checkoutId: checkoutId) {
            result in
            calledCompletionHandler = true
        }

        Thread.sleep(forTimeInterval: 0.3)
        cardBinApiClient.abort()

        Thread.sleep(forTimeInterval: 1)
        XCTAssertFalse(calledCompletionHandler)
    }

    private func setUpDiscoveryResponses() {
        restClient.getStubbingProxy()
            .send(urlSession: any(), request: any(), completionHandler: any())
            .then { _, _, completionHandler in
                completionHandler(.success(self.accessRootApiResponse()), nil)
                return URLSessionTask()
            }.then { _, _, completionHandler in
                completionHandler(.success(self.sessionsApiResponse()), nil)
                return URLSessionTask()
            }
    }

    private func setUpApiResponseLookups() {
        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: ApiLinks.cardSessions.service, in: any())
            .thenReturn("sessions-service-url")
        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: ApiLinks.cardBin.service, in: any())
            .thenReturn("\(serviceStubs.baseUrl)/somewhere")
        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: ApiLinks.cardSessions.endpoint, in: any())
            .thenReturn("sessions-card-href")
        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: ApiLinks.cvcSessions.endpoint, in: any())
            .thenReturn("sessions-cvc-href")
    }

    private func accessRootApiResponse() -> ApiResponse {
        let jsonString = """
            {
                "_links": {
                    "service:sessions": {
                        "href": "sessions-service-url"
                    },
                    "service:card-bin": {
                        "href": "\(serviceStubs.baseUrl)/somewhere"
                    }
                }
            }
            """
        let data = Data(jsonString.utf8)
        return try! JSONDecoder().decode(ApiResponse.self, from: data)
    }

    private func sessionsApiResponse() -> ApiResponse {
        let jsonString = """
            {
                "_links": {
                    "sessions:card": {
                        "href": "sessions-card-href"
                    },
                    "sessions:cvc": {
                        "href": "sessions-cvc-href"
                    }
                }
            }
            """
        let data = Data(jsonString.utf8)
        return try! JSONDecoder().decode(ApiResponse.self, from: data)
    }
}
