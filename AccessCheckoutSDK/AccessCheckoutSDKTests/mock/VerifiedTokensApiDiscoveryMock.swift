@testable import AccessCheckoutSDK
import PromiseKit

class VerifiedTokensApiDiscoveryMock : VerifiedTokensApiDiscovery {
    private var promiseToReturn:Promise<String>?
    
    override func discover(baseUrl: String) -> Promise<String> {
        return promiseToReturn!
    }
    
    func willReturn(_ promise:Promise<String>) {
        self.promiseToReturn = promise
    }
}
