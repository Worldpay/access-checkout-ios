import AccessCheckoutSDK
import Foundation
import UIKit

final class UiUtils {
    private static let unknownBrandImage = UIImage(named: "card_unknown")

    public static func updateCardBrandImage(_ imageView: UIImageView, with cardBrand: CardBrand?) {
        if let cardBrand = cardBrand,
            let imageUrl = cardBrand.images.first(where: { $0.type == "image/png" })?.url,
            let url = URL(string: imageUrl)
        {
            // User interactive QOS is chosen to make the task below a high priority task
            // This contributes strongly to seeing updates to the UI made faster
            let serialQueue = DispatchQueue(label: "worldpay.demo.uiutils", qos: .userInteractive)
            serialQueue.async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        imageView.image = UIImage(data: data)
                        imageView.accessibilityLabel = NSLocalizedString(cardBrand.name, comment: "")
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                imageView.image = unknownBrandImage
                imageView.accessibilityLabel = NSLocalizedString("unknown_card_brand", comment: "")
            }
        }
    }
}
