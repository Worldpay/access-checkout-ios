import AccessCheckoutSDK
import UIKit

class RestrictedCardFlowViewController: UIViewController {
    @IBOutlet weak var panTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var panIsValidLabel: UILabel!
    
    private let unknownBrandImage = UIImage(named: "card_unknown")
    private let accessBaseUrl = Bundle.main.infoDictionary?["AccessBaseURL"] as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        panTextField.layer.borderWidth = 1
        panTextField.layer.borderColor = UIColor.lightText.cgColor
        panTextField.layer.cornerRadius = 8
        panTextField.backgroundColor = UIColor.white
        panTextField.placeholder = "Card Number"
        
        panIsValidLabel.font = UIFont.systemFont(ofSize: 0)
        
        let validationConfig = try! CardValidationConfig.builder().pan(panTextField)
            .expiryDate(UITextField())
            .cvc(UITextField())
            .accessBaseUrl(accessBaseUrl)
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
