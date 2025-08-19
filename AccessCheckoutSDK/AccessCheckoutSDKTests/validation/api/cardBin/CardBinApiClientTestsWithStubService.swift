import Cuckoo
import Foundation
import Swifter
import XCTest

@testable import AccessCheckoutSDK

class CardBinApiClientTestsWithStubService: XCTestCase {
    private var serviceStubs: ServiceStubs = ServiceStubs()
    private var cardBinApiClient: CardBinApiClient!

    private let checkoutId = "00000000-0000-0000-000000000000"
    private let visaTestPan = "444433332222"

    override func setUp() {
        serviceStubs = ServiceStubs()
        cardBinApiClient = CardBinApiClient(url: "\(serviceStubs.baseUrl)/somewhere")
    }

    override func tearDown() {
        cardBinApiClient = nil
        serviceStubs.stop()
    }

    /*
     This test is designed to:
     - use a stub server
     - delay the response from a stub server by 0.5 seconds
     - abort the call to the retrieveBinInfo() method of the CardBinApiClient class
     - assert that the completion handler passed to the retrieveBinInfo() method was never called
     */
    func testClientSupportsCancellingRequestInFlight() {
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

    /*
     This test is designed to:
     - use a stub server
     - delay the response from a stub server by 0.2 seconds and always send back a 500
     - 500s are used to make sure that the CardBinApiClient can retry since it would not if the error is an 4xx
     - abort the call to the retrieveBinInfo() method of the CardBinApiClient class after 0.3 seconds, i.e. in the middle of the 2nd attempt
     - wait 1s, for any potential retry to occur although they should not since abort() has been called
     - assert that the completion handler passed to the retrieveBinInfo() method was never called
     */
    func testClientSupportsCancellingRequestInFlightWhenRetrying() {
        serviceStubs.post500(path: "/somewhere", delayInSeconds: 0.2)
            .start()

        var calledCompletionHandler = false

        cardBinApiClient.retrieveBinInfo(cardNumber: visaTestPan, checkoutId: checkoutId) {
            result in
            calledCompletionHandler = true
        }

        // Aborting the request after the 1st attempt has failed with 500
        Thread.sleep(forTimeInterval: 0.3)
        cardBinApiClient.abort()

        // Waiting until the end of any potential future retries
        Thread.sleep(forTimeInterval: 1)
        XCTAssertFalse(calledCompletionHandler)
    }
}
