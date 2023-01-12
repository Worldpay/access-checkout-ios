import Foundation

public struct UserAgent {
    static let sdkVersion = "2.4.0"
    static private let valueFormat = "access-checkout-ios/%@"
    
    static let headerName = "X-WP-SDK"
    
    static let defaultHeaderValue = String(format: valueFormat, UserAgent.sdkVersion)
    private static var _headerValue = defaultHeaderValue
    static var headerValue:String {
        get {
            return _headerValue
        }
    }
    
    public static func overrideHeaderValue(with value:String) throws {
        if !validateVersionForOverride(untrustedVersion: value) {
            throw UserAgentError.invalidVersion()
        }
        
        _headerValue = value
    }
    
    private static func validateVersionForOverride(untrustedVersion:String) -> Bool{
        if untrustedVersion == defaultHeaderValue {
            return true
        }
        
        let regExPattern: String = "access\\-checkout\\-react\\-native\\/[0-9]{1,2}\\.[0-9]{1,2}\\.[0-9]{1,2}"
        let regex = try! NSRegularExpression(pattern: regExPattern)
        
        return regex.firstMatch(in: untrustedVersion, range: NSRange(location: 0, length: untrustedVersion.count)) != nil
    }
}

struct UserAgentError : Error, Equatable {
    private static let invalidVersionErrorMessage = "Unsupported version format. This functionality only supports access-checkout-react-native semantic versions or default access-checkout-ios version."

    let message: String
    
    private init(message:String) {
        self.message = message
    }
    
    static func invalidVersion() -> UserAgentError {
        return UserAgentError(message: invalidVersionErrorMessage)
    }
}
