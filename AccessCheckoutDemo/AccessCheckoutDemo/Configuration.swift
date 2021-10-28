import Foundation

public struct Configuration {
    static let merchantId = CI.merchantId != "" && CI.merchantId != "$(MERCHANT_ID)" ? CI.merchantId : "identity"

    static let accessBaseUrl: String = Bundle.main.infoDictionary?["AccessBaseURL"] as! String

    static let accessCardConfigurationUrl: String = "\(urlWitoutTrailingSlash(accessBaseUrl))/access-checkout/cardTypes.json"

    private static func urlWitoutTrailingSlash(_ url: String) -> String {
        return url.last == "/" ? String(url.dropLast()) : url
    }
}
