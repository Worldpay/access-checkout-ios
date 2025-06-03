import XCTest

@testable import AccessCheckoutSDK

class AccessCheckoutErrorTests: XCTestCase {
    func testSuccessfullyDecodesAnAccessCheckoutError() throws {
        let expectedErrorName = "root error name"
        let message = "root error message"
        let expectedMessage = "\(expectedErrorName) : \(message)"

        let expectedValidationError1ErrorName = "validation error 1"
        let expectedValidationError1Message = "validation error 1 message"
        let expectedValidationError1JsonPath = "validation error 1 json path"

        let expectedValidationError2ErrorName = "validation error 2"
        let expectedValidationError2Message = "validation error 2 message"
        let expectedValidationError2JsonPath = "validation error 2 json path"

        let errorAsJsonString = """
            {
                "errorName": "\(expectedErrorName)",
                "message": "\(message)",
                "validationErrors": [
                    {
                        "errorName": "\(expectedValidationError1ErrorName)",
                        "message": "\(expectedValidationError1Message)",
                        "jsonPath": "\(expectedValidationError1JsonPath)"
                    },
                    {
                        "errorName": "\(expectedValidationError2ErrorName)",
                        "message": "\(expectedValidationError2Message)",
                        "jsonPath": "\(expectedValidationError2JsonPath)"
                    }
                ]
            }
            """

        let error = try decode(errorAsJsonString, into: AccessCheckoutError.self)

        XCTAssertEqual(expectedMessage, error.message)

        XCTAssertEqual(2, error.validationErrors.count)

        XCTAssertEqual(expectedValidationError1ErrorName, error.validationErrors[0].errorName)
        XCTAssertEqual(expectedValidationError1Message, error.validationErrors[0].message)
        XCTAssertEqual(expectedValidationError1JsonPath, error.validationErrors[0].jsonPath)

        XCTAssertEqual(expectedValidationError2ErrorName, error.validationErrors[1].errorName)
        XCTAssertEqual(expectedValidationError2Message, error.validationErrors[1].message)
        XCTAssertEqual(expectedValidationError2JsonPath, error.validationErrors[1].jsonPath)
    }

    private func decode<T: Decodable>(_ json: String, into: T.Type) throws -> T {
        let data = json.data(using: .utf8)!

        return try JSONDecoder().decode(T.self, from: data)
    }
}
