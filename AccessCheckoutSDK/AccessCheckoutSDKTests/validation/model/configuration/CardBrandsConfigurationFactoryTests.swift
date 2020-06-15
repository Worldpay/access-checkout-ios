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
    
    func testCreatesConfigurationByRequestingRemoteConfigurationFileForBaseUrlWithoutTrailingSlash() throws {
        let expectationToFulfill = expectation(description: "")
        stubResponse(forUrl: "http://localhost/access-checkout/cardTypes.json", response: successfulResponse, status: 200)
        
        factory.create(baseUrl: "http://localhost") { configuration in
            XCTAssertEqual(1, configuration.brands.count)
            XCTAssertEqual("visa", configuration.brands[0].name)
            
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 0.5)
    }
    
    func testCreatesConfigurationByRequestingRemoteConfigurationFileForBaseUrlWithTrailingSlash() throws {
        let expectationToFulfill = expectation(description: "")
        stubResponse(forUrl: "http://localhost/access-checkout/cardTypes.json", response: successfulResponse, status: 200)
        
        factory.create(baseUrl: "http://localhost/") { configuration in
            XCTAssertEqual(1, configuration.brands.count)
            XCTAssertEqual("visa", configuration.brands[0].name)
            
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 0.5)
    }
    
    func testCreatesConfigurationWithEmptyBrandsWhenInvalidUrlIsPassed() throws {
        let expectationToFulfill = expectation(description: "")
        
        factory.create(baseUrl: "some invalid URL") { configuration in
            XCTAssertTrue(configuration.brands.isEmpty)
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 2)
    }
    
    func testCreatesConfigurationWithEmptyBrandsWhenFailingToConnectToUrl() throws {
        let expectationToFulfill = expectation(description: "")
        
        factory.create(baseUrl: "http://localhost") { configuration in
            XCTAssertTrue(configuration.brands.isEmpty)
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 0.5)
    }
    
    func testCreatesConfigurationWithEmptyBrandsWhenReceivingErrorInResponse() throws {
        let expectationToFulfill = expectation(description: "")
        stubResponse(forUrl: "http://localhost/access-checkout/cardTypes.json", response: "some invalid response", status: 400)
        
        factory.create(baseUrl: "http://localhost") { configuration in
            XCTAssertTrue(configuration.brands.isEmpty)
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 0.5)
    }
    
    func createsAnEmptyConfiguration() {
        let expectedConfiguration = CardBrandsConfiguration([])
        
        let result = factory.emptyConfiguration()
        
        XCTAssertEqual(expectedConfiguration, result)
    }
    
    private func stubResponse(forUrl url: String, response: String, status: Int) {
        let data = response.data(using: .utf8)!
        
        stub(http(.get, uri: url), jsonData(data, status: status))
    }
}
