import UIKit
import AccessCheckoutSDK
import os.log

class ViewController: UIViewController {
    
    @IBOutlet weak var panView: PANView!
    @IBOutlet weak var expiryDateView: ExpiryDateView!
    @IBOutlet weak var cvvView: CVVView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private var accessClient: AccessClient?
    private var card: Card?
    private let unknownBrandImage = UIImage(named: "card_unknown")
    
    private let merchantId = "<YOUR MERCHANT ID>"
    private let accessWorldpayBaseUrl = URL(string: "https://access.worldpay.com")!
    
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
                    let alertController = UIAlertController(title: "Session", message: href, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        alertController.dismiss(animated: true)
                        self.resetCard(preserveContent: false, validationErrors: nil)
                    }))
                    self.present(alertController, animated: true)
                    os_log("Received verified token href: %@", href)
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
                    let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        alertController.dismiss(animated: true)
                    }))
                    self.present(alertController, animated: true )
                }
            }
        }
    }
    
    private func resetCard(preserveContent: Bool, validationErrors: [AccessCheckoutClientValidationError]?) {
        
        panView.isEnabled = true
        panView.imageView.image = unknownBrandImage
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
                    os_log("Unrecognized jsonPath")
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
        let card = AccessCheckoutCard(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView)
        card.cardDelegate = self
        if let url = Bundle.main.url(forResource: "cardConfiguration", withExtension: "json") {
            card.cardValidator = AccessCheckoutCardValidator(cardConfiguration: CardConfiguration(fromURL: url))
        }
        self.card = card
        
        let accessCheckoutDiscovery = AccessCheckoutDiscovery(baseUrl: accessWorldpayBaseUrl)
        accessCheckoutDiscovery.discover(urlSession: URLSession.shared) {
            self.accessClient = AccessCheckoutClient(discovery: accessCheckoutDiscovery,
                                                     merchantIdentifier: self.merchantId)
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

extension ViewController: CardDelegate {
    func cardView(_ cardView: CardView, isValid valid: Bool) {
        cardView.isValid(valid: valid)
        if let valid = card?.isValid() {
            submitButton.isEnabled = valid
        }
    }
    
    func didChangeCardBrand(_ cardBrand: CardConfiguration.CardBrand?) {
        if let imageUrl = cardBrand?.imageUrl,
            let url = URL(string: imageUrl) {
                updateCardBrandImage(url: url)
        } else {
            panView.imageView.image = unknownBrandImage
        }
        panView.imageView.accessibilityLabel = NSLocalizedString(cardBrand?.name ?? "unknown_card_brand", comment: "")
    }
}
