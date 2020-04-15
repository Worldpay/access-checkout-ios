import UIKit
import AccessCheckoutSDK

class CardFlowViewController: UIViewController {
    
    @IBOutlet weak var panView: PANView!
    @IBOutlet weak var expiryDateView: ExpiryDateView!
    @IBOutlet weak var cvvView: CVVView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private var accessClient: AccessClient?
    private var card: Card?
    private let unknownBrandImage = UIImage(named: "card_unknown")
    
    @IBAction func submit(_ sender: Any) {
        guard let pan = panView.text,
            let month = expiryDateView.month,
            let year = expiryDateView.year,
            let cvv = cvvView.text else {
                return
        }
        submitCard(pan: pan, month: month, year: year, cvv: cvv)
    }
    
    private func submitCard(pan: PAN, month: ExpiryMonth, year: ExpiryYear, cvv: CVV) {
        
        guard let expiryMonth = UInt(month), let expiryYear = year.toFourDigitFormat() else {
            return
        }
        
        submitButton.isEnabled = false
        panView.isEnabled = false
        expiryDateView.isEnabled = false
        cvvView.isEnabled = false
        spinner.startAnimating()
        accessClient?.createSession(pan: pan,
                                    expiryMonth: expiryMonth,
                                    expiryYear: expiryYear,
                                    cvv: cvv,
                                    urlSession: URLSession.shared) { result in
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                
                switch result {
                case .success(let href):
                    AlertView.display(using: self, title: "Session", message: href, closeHandler: {
                        self.resetCard(preserveContent: false, validationErrors: nil)
                    })
                case .failure(let error):
                    let title = error.localizedDescription
                    var accessCheckoutClientValidationErrors: [AccessCheckoutClientValidationError]?
                    if let accessCheckoutClientError = error as? AccessCheckoutClientError {
                        switch accessCheckoutClientError {
                        case .bodyDoesNotMatchSchema(_, let validationErrors):
                            accessCheckoutClientValidationErrors = validationErrors
                        default:
                            break
                        }
                    }

                    self.resetCard(preserveContent: true, validationErrors: accessCheckoutClientValidationErrors)
                    AlertView.display(using: self, title: title, message: nil)
                }
            }
        }
    }
    
    private func resetCard(preserveContent: Bool, validationErrors: [AccessCheckoutClientValidationError]?) {
        
        panView.isEnabled = true
        panView.isValid(valid: true)
        
        expiryDateView.isEnabled = true
        expiryDateView.isValid(valid: true)
        
        cvvView.isEnabled = true
        cvvView.isValid(valid: true)
        
        submitButton.isEnabled = false
        
        if !preserveContent {
            panView.clear()
            expiryDateView.clear()
            cvvView.clear()
            panView.imageView.image = unknownBrandImage
        }
        validationErrors?.forEach({ error in
            switch error {
            case .panFailedLuhnCheck:
                panView?.isValid(valid: false)
            case .dateHasInvalidFormat(_, let jsonPath):
                switch jsonPath {
                case "$.cardNumber":
                    panView?.isValid(valid: false)
                case "$.cardExpiryDate.month":
                    expiryDateView.isValid(valid: false)
                case "$.cardExpiryDate.year":
                    expiryDateView.isValid(valid: false)
                case "$.cvv":
                    cvvView.isValid(valid: false)
                default:
                    print("Unrecognized jsonPath")
                }
            default:
                break
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        panView.layer.borderWidth = 1
        panView.layer.borderColor = UIColor.lightText.cgColor
        panView.layer.cornerRadius = 8
        
        expiryDateView.layer.borderWidth = 1
        expiryDateView.layer.borderColor = UIColor.lightText.cgColor
        expiryDateView.layer.cornerRadius = 8
        
        cvvView.layer.borderWidth = 1
        cvvView.layer.borderColor = UIColor.lightText.cgColor
        cvvView.layer.cornerRadius = 8
        
        resetCard(preserveContent: false, validationErrors: nil)
        
        // Card setup
        let cardValidator = AccessCheckoutCardValidator()
        if let configUrl = Bundle.main.infoDictionary?["AccessCardConfigurationURL"] as? String,
            let url = URL(string: configUrl) {
                cardValidator.cardConfiguration = CardConfiguration(fromURL: url)
        }
        
        let card = AccessCheckoutCard(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView)
        card.cardDelegate = self
        card.cardValidator = cardValidator
        self.card = card
        
        if let baseUrl = Bundle.main.infoDictionary?["AccessBaseURL"] as? String, let url = URL(string: baseUrl) {
            let accessCheckoutDiscovery = AccessCheckoutDiscovery(baseUrl: url)
            let vts = ApiLinks.verifiedTokens
            accessCheckoutDiscovery.discover(serviceLinks: vts, urlSession: URLSession.shared) {
                self.accessClient = AccessCheckoutClient(discovery: accessCheckoutDiscovery,
                                                         merchantIdentifier: CI.merchantId)
            }
        }
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
}

extension CardFlowViewController: CardDelegate {
    func cardView(_ cardView: CardView, isValid valid: Bool) {
        cardView.isValid(valid: valid)
        if let valid = card?.isValid() {
            submitButton.isEnabled = valid
        }
    }
    
    func didChangeCardBrand(_ cardBrand: CardConfiguration.CardBrand?) {
        if let imageUrl = cardBrand?.images?.filter( { $0.type == "image/png" } ).first?.url,
            let url = URL(string: imageUrl) {
                updateCardBrandImage(url: url)
        } else {
            panView.imageView.image = unknownBrandImage
        }
        panView.imageView.accessibilityLabel = NSLocalizedString(cardBrand?.name ?? "unknown_card_brand", comment: "")
    }
}

/// Bitrise Swift variable injector step, see https://github.com/LucianoPAlmeida/variable-injector
struct CI {
    /// The merchant identity
    static var merchantId = "$(MERCHANT_ID)"
}
