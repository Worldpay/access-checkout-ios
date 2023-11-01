import Foundation
import UIKit

struct Configuration {
    static var _accessBaseUrl: String = ""

    static let merchantId = CI.merchantId != "" && CI.merchantId != "$(MERCHANT_ID)" ? CI.merchantId : "identity"

    static var accessBaseUrl: String = ""

    static let accessCardConfigurationUrl: String = "\(urlWitoutTrailingSlash(accessBaseUrl))/access-checkout/cardTypes.json"

    static let backgroundColor: UIColor = .init(red: 0.960784, green: 0.960784, blue: 0.960784, alpha: 1)

    private static func urlWitoutTrailingSlash(_ url: String) -> String {
        return url.last == "/" ? String(url.dropLast()) : url
    }
}
