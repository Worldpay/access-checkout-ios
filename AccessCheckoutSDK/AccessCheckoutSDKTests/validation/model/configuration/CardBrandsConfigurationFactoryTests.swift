@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class CardBrandsConfigurationFactoryTests: XCTestCase {
    private var serviceStubs: ServiceStubs?
    
    override func setUp() {
        serviceStubs = ServiceStubs()
    }
    
    override func tearDown() {
        serviceStubs?.stop()
    }
    
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
        
        serviceStubs!.get200(path: "/access-checkout/cardTypes.json", jsonResponse: successfulResponse)
            .start()
        
        factory.create(baseUrl: serviceStubs!.baseUrl, acceptedCardBrands: ["amex", "jcb"]) { configuration in
            XCTAssertEqual(1, configuration.allCardBrands.count)
            XCTAssertEqual("visa", configuration.allCardBrands[0].name)
            
            XCTAssertEqual(["amex", "jcb"], configuration.acceptedCardBrands)
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 5)
    }
    
    func testCreatesConfigurationWithBrandsAndAcceptedCardBrands_byRequestingRemoteConfigurationFileForBaseUrlWithTrailingSlash() throws {
        let expectationToFulfill = expectation(description: "")
        serviceStubs!.get200(path: "/access-checkout/cardTypes.json", jsonResponse: successfulResponse)
            .start()
        
        factory.create(baseUrl: serviceStubs!.baseUrl, acceptedCardBrands: ["amex", "jcb"]) { configuration in
            XCTAssertEqual(1, configuration.allCardBrands.count)
            XCTAssertEqual("visa", configuration.allCardBrands[0].name)
            
            XCTAssertEqual(["amex", "jcb"], configuration.acceptedCardBrands)
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 5)
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
        
        factory.create(baseUrl: "http://localhost:9000", acceptedCardBrands: ["amex", "jcb"]) { configuration in
            XCTAssertTrue(configuration.allCardBrands.isEmpty)
            XCTAssertEqual(["amex", "jcb"], configuration.acceptedCardBrands)
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 0.5)
    }
    
    func testCreatesConfigurationWithEmptyBrandsAndAcceptedCardBrandsWhenReceivingErrorInResponse() throws {
        let expectationToFulfill = expectation(description: "")
        serviceStubs!.get400(path: "/access-checkout/cardTypes.json", textResponse: "some invalid response")
            .start()
        
        factory.create(baseUrl: serviceStubs!.baseUrl, acceptedCardBrands: ["amex", "jcb"]) { configuration in
            XCTAssertTrue(configuration.allCardBrands.isEmpty)
            XCTAssertEqual(["amex", "jcb"], configuration.acceptedCardBrands)
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 5)
    }
    
    func createsAnEmptyConfiguration() {
        let expectedConfiguration = CardBrandsConfiguration(allCardBrands: [], acceptedCardBrands: [])
        
        let result = factory.emptyConfiguration()
        
        XCTAssertEqual(expectedConfiguration, result)
    }
}
