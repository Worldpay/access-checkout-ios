import AccessCheckoutSDK
import UIKit

class RestrictedCardFlowViewController: UIViewController {
    @IBOutlet weak var panTextField: AccessCheckoutUITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var panIsValidLabel: UILabel!
    
    private let unknownBrandImage = UIImage(named: "card_unknown")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        panTextField.layer.borderWidth = 1
        panTextField.layer.borderColor = UIColor.lightText.cgColor
        panTextField.layer.cornerRadius = 8
        panTextField.backgroundColor = UIColor.white
        panTextField.placeholder = "Card Number"
        
        // Control used as helpers for the automated tests - Start of section
        // Label colour is changed to make it invisible
        panIsValidLabel.textColor = Configuration.backgroundColor
        // Controls used as helpers for the automated tests - End of section
        
        let validationConfig = try! CardValidationConfig.builder().pan(panTextField)
            .expiryDate(AccessCheckoutUITextField(frame: CGRect()))
            .cvc(AccessCheckoutUITextField(frame: CGRect()))
            .accessBaseUrl(Configuration.accessBaseUrl)
            .validationDelegate(self)
            .acceptedCardBrands(["visa", "mastercard", "AMEX"])
            .build()
        
        AccessCheckoutValidationInitialiser().initialise(validationConfig)
        
        panValidChanged(isValid: false)
        cardBrandChanged(cardBrand: nil)
    }
    
    private func updateCardBrandImage(url: URL) {
        DispatchQueue.global(qos: .userInteractive).async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            }
        }
    }
    
    private func changePanValidIndicator(isValid: Bool) {
        panTextField.textColor = isValid ? nil : UIColor.red
    }
}

extension RestrictedCardFlowViewController: AccessCheckoutCardValidationDelegate {
    func cardBrandChanged(cardBrand: CardBrand?) {
        if let imageUrl = cardBrand?.images.filter({ $0.type == "image/png" }).first?.url,
            let url = URL(string: imageUrl) {
            updateCardBrandImage(url: url)
        } else {
            imageView.image = unknownBrandImage
        }
        imageView.accessibilityLabel = NSLocalizedString(cardBrand?.name ?? "unknown_card_brand", comment: "")
    }
    
    func panValidChanged(isValid: Bool) {
        panIsValidLabel.text = isValid ? "valid" : "invalid"
        
        changePanValidIndicator(isValid: isValid)
    }
    
    func cvcValidChanged(isValid: Bool) {}
    
    func expiryDateValidChanged(isValid: Bool) {}
    
    func validationSuccess() {}
}
