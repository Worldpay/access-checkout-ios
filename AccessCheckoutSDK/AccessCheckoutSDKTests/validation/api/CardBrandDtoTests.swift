@testable import AccessCheckoutSDK
import XCTest

class AccessCheckoutSDKTests: XCTestCase {
    func testIsDeserialisedSuccessfully() throws {
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
                },
                {
                    "type": "image/svg+xml",
                    "url": "svg-url"
                }
            ]
        }
        """
        let decoder = JSONDecoder()
        let jsonData = json.data(using: .utf8)
        
        let result = try decoder.decode(CardBrandDto.self, from: jsonData!)
        
        XCTAssertEqual("visa", result.name)
        XCTAssertEqual("a-pattern", result.pattern)
        XCTAssertEqual([16, 18, 19], result.panLengths)
        XCTAssertEqual(3, result.cvvLength)
        
        XCTAssertEqual(result.images[0].type, "image/png")
        XCTAssertEqual(result.images[0].url, "png-url")
        
        XCTAssertEqual(result.images[1].type, "image/svg+xml")
        XCTAssertEqual(result.images[1].url, "svg-url")
    }
    
    func testIsDeserialisedSuccessfullyWhenFieldsAreMissing() throws {
        let json = """
        { }
        """
        let decoder = JSONDecoder()
        let jsonData = json.data(using: .utf8)
        
        let result = try decoder.decode(CardBrandDto.self, from: jsonData!)
        
        XCTAssertEqual("", result.name)
        XCTAssertEqual("", result.pattern)
        XCTAssertEqual([], result.panLengths)
        XCTAssertEqual(0, result.cvvLength)
        XCTAssertEqual([], result.images)
    }
}
