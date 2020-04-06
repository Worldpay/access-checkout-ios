import Foundation

struct LaunchArguments {
    static let DiscoveryStub = "stubDiscovery"
    static let VerifiedTokensStub = "stubVerifiedTokens"
    static let VerifiedTokensSessionStub = "stubVerifiedTokensSession"
    static let CardConfigurationStub = "stubCardConfiguration"
    
    static func valueOf(_ argumentName:String) -> String? {
        return UserDefaults.standard.string(forKey: argumentName)
    }
}
