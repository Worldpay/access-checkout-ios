@testable import AccessCheckoutSDK

class BundleMock: Bundle {
    static let appVersion = "3.2.9"
    override func object(forInfoDictionaryKey key: String) -> Any? {
        if key == "CFBundleShortVersionString" {
            return BundleMock.appVersion
        } else {
            return super.object(forInfoDictionaryKey: key)
        }
    }
}