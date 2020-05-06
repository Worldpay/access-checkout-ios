@testable import AccessCheckoutSDK
import PromiseKit

class SingleLinkDiscoveryMock : SingleLinkDiscovery {
    private var promiseToReturn:Promise<String>?
    
    init() {
        super.init(linkToFind: "", urlRequest: URLRequest(url: URL(string: "http://localhost")!))
    }
    
    override func discover() -> Promise<String> {
        return promiseToReturn!
    }
    
    func willReturn(_ promise:Promise<String>) {
        self.promiseToReturn = promise
    }
}
