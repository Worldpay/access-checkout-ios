import XCTest

@testable import AccessCheckoutSDK

class SingleLinkDiscoveryFactoryTests: XCTestCase {
    func testCreatesASingleLinkDiscovery() {
        let urlRequest = URLRequest(url: URL(string: "http://localshot")!)
        let linkToFind = "a-link"
        let factory = SingleLinkDiscoveryFactory()

        let result: SingleLinkDiscovery = factory.create(
            toFindLink: linkToFind, usingRequest: urlRequest)

        XCTAssertEqual(linkToFind, result.linkToFind)
        XCTAssertEqual(urlRequest, result.urlRequest)
    }
}
