import AccessCheckoutSDK
import UIKit

class CardFlowViewController: UIViewController {
    @IBOutlet var panTextField: AccessCheckoutUITextField!
    @IBOutlet var expiryDateTextField: AccessCheckoutUITextField!
    @IBOutlet var cvcTextField: AccessCheckoutUITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var paymentsCvcSessionToggle: UISwitch!

    @IBOutlet var panIsValidLabel: UILabel!
    @IBOutlet var expiryDateIsValidLabel: UILabel!
    @IBOutlet var cvcIsValidLabel: UILabel!

    private let unknownBrandImage = UIImage(named: "card_unknown")

    @IBAction func submit(_ sender: Any) {
        submitCard()
    }

    private func submitCard() {
        panTextField.isEnabled = false
        expiryDateTextField.isEnabled = false
        cvcTextField.isEnabled = false

        spinner.startAnimating()

        let sessionTypes: Set<SessionType> =
            paymentsCvcSessionToggle.isOn
                ? [SessionType.card, SessionType.cvc] : [SessionType.card]

        let cardDetails = try! CardDetailsBuilder().pan(panTextField)
            .expiryDate(expiryDateTextField)
            .cvc(cvcTextField)
            .build()

        let accessCheckoutClient = try? AccessCheckoutClientBuilder().accessBaseUrl(
            Configuration.accessBaseUrl
        )
        .checkoutId(Configuration.checkoutId)
        .build()

        try? accessCheckoutClient?.generateSessions(
            cardDetails: cardDetails,
            sessionTypes: sessionTypes
        ) { result in
            DispatchQueue.main.async {
                self.spinner.stopAnimating()

                switch result {
                case .success(let sessions):
                    var titleToDisplay: String
                    var messageToDisplay: String

                    if sessionTypes.count > 1 {
                        titleToDisplay = "Card & CVC Sessions"
                        messageToDisplay = """
                        \(sessions[SessionType.card]!)
                        \(sessions[SessionType.cvc]!)
                        """
                    } else {
                        titleToDisplay = "Card Session"
                        messageToDisplay = "\(sessions[SessionType.card]!)"
                    }

                    AlertView.display(
                        using: self,
                        title: titleToDisplay,
                        message: messageToDisplay,
                        closeHandler: {
                            self.resetCard(preserveContent: false, validationErrors: nil)
                        }
                    )
                case .failure(let error):
                    let title = error.localizedDescription
                    var accessCheckoutClientValidationErrors:
                        [AccessCheckoutError.AccessCheckoutValidationError]?
                    if error.message.contains("bodyDoesNotMatchSchema") {
                        accessCheckoutClientValidationErrors = error.validationErrors
                    }

                    AlertView.display(
                        using: self,
                        title: title,
                        message: nil,
                        closeHandler: {
                            self.resetCard(
                                preserveContent: true,
                                validationErrors: accessCheckoutClientValidationErrors
                            )
                        }
                    )
                }
            }
        }
    }

    private func resetCard(
        preserveContent: Bool,
        validationErrors: [AccessCheckoutError.AccessCheckoutValidationError]?
    ) {
        panTextField.isEnabled = true
        expiryDateTextField.isEnabled = true
        cvcTextField.isEnabled = true

        if !preserveContent {
            panTextField.clear()
            expiryDateTextField.clear()
            cvcTextField.clear()
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

        panTextField.placeholder = "Card Number"
        expiryDateTextField.placeholder = "MM/YY"
        cvcTextField.placeholder = "CVC"

        panTextField.textContentType = UITextContentType.creditCardNumber

        // Apply onfocus listeners
        panTextField.setOnFocusChangedListener { view, hasFocus in
            if #available(iOS 13.0, *) {
                view.borderColor = hasFocus ? .systemBlue : .systemGray5
            } else {
                view.borderColor = hasFocus ? .systemBlue : .systemGray
            }
        }

        expiryDateTextField.setOnFocusChangedListener { view, hasFocus in
            if #available(iOS 13.0, *) {
                view.borderColor = hasFocus ? .systemBlue : .systemGray5
            } else {
                view.borderColor = hasFocus ? .systemBlue : .systemGray
            }
        }

        cvcTextField.setOnFocusChangedListener { view, hasFocus in
            if #available(iOS 13.0, *) {
                view.borderColor = hasFocus ? .systemBlue : .systemGray5
            } else {
                view.borderColor = hasFocus ? .systemBlue : .systemGray
            }
        }

        panTextField.font = .preferredFont(forTextStyle: .body)
        expiryDateTextField.font = .preferredFont(forTextStyle: .body)
        cvcTextField.font = .preferredFont(forTextStyle: .body)
        submitButton.titleLabel?.adjustsFontForContentSizeCategory = true
        submitButton.titleLabel?.adjustsFontSizeToFitWidth = true

        // Controls used as helpers for the automated tests - Start of section
        // Labels colours are changed to make them invisible
        panIsValidLabel.textColor = Configuration.backgroundColor
        expiryDateIsValidLabel.textColor = Configuration.backgroundColor
        cvcIsValidLabel.textColor = Configuration.backgroundColor
        // Controls used as helpers for the automated tests - End of section

        resetCard(preserveContent: false, validationErrors: nil)

        let validationConfig = try! CardValidationConfig.builder()
            .pan(panTextField)
            .expiryDate(expiryDateTextField)
            .cvc(cvcTextField)
            .accessBaseUrl(Configuration.accessBaseUrl)
            .validationDelegate(self)
            .enablePanFormatting()
            .build()

        AccessCheckoutValidationInitialiser().initialise(validationConfig)

        disableSubmitIfNotValid(valid: false)
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
        panIsValidLabel.text = isValid ? "valid" : "invalid"
    }

    private func changeExpiryDateValidIndicator(isValid: Bool) {
        expiryDateTextField.textColor =
            isValid ? Configuration.validCardDetailsColor : Configuration.invalidCardDetailsColor
        expiryDateIsValidLabel.text = isValid ? "valid" : "invalid"
    }

    private func changeCvcValidIndicator(isValid: Bool) {
        cvcTextField.textColor =
            isValid ? Configuration.validCardDetailsColor : Configuration.invalidCardDetailsColor
        cvcIsValidLabel.text = isValid ? "valid" : "invalid"
    }
}

extension CardFlowViewController: AccessCheckoutCardValidationDelegate {
    func cardBrandChanged(cardBrand: CardBrand?) {
        if let imageUrl = cardBrand?.images.filter({ $0.type == "image/png" }).first?.url,
           let url = URL(string: imageUrl)
        {
            updateCardBrandImage(url: url)
        } else {
            imageView.image = unknownBrandImage
        }
        imageView.accessibilityLabel = NSLocalizedString(
            cardBrand?.name ?? "unknown_card_brand",
            comment: ""
        )
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
