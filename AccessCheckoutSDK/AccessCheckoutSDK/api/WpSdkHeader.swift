import Foundation

public struct WpSdkHeader {
    static let sdkVersion = "4.0.0"
    static private let valueFormat = "access-checkout-ios/%@"
    
    static let name = "X-WP-SDK"
    
    static let defaultValue = String(format: valueFormat, WpSdkHeader.sdkVersion)
    private static var _value = defaultValue
    static var value:String {
        get {
            return _value
        }
    }
    
    public static func overrideValue(with newValue:String) throws {
        if !validateVersionForOverride(untrustedVersion: newValue) {
            throw WpSdkHeaderValueError.invalidVersion()
        }
        
        _value = newValue
    }
    
    private static func validateVersionForOverride(untrustedVersion:String) -> Bool{
        if untrustedVersion == defaultValue {
            return true
        }
        
        let regExPattern: String = "access\\-checkout\\-react\\-native\\/[0-9]{1,2}\\.[0-9]{1,2}\\.[0-9]{1,2}"
        let regex = try! NSRegularExpression(pattern: regExPattern)
        
        return regex.firstMatch(in: untrustedVersion, range: NSRange(location: 0, length: untrustedVersion.count)) != nil
    }
}

struct WpSdkHeaderValueError : Error, Equatable {
    private static let invalidVersionErrorMessage = "Unsupported version format. This functionality only supports access-checkout-react-native semantic versions or default access-checkout-ios version."

    let message: String
    
    private init(message:String) {
        self.message = message
    }
    
    static func invalidVersion() -> WpSdkHeaderValueError {
        return WpSdkHeaderValueError(message: invalidVersionErrorMessage)
    }
}
