import Cuckoo
import XCTest

@testable import AccessCheckoutSDK

class RetrieveSessionHandlerDispatcherTests: XCTestCase {
    let checkoutId = "123"
    let baseUrl = "some-url"

    let cardDetails = try! CardDetailsBuilder()
        .cvc(UIUtils.createAccessCheckoutUITextField(withText: "123"))
        .build()

    let paymentsCvcSessionHandler = PaymentsCvcRetrieveSessionHandlerMock()
    let cardSessionHandler = RetrieveCardSessionHandlerMock()

    func testDispatchesToRetrieveACardSession() {
        let dispatcher = RetrieveSessionHandlerDispatcher(retrieveSessionHandlers: [
            paymentsCvcSessionHandler, cardSessionHandler,
        ])

        dispatcher.dispatch(checkoutId, baseUrl, cardDetails, SessionType.card) { _ in }

        XCTAssertTrue(cardSessionHandler.retrieveSessionCalled)
        XCTAssertFalse(paymentsCvcSessionHandler.retrieveSessionCalled)
    }

    func testDispatchesToRetrieveAPaymentsCvcSession() {
        let dispatcher = RetrieveSessionHandlerDispatcher(retrieveSessionHandlers: [
            paymentsCvcSessionHandler, cardSessionHandler,
        ])

        dispatcher.dispatch(checkoutId, baseUrl, cardDetails, SessionType.cvc) { _ in }

        XCTAssertFalse(cardSessionHandler.retrieveSessionCalled)
        XCTAssertTrue(paymentsCvcSessionHandler.retrieveSessionCalled)
    }
}
