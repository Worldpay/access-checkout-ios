import Foundation

class SingleLinkDiscoveryFactory {
    func create(toFindLink: String, usingRequest:URLRequest) -> SingleLinkDiscovery {
        return SingleLinkDiscovery(linkToFind: toFindLink, urlRequest: usingRequest)
    }
}
