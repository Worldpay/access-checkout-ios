import Foundation
import UIKit

public struct Configuration {
    private static var _accessBaseUrl: String = ""
    
    static func initialize(disableStubs:Bool) {
        if disableStubs {
            _accessBaseUrl = ServiceStubs.baseUri
        } else {
            _accessBaseUrl = Bundle.main.infoDictionary?["AccessBaseURL"] as! String
        }
    }
    
    static let merchantId = CI.merchantId != "" && CI.merchantId != "$(MERCHANT_ID)" ? CI.merchantId : "identity"

    static let accessBaseUrl: String = Bundle.main.infoDictionary?["AccessBaseURL"] as! String

    static let accessCardConfigurationUrl: String = "\(urlWitoutTrailingSlash(accessBaseUrl))/access-checkout/cardTypes.json"

    static let backgroundColor:UIColor = UIColor(red:0.960784, green: 0.960784, blue: 0.960784, alpha: 1)

    private static func urlWitoutTrailingSlash(_ url: String) -> String {
        return url.last == "/" ? String(url.dropLast()) : url
    }
}
