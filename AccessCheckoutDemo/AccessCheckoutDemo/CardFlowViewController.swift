import AccessCheckoutSDK
import UIKit

class CardFlowViewController: UIViewController {
    @IBOutlet weak var panView: PanView!
    @IBOutlet weak var expiryDateView: ExpiryDateView!
    @IBOutlet weak var cvcView: CvcView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var paymentsCvcSessionToggle: UISwitch!
    
    private let unknownBrandImage = UIImage(named: "card_unknown")
    private let accessBaseUrl = Bundle.main.infoDictionary?["AccessBaseURL"] as! String
    
    @IBAction func submit(_ sender: Any) {
        submitCard(pan: panView.text,
                   expiryDate: expiryDateView.text,
                   cvc: cvcView.text)
    }
    
    private func submitCard(pan: String, expiryDate: String, cvc: String) {
        spinner.startAnimating()
        
        let sessionTypes: Set<SessionType> = paymentsCvcSessionToggle.isOn ? [SessionType.verifiedTokens, SessionType.paymentsCvc] : [SessionType.verifiedTokens]
        
        let cardDetails = try! CardDetailsBuilder().pan(pan)
            .expiryDate(expiryDate)
            .cvc(cvc)
            .build()
        
        let accessCheckoutClient = try? AccessCheckoutClientBuilder().accessBaseUrl(accessBaseUrl)
            .merchantId(CI.merchantId)
            .build()
        
        try? accessCheckoutClient?.generateSessions(cardDetails: cardDetails, sessionTypes: sessionTypes) { result in
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                
                switch result {
                case .success(let sessions):
                    var titleToDisplay: String, messageToDisplay: String
                    
                    if sessionTypes.count > 1 {
                        titleToDisplay = "Verified Tokens & Payments CVC Sessions"
                        messageToDisplay = """
                        \(sessions[SessionType.verifiedTokens]!)
                        \(sessions[SessionType.paymentsCvc]!)
                        """
                    } else {
                        titleToDisplay = "Verified Tokens Session"
                        messageToDisplay = "\(sessions[SessionType.verifiedTokens]!)"
                    }
                    
                    AlertView.display(using: self, title: titleToDisplay, message: messageToDisplay, closeHandler: {
                        self.resetCard(preserveContent: false, validationErrors: nil)
                    })
                case .failure(let error):
                    let title = error.localizedDescription
                    var accessCheckoutClientValidationErrors: [AccessCheckoutError.AccessCheckoutValidationError]?
                    if error.message.contains("bodyDoesNotMatchSchema") {
                        accessCheckoutClientValidationErrors = error.validationErrors
                    }
                    
                    AlertView.display(using: self, title: title, message: nil, closeHandler: {
                        self.resetCard(preserveContent: true, validationErrors: accessCheckoutClientValidationErrors)
                    })
                }
            }
        }
    }
    
    private func resetCard(preserveContent: Bool, validationErrors: [AccessCheckoutError.AccessCheckoutValidationError]?) {
        if !preserveContent {
            panView.clear()
            expiryDateView.clear()
            cvcView.clear()
        }
        
        validationErrors?.forEach { error in
            if error.errorName == "panFailedLuhnCheck" {
                changePanValidIndicator(isValid: false)
            } else if error.errorName == "dateHasInvalidFormat" {
                if error.jsonPath == "$.cardNumber" {
                    changePanValidIndicator(isValid: false)
                } else if error.jsonPath == "$.cardExpiryDate.month" {
                    changeExpiryDateValidIndicator(isValid: false)
                } else if error.jsonPath == "$.cardExpiryDate.year" {
                    changeExpiryDateValidIndicator(isValid: false)
                } else if error.jsonPath == "$.cvv" {
                    changeCvcValidIndicator(isValid: false)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        panView.layer.borderWidth = 1
        panView.layer.borderColor = UIColor.lightText.cgColor
        panView.layer.cornerRadius = 8
        
        expiryDateView.layer.borderWidth = 1
        expiryDateView.layer.borderColor = UIColor.lightText.cgColor
        expiryDateView.layer.cornerRadius = 8
        
        cvcView.layer.borderWidth = 1
        cvcView.layer.borderColor = UIColor.lightText.cgColor
        cvcView.layer.cornerRadius = 8
        
        resetCard(preserveContent: false, validationErrors: nil)
        
        let validationConfig = CardValidationConfig(panView: panView,
                                                    expiryDateView: expiryDateView,
                                                    cvcView: cvcView,
                                                    accessBaseUrl: accessBaseUrl,
                                                    validationDelegate: self)
        
        AccessCheckoutValidationInitialiser().initialise(validationConfig)
        
        panValidChanged(isValid: false)
        expiryDateValidChanged(isValid: false)
        cvcValidChanged(isValid: false)
        cardBrandChanged(cardBrand: nil)
    }
    
    private func updateCardBrandImage(url: URL) {
        DispatchQueue.global(qos: .userInteractive).async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.panView.imageView.image = UIImage(data: data)
                }
            }
        }
    }
    
    private func changePanValidIndicator(isValid: Bool) {
        panView.textColor = isValid ? nil : UIColor.red
    }
    
    private func changeExpiryDateValidIndicator(isValid: Bool) {
        expiryDateView.textColor = isValid ? nil : UIColor.red
    }
    
    private func changeCvcValidIndicator(isValid: Bool) {
        cvcView.textColor = isValid ? nil : UIColor.red
    }
}

extension CardFlowViewController: AccessCheckoutCardValidationDelegate {
    func cardBrandChanged(cardBrand: CardBrand?) {
        if let imageUrl = cardBrand?.images.filter({ $0.type == "image/png" }).first?.url,
            let url = URL(string: imageUrl) {
            updateCardBrandImage(url: url)
        } else {
            panView.imageView.image = unknownBrandImage
        }
        panView.imageView.accessibilityLabel = NSLocalizedString(cardBrand?.name ?? "unknown_card_brand", comment: "")
    }
    
    func panValidChanged(isValid: Bool) {
        changePanValidIndicator(isValid: isValid)
        disableSubmitIfNotValid(valid: isValid)
    }
    
    func cvcValidChanged(isValid: Bool) {
        changeCvcValidIndicator(isValid: isValid)
        disableSubmitIfNotValid(valid: isValid)
    }
    
    func expiryDateValidChanged(isValid: Bool) {
        changeExpiryDateValidIndicator(isValid: isValid)
        disableSubmitIfNotValid(valid: isValid)
    }
    
    func validationSuccess() {
        submitButton.isEnabled = true
    }
    
    private func disableSubmitIfNotValid(valid: Bool) {
        if !valid {
            submitButton.isEnabled = false
        }
    }
}
