import AccessCheckoutSDK
import Foundation
import UIKit

final class UiUtils {
    private static let unknownBrandImage = UIImage(named: "card_unknown")!
    private static var cardBrandsImagesCache: [String: CachedImage] = [:]

    public static func updateCardBrandImage(_ imageView: UIImageView, with cardBrand: CardBrand?) {
        if let cardBrand = cardBrand,
            let urlAsString = cardBrand.images.first(where: { $0.type == "image/png" })?.url,
            let url = URL(string: urlAsString)
        {
            if let cachedImage = cardBrandsImagesCache[urlAsString] {
                setImageSourceAndLabel(
                    imageView, source: UIImage(data: cachedImage.uiImage)!, label: cachedImage.label
                )
            } else {
                // User interactive QOS is chosen to make the task below a high priority task
                // This contributes strongly to seeing updates to the UI made faster
                let serialQueue = DispatchQueue(
                    label: "worldpay.demo.uiutils", qos: .userInteractive)
                serialQueue.async {
                    if let data = try? Data(contentsOf: url) {
                        let cachedImage = CachedImage(uiImage: data, label: cardBrand.name)
                        cardBrandsImagesCache[urlAsString] = cachedImage

                        DispatchQueue.main.async {
                            setImageSourceAndLabel(
                                imageView, source: UIImage(data: cachedImage.uiImage)!,
                                label: cachedImage.label)
                        }
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                setImageSourceAndLabel(
                    imageView, source: unknownBrandImage, label: "unknown_card_brand")

                imageView.image = unknownBrandImage
                imageView.accessibilityLabel = NSLocalizedString("unknown_card_brand", comment: "")
            }
        }
    }

    private static func setImageSourceAndLabel(
        _ imageView: UIImageView, source: UIImage, label: String
    ) {
        DispatchQueue.main.async {
            imageView.image = source
            imageView.accessibilityLabel = NSLocalizedString(label, comment: "")
        }
    }

    private struct CachedImage {
        fileprivate let uiImage: Data
        fileprivate let label: String
    }
}
