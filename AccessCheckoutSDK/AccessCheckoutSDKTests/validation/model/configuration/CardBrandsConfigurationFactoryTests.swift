@testable import AccessCheckoutSDK
import Cuckoo
import Mockingjay
import XCTest

class CardBrandsConfigurationFactoryTests: XCTestCase {
    private let successfulResponse = """
    [{
        "name": "visa",
        "pattern": "a-pattern",
        "panLengths": [3],
        "cvvLength": 3,
        "images": []
    
    }]
    """
    private let factory = CardBrandsConfigurationFactory(RestClient(), CardBrandDtoTransformer())
    
    func testCreatesConfigurationWithBrandsAndAcceptedCardBrands_byRequestingRemoteConfigurationFileForBaseUrlWithoutTrailingSlash() throws {
        let expectationToFulfill = expectation(description: "")
        stubResponse(forUrl: "http://localhost/access-checkout/cardTypes.json", response: successfulResponse, status: 200)
        
        factory.create(baseUrl: "http://localhost", acceptedCardBrands: ["amex", "jcb"]) { configuration in
            XCTAssertEqual(1, configuration.allCardBrands.count)
            XCTAssertEqual("visa", configuration.allCardBrands[0].name)
            
            XCTAssertEqual(["amex", "jcb"], configuration.acceptedCardBrands)
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 0.5)
    }
    
    func testCreatesConfigurationWithBrandsAndAcceptedCardBrands_byRequestingRemoteConfigurationFileForBaseUrlWithTrailingSlash() throws {
        let expectationToFulfill = expectation(description: "")
        stubResponse(forUrl: "http://localhost/access-checkout/cardTypes.json", response: successfulResponse, status: 200)
        
        factory.create(baseUrl: "http://localhost/", acceptedCardBrands: ["amex", "jcb"]) { configuration in
            XCTAssertEqual(1, configuration.allCardBrands.count)
            XCTAssertEqual("visa", configuration.allCardBrands[0].name)
            
            XCTAssertEqual(["amex", "jcb"], configuration.acceptedCardBrands)
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 0.5)
    }
    
    func testCreatesConfigurationWithEmptyBrandsAndAcceptedCardBrandsWhenInvalidUrlIsPassed() throws {
        let expectationToFulfill = expectation(description: "")
        
        factory.create(baseUrl: "some invalid URL", acceptedCardBrands: ["amex", "jcb"]) { configuration in
            XCTAssertTrue(configuration.allCardBrands.isEmpty)
            XCTAssertEqual(["amex", "jcb"], configuration.acceptedCardBrands)
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 2)
    }
    
    func testCreatesConfigurationWithEmptyBrandsAndAcceptedCardBrandsWhenFailingToConnectToUrl() throws {
        let expectationToFulfill = expectation(description: "")
        
        factory.create(baseUrl: "http://localhost", acceptedCardBrands: ["amex", "jcb"]) { configuration in
            XCTAssertTrue(configuration.allCardBrands.isEmpty)
            XCTAssertEqual(["amex", "jcb"], configuration.acceptedCardBrands)
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 0.5)
    }
    
    func testCreatesConfigurationWithEmptyBrandsAndAcceptedCardBrandsWhenReceivingErrorInResponse() throws {
        let expectationToFulfill = expectation(description: "")
        stubResponse(forUrl: "http://localhost/access-checkout/cardTypes.json", response: "some invalid response", status: 400)
        
        factory.create(baseUrl: "http://localhost", acceptedCardBrands: ["amex", "jcb"]) { configuration in
            XCTAssertTrue(configuration.allCardBrands.isEmpty)
            XCTAssertEqual(["amex", "jcb"], configuration.acceptedCardBrands)
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 0.5)
    }
    
    func createsAnEmptyConfiguration() {
        let expectedConfiguration = CardBrandsConfiguration(allCardBrands: [], acceptedCardBrands: [])
        
        let result = factory.emptyConfiguration()
        
        XCTAssertEqual(expectedConfiguration, result)
    }
    
    private func stubResponse(forUrl url: String, response: String, status: Int) {
        let data = response.data(using: .utf8)!
        
        stub(http(.get, uri: url), jsonData(data, status: status))
    }
}
