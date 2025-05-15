import Foundation
import UIKit

struct Configuration {
    static let checkoutId =
        CI.checkoutId != "" && CI.checkoutId != "$(CHECKOUT_ID)"
        ? CI.checkoutId : Bundle.main.infoDictionary?["AccessCheckoutId"] as! String

    static var accessBaseUrl: String = ""
    // Property used to display a button used to dismiss the keyboard
    // and remove the focus from the component where the focus dismiss
    // See AppLauncher in the AccessCheckoutDemoUITests
    static var displayDismissKeyboardButton: Bool = false

    static let accessCardConfigurationUrl: String =
        "\(urlWitoutTrailingSlash(accessBaseUrl))/access-checkout/cardTypes.json"

    static let backgroundColor: UIColor = .init(
        red: 0.960784,
        green: 0.960784,
        blue: 0.960784,
        alpha: 1
    )
    static let validCardDetailsColor: UIColor = .init(
        red: 0.44313,
        green: 0.59607,
        blue: 0.17254,
        alpha: 1
    )
    static let invalidCardDetailsColor: UIColor = .red

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
