import Foundation
import UIKit

struct Configuration {
    static var _accessBaseUrl: String = ""
    
//    static func initialize(disableStubs:Bool) {
//        if disableStubs {
//            _accessBaseUrl = Bundle.main.infoDictionary?["AccessBaseURL"] as! String
//        } else {
//            _accessBaseUrl = "http://localhost:8123"
//        }
//    }
    
    static let merchantId = CI.merchantId != "" && CI.merchantId != "$(MERCHANT_ID)" ? CI.merchantId : "identity"

    static var accessBaseUrl: String = ""

    static let accessCardConfigurationUrl: String = "\(urlWitoutTrailingSlash(accessBaseUrl))/access-checkout/cardTypes.json"

    static let backgroundColor:UIColor = UIColor(red:0.960784, green: 0.960784, blue: 0.960784, alpha: 1)

    private static func urlWitoutTrailingSlash(_ url: String) -> String {
        return url.last == "/" ? String(url.dropLast()) : url
    }
}
