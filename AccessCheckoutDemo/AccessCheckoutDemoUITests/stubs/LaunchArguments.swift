import Foundation

struct LaunchArguments {
    static let CardConfigurationStub = "stubCardConfiguration"

    static let AccessServicesRootStub = "stubAccessServicesRoot"
    static let SessionsRootStub = "stubSessionsRoot"
    static let SessionsCardStub = "stubSessionsCard"
    static let SessionsPaymentsCvcStub = "stubSessionsPaymentsCvc"
    static let EnableStubs = "enableStubs"
    
    static func valueOf(_ argumentName:String) -> String? {
        return UserDefaults.standard.string(forKey: argumentName)
    }
}
