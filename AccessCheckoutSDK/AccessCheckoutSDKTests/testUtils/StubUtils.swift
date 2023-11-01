@testable import AccessCheckoutSDK
import Swifter
import XCTest

class StubUtils {
    static func createError(errorName: String, message: String) -> AccessCheckoutError {
        let json = """
        {
            "errorName": "\(errorName)",
            "message": "\(message)"
        }
        """
        
        let jsonAsData = json.data(using: .utf8)!
        return try! JSONDecoder().decode(AccessCheckoutError.self, from: jsonAsData)
    }
    
    static func parseAccessCheckoutError(json: String) -> AccessCheckoutError {
        let jsonAsData = json.data(using: .utf8)!
        return try! JSONDecoder().decode(AccessCheckoutError.self, from: jsonAsData)
    }
    
    static func createApiValidationError(errorName: String, message: String, jsonPath: String) -> AccessCheckoutError.AccessCheckoutValidationError {
        let json = """
        {
            "errorName": "\(errorName)",
            "message": "\(message)",
            "jsonPath": "\(jsonPath)"
        }
        """
        
        let jsonAsData = json.data(using: .utf8)!
        return try! JSONDecoder().decode(AccessCheckoutError.AccessCheckoutValidationError.self, from: jsonAsData)
    }
    
    static func createApiError(errorName: String, message: String, validationErrors: [AccessCheckoutError.AccessCheckoutValidationError]) -> AccessCheckoutError {
        var validationErrorsJson = [String]()
        
        for error in validationErrors {
            let jsonError = """
            {
                "errorName": "\(error.errorName)",
                "message": "\(error.message)",
                "jsonPath": "\(error.jsonPath)"
            }
            """
            validationErrorsJson.append(jsonError)
        }
        
        let json = """
        {
            "errorName": "\(errorName)",
            "message": "\(message)",
            "validationErrors" : [\(validationErrorsJson.joined(separator: ","))]
        }
        """
        
        let jsonAsData = json.data(using: .utf8)!
        return try! JSONDecoder().decode(AccessCheckoutError.self, from: jsonAsData)
    }
}
