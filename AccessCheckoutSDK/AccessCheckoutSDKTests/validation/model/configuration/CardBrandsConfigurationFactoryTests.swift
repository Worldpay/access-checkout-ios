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
        let expectedConfiguration = CardBrandsConfiguration([self.expectedCardBrand])
        
        factory.create(baseUrl: "http://localhost") { configuration in
            XCTAssertEqual(expectedRequest, restClient.requestSent)
            XCTAssertEqual(expectedConfiguration, configuration)
            
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 0.5)
    }
    
    func testCreatesConfigurationWithEmptyBrandsWhenFailingToRetrieveRemoteConfigurationFile() throws {
        let expectationToFulfill = expectation(description: "")
        let restClient = RestClientMock<[CardBrandDto]>(errorWith: AccessCheckoutClientError.unknown(message: ""))
        let factory = CardBrandsConfigurationFactory(restClient, dtoTransformer)
        
        factory.create(baseUrl: "http://localhost") { configuration in
            XCTAssertTrue(configuration.brands.isEmpty)
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 0.5)
    }
    
    func testCreatesConfigurationUsingARemoteConfigurationFileAndBaseUrlWithTrailingSlash() throws {
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
    
    func testCreatesConfigurationUsingARemoteConfigurationFileAndBaseUrlWithoutTrailingSlash() throws {
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
    
    func createsAnEmptyConfiguration() {
        let restClient = RestClient()
        let factory = CardBrandsConfigurationFactory(restClient, dtoTransformer)
        let expectedConfiguration = CardBrandsConfiguration([])
        
        let result = factory.emptyConfiguration()
        
        XCTAssertEqual(expectedConfiguration, result)
    }
    
    static func cardBrandDto() throws -> CardBrandDto {
        let json = "{}"
        
        return try JSONDecoder().decode(CardBrandDto.self, from: json.data(using: .utf8)!)
    }
    
    static func aCardBrand() -> CardBrandModel {
        return CardBrandModel(name: "", images: [],
                              panValidationRule: ValidationRule(matcher: "", validLengths: []),
                              cvvValidationRule: ValidationRule(matcher: "", validLengths: []))
    }
}
