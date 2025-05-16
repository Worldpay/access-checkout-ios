import AccessCheckoutSDK
import UIKit

class RestrictedCardFlowViewController: UIViewController {
    @IBOutlet weak var panTextField: AccessCheckoutUITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var panIsValidLabel: UILabel!
    @IBOutlet weak var dismissKeyboardButton: UIButton!

    @IBAction func onDismissKeyboardTap(_ sender: Any) {
        _ = panTextField.resignFirstResponder()
    }

    private let unknownBrandImage = UIImage(named: "card_unknown")

    override func viewDidLoad() {
        super.viewDidLoad()

        // We show the button if the configuration indicates to show it
        // This configuration property is only ever set up to true
        // wheh a specific launch argument is set to true
        // See AppLauncher in the AccessCheckoutDemoUITests
        self.dismissKeyboardButton.isHidden = !Configuration.displayDismissKeyboardButton

        panTextField.placeholder = "Card Number"
        panTextField.font = .preferredFont(forTextStyle: .body)
        
        //Apply onfocus listeners
        panTextField.setOnFocusChangedListener{view, hasFocus in
            if #available(iOS 13.0, *) {
                view.borderColor = hasFocus ? .systemBlue : .systemGray5
            } else {
                view.borderColor = hasFocus ? .systemBlue : .systemGray
            }
        }
        
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
        panTextField.textColor =
            isValid ? Configuration.validCardDetailsColor : Configuration.invalidCardDetailsColor
    }
}

extension RestrictedCardFlowViewController: AccessCheckoutCardValidationDelegate {
    func cardBrandChanged(cardBrand: CardBrand?) {
        if let imageUrl = cardBrand?.images.filter({ $0.type == "image/png" }).first?.url,
            let url = URL(string: imageUrl)
        {
            updateCardBrandImage(url: url)
        } else {
            imageView.image = unknownBrandImage
        }
        imageView.accessibilityLabel = NSLocalizedString(
            cardBrand?.name ?? "unknown_card_brand", comment: "")
    }

    func panValidChanged(isValid: Bool) {
        panIsValidLabel.text = isValid ? "valid" : "invalid"

        changePanValidIndicator(isValid: isValid)
    }

    func cvcValidChanged(isValid: Bool) {}

    func expiryDateValidChanged(isValid: Bool) {}

    func validationSuccess() {}
}
