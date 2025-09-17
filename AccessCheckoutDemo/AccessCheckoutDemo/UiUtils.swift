import AccessCheckoutSDK
import Foundation
import UIKit

final class UiUtils {
    private static let unknownBrandImage = UIImage(named: "card_unknown")!
    private static var cardBrandsImagesCache: [String: CachedImage] = [:]

    // This function and the one below are designed to assert the card brand displayed in the UI
    // and use a retry mechanism to cater for what appears to be the slowness of BitRise
    public static func updateCardBrandImage(_ imageView: UIImageView, using cardBrands: [CardBrand])
    {
        if !cardBrands.isEmpty,
            let cardBrand = cardBrands.first,
            let urlAsString = cardBrand.images.first(where: { $0.type == "image/png" })?.url,
            let url = URL(string: urlAsString)
        {
            if let cachedImage = cardBrandsImagesCache[urlAsString] {
                setImageSourceAndLabel(
                    imageView, uiImage: UIImage(data: cachedImage.data)!, label: cachedImage.label
                )
            } else {
                // User interactive QOS is chosen to make the task below a high priority task
                // This contributes strongly to seeing updates to the UI made faster
                let serialQueue = DispatchQueue(
                    label: "worldpay.demo.uiutils", qos: .userInteractive)
                serialQueue.async {
                    if let data = try? Data(contentsOf: url) {
                        let cachedImage = CachedImage(data: data, label: cardBrand.name)
                        cardBrandsImagesCache[urlAsString] = cachedImage

                        setImageSourceAndLabel(
                            imageView, uiImage: UIImage(data: cachedImage.data)!,
                            label: cachedImage.label
                        )
                    }
                }
            }
        } else {
            setImageSourceAndLabel(
                imageView, uiImage: unknownBrandImage, label: "unknown_card_brand")
        }
    }

    private static func setImageSourceAndLabel(
        _ imageView: UIImageView, uiImage: UIImage, label: String
    ) {
        DispatchQueue.main.async {
            imageView.image = uiImage
            imageView.accessibilityLabel = NSLocalizedString(label, comment: "")
        }
    }

    private struct CachedImage {
        fileprivate let data: Data
        fileprivate let label: String
    }
}
