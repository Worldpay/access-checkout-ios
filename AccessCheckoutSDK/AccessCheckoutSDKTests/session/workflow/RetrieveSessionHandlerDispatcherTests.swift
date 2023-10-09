@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class RetrieveSessionHandlerDispatcherTests: XCTestCase {
    let merchantId = "123"
    let baseUrl = "some-url"
    
    let cardDetails = try! CardDetailsBuilder()
        .cvc(UIUtils.createAccessCheckoutUITextField(withText: "123"))
        .build()
    
    let paymentsCvcSessionHandler = PaymentsCvcRetrieveSessionHandlerMock()
    let verifiedTokensSessionHandler = VerifiedTokensRetrieveSessionHandlerMock()
    
    func testDispatchesToRetrieveAVerifiedTokensSession() {
        let dispatcher = RetrieveSessionHandlerDispatcher(retrieveSessionHandlers: [paymentsCvcSessionHandler, verifiedTokensSessionHandler])
        
        dispatcher.dispatch(merchantId, baseUrl, cardDetails, SessionType.card) { _ in }
        
        XCTAssertTrue(verifiedTokensSessionHandler.retrieveSessionCalled)
        XCTAssertFalse(paymentsCvcSessionHandler.retrieveSessionCalled)
    }
    
    func testDispatchesToRetrieveAPaymentsCvcSession() {
        let dispatcher = RetrieveSessionHandlerDispatcher(retrieveSessionHandlers: [paymentsCvcSessionHandler, verifiedTokensSessionHandler])
        
        dispatcher.dispatch(merchantId, baseUrl, cardDetails, SessionType.cvc) { _ in }
        
        XCTAssertFalse(verifiedTokensSessionHandler.retrieveSessionCalled)
        XCTAssertTrue(paymentsCvcSessionHandler.retrieveSessionCalled)
    }
}
