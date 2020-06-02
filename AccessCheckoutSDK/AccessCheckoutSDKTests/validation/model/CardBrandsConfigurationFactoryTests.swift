@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class CardBrandsConfigurationFactoryTests: XCTestCase {
    let dtoTransformer = MockCardBrandDtoTransformer()
    let dtoCardBrand = try! cardBrandDto()
    let expectedCardBrand = aCardBrand()
    
    override func setUp() {
        dtoTransformer.getStubbingProxy().transform(dtoCardBrand).thenReturn(expectedCardBrand)
    }
    
    func testCreatesConfigurationUsingARemoteConfigurationFile() throws {
        let expectationToFulfill = expectation(description: "")
        let restClient = RestClientMock(replyWith: [dtoCardBrand])
        let factory = CardBrandsConfigurationFactory(restClient, dtoTransformer)
        let expectedRequest = URLRequest(url: URL(string: "http://localhost/access-checkout/cardTypes.json")!)
        
        factory.create(baseUrl: "http://localhost") { configuration in
            XCTAssertEqual(expectedRequest, restClient.requestSent)
            
            XCTAssertEqual([self.expectedCardBrand], configuration.brands)
            XCTAssertNotNil(configuration.validationRulesDefaults)
            
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 0.5)
    }
    
    func testCreatesConfigurationWithOnlyDefaultsWhenFailingToRetrieveRemoteConfigurationFile() throws {
        let expectationToFulfill = expectation(description: "")
        let restClient = RestClientMock<[CardBrandDto]>(errorWith: AccessCheckoutClientError.unknown(message: ""))
        let factory = CardBrandsConfigurationFactory(restClient, dtoTransformer)
        
        factory.create(baseUrl: "http://localhost") { configuration in
            XCTAssertTrue(configuration.brands.isEmpty)
            XCTAssertNotNil(configuration.validationRulesDefaults)
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 0.5)
    }
    
    func testSupportsBaseUrlWithTrailingSlash() throws {
        let restClient = RestClientMock(replyWith: [dtoCardBrand])
        let factory = CardBrandsConfigurationFactory(restClient, dtoTransformer)
        let expectationToFulfill = expectation(description: "")
        let expectedRequest = URLRequest(url: URL(string: "http://localhost/access-checkout/cardTypes.json")!)
        
        factory.create(baseUrl: "http://localhost/") { _ in
            XCTAssertEqual(expectedRequest, restClient.requestSent)
            
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 0.5)
    }
    
    func testSupportsBaseUrlWithoutTrailingSlash() throws {
        let restClient = RestClientMock(replyWith: [dtoCardBrand])
        let factory = CardBrandsConfigurationFactory(restClient, dtoTransformer)
        let expectationToFulfill = expectation(description: "")
        let expectedRequest = URLRequest(url: URL(string: "http://localhost/access-checkout/cardTypes.json")!)
        
        factory.create(baseUrl: "http://localhost") { _ in
            XCTAssertEqual(expectedRequest, restClient.requestSent)
            
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 0.5)
    }
    
    static func cardBrandDto() throws -> CardBrandDto {
        let json = """
        {
            "name": "visa",
            "pattern": "a-pattern",
            "panLengths": [
                16,
                18,
                19
            ],
            "cvvLength": 3,
            "images": [
                {
                    "type": "image/png",
                    "url": "png-url"
                }
            ]
        }
        """
        
        return try JSONDecoder().decode(CardBrandDto.self, from: json.data(using: .utf8)!)
    }
    
    static func aCardBrand() -> CardBrand2 {
        return CardBrand2(name: "", images: [],
                          panValidationRule: ValidationRule(matcher: "", validLengths: []),
                          cvvValidationRule: ValidationRule(matcher: "", validLengths: []))
    }
}
