import AccessCheckoutSDK
import UIKit

class CardFlowViewController: UIViewController {
    @IBOutlet weak var panTextField: UITextField!
    @IBOutlet weak var expiryDateTextField: UITextField!
    @IBOutlet weak var cvcTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var paymentsCvcSessionToggle: UISwitch!

    @IBOutlet weak var panIsValidLabel: UILabel!
    @IBOutlet weak var expiryDateIsValidLabel: UILabel!
    @IBOutlet weak var cvcIsValidLabel: UILabel!

    @IBOutlet weak var getPanCaretPositionTextField: UITextField!
    @IBOutlet weak var setPanCaretPositionButton: UIButton!
    @IBOutlet weak var setPanCaretPositionTextField: UITextField!

    private let unknownBrandImage = UIImage(named: "card_unknown")

    private let accessBaseUrl = Bundle.main.infoDictionary?["AccessBaseURL"] as! String

    @IBAction func submit(_ sender: Any) {
        submitCard(pan: panTextField.text ?? "",
                   expiryDate: expiryDateTextField.text ?? "",
                   cvc: (cvcTextField.text ?? "") as String)
    }

    @IBAction func getPanCaret(_ sender: Any) {
        if let textRange = panTextField.selectedTextRange {
            let cursorPosition = panTextField.offset(from: panTextField.beginningOfDocument, to: textRange.start)
            setPanCaretPositionTextField.text = "\(cursorPosition)"
        }
    }

    @IBAction func setPanCaret() {
        if let caretPosition = setPanCaretPositionTextField.text,
            let newPosition = panTextField.position(from: panTextField.beginningOfDocument, offset: Int(caretPosition)!) {
            NSLog("Setting caret position for PAN field at position \(caretPosition)")

            panTextField.becomeFirstResponder()
            panTextField.selectedTextRange = panTextField.textRange(from: newPosition, to: newPosition)
        }
    }

    private func submitCard(pan: String, expiryDate: String, cvc: String) {
        spinner.startAnimating()

        let sessionTypes: Set<SessionType> = paymentsCvcSessionToggle.isOn ? [SessionType.card, SessionType.cvc] : [SessionType.card]

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
                        \(sessions[SessionType.card]!)
                        \(sessions[SessionType.cvc]!)
                        """
                    } else {
                        titleToDisplay = "Verified Tokens Session"
                        messageToDisplay = "\(sessions[SessionType.card]!)"
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
            panTextField.text = ""
            panTextField.sendActions(for: .editingChanged)

            expiryDateTextField.text = ""
            expiryDateTextField.sendActions(for: .editingChanged)

            cvcTextField.text = ""
            cvcTextField.sendActions(for: .editingChanged)
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

    @objc
    func recordPanTextFieldsCaretPosition(sender: UITextField) {
        if let textRange = sender.selectedTextRange {
            let cursorPosition = sender.offset(from: sender.beginningOfDocument, to: textRange.start)
            getPanCaretPositionTextField.text = "\(cursorPosition)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        panTextField.layer.borderWidth = 1
        panTextField.layer.borderColor = UIColor.lightText.cgColor
        panTextField.layer.cornerRadius = 8
        panTextField.backgroundColor = UIColor.white
        panTextField.placeholder = "Card Number"

        expiryDateTextField.layer.borderWidth = 1
        expiryDateTextField.layer.borderColor = UIColor.lightText.cgColor
        expiryDateTextField.layer.cornerRadius = 8
        expiryDateTextField.backgroundColor = UIColor.white
        expiryDateTextField.placeholder = "MM/YY"

        cvcTextField.layer.borderWidth = 1
        cvcTextField.layer.borderColor = UIColor.lightText.cgColor
        cvcTextField.layer.cornerRadius = 8
        cvcTextField.backgroundColor = UIColor.white
        cvcTextField.placeholder = "CVC"

        // Controls used as helpers for the automated tests - Start of section
        panTextField.addTarget(self, action: #selector(recordPanTextFieldsCaretPosition), for: .editingDidEnd)

        panIsValidLabel.font = UIFont.systemFont(ofSize: 0)
        expiryDateIsValidLabel.font = UIFont.systemFont(ofSize: 0)
        cvcIsValidLabel.font = UIFont.systemFont(ofSize: 0)

        setPanCaretPositionTextField.borderStyle = .none
        setPanCaretPositionButton.titleLabel?.font = UIFont.systemFont(ofSize: 0)
        // Controls used as helpers for the automated tests - End of section

        resetCard(preserveContent: false, validationErrors: nil)

        let validationConfig = try! CardValidationConfig.builder()
            .pan(panTextField)
            .expiryDate(expiryDateTextField)
            .cvc(cvcTextField)
            .accessBaseUrl(accessBaseUrl)
            .validationDelegate(self)
            .enablePanFormatting()
            .build()

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
                    self.imageView.image = UIImage(data: data)
                }
            }
        }
    }

    private func changePanValidIndicator(isValid: Bool) {
        panTextField.textColor = isValid ? nil : UIColor.red
        panIsValidLabel.text = isValid ? "valid" : "invalid"
    }

    private func changeExpiryDateValidIndicator(isValid: Bool) {
        expiryDateTextField.textColor = isValid ? nil : UIColor.red
        expiryDateIsValidLabel.text = isValid ? "valid" : "invalid"
    }

    private func changeCvcValidIndicator(isValid: Bool) {
        cvcTextField.textColor = isValid ? nil : UIColor.red
        cvcIsValidLabel.text = isValid ? "valid" : "invalid"
    }
}

extension CardFlowViewController: AccessCheckoutCardValidationDelegate {
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
