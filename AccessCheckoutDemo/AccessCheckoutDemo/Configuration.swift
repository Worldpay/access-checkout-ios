import Foundation
import UIKit

struct Configuration {
    static let checkoutId = CI.checkoutId != "" && CI.checkoutId != "$(CHECKOUT_ID)" ? CI.checkoutId : "identity"

    static var accessBaseUrl: String = ""

    static let accessCardConfigurationUrl: String = "\(urlWitoutTrailingSlash(accessBaseUrl))/access-checkout/cardTypes.json"

    static let backgroundColor: UIColor = .init(red: 0.960784, green: 0.960784, blue: 0.960784, alpha: 1)

    private static func urlWitoutTrailingSlash(_ url: String) -> String {
        return url.last == "/" ? String(url.dropLast()) : url
    }
    
    static func resetAccessBaseUrl() {
        if CI.accessBaseUrl != "" && CI.accessBaseUrl != "$(ACCESS_BASE_URL)" {
            accessBaseUrl = CI.accessBaseUrl
        } else {
            accessBaseUrl = Bundle.main.infoDictionary?["AccessBaseURL"] as! String
        }
    }
}
