import AccessCheckoutSDK
import UIKit

class CvvFlowViewController: UIViewController {
    @IBOutlet weak var cvvField: CVVView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private let accessBaseUrl = Bundle.main.infoDictionary?["AccessBaseURL"] as! String
    
    @IBAction func submitTouchUpInsideHandler(_ sender: Any) {
        guard let cvv = cvvField.text else {
            return
        }
        
        spinner.startAnimating()
        
        let cardDetails = try! CardDetailsBuilder()
            .cvv(cvv)
            .build()
        
        let accessCheckoutClient = try? AccessCheckoutClientBuilder().accessBaseUrl(accessBaseUrl)
            .merchantId(CI.merchantId)
            .build()
        
        try? accessCheckoutClient?.generateSessions(cardDetails: cardDetails, sessionTypes: [SessionType.paymentsCvc]) { result in
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                
                switch result {
                    case .success(let sessions):
                        AlertView.display(using: self, title: "Payments CVC Session", message: sessions[SessionType.paymentsCvc], closeHandler: {
                            self.cvvField.clear()
                    })
                    case .failure(let error):
                        self.highlightCvvField(error: error)
                        
                        AlertView.display(using: self, title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cvvField.layer.borderWidth = 1
        cvvField.layer.borderColor = UIColor.lightText.cgColor
        cvvField.layer.cornerRadius = 8
        
        let validationConfig = CvvOnlyValidationConfig(cvvView: cvvField, validationDelegate: self)
        AccessCheckoutValidationInitialiser().initialise(validationConfig)
        
        cvvValidChanged(isValid: false)
    }
    
    private func highlightCvvField(error: AccessCheckoutClientError) {
        if extractFieldThatCausedError(from: error) == "$.cvv" {
            changeCvvValidIndicator(isValid: false)
        }
    }
    
    private func extractFieldThatCausedError(from error: AccessCheckoutClientError) -> String? {
        var validationErrors: [AccessCheckoutClientValidationError] = []
        switch error {
            case .bodyDoesNotMatchSchema(_, let errors):
                validationErrors += errors!
            default:
                return nil
        }
        
        var fieldToReturn: String?
        validationErrors.forEach { validationError in
            switch validationError {
                case .stringFailedRegexCheck(_, let jsonPath):
                    switch jsonPath {
                        case "$.cvv":
                            fieldToReturn = jsonPath
                        default:
                            print("Unrecognized jsonPath")
                    }
                default:
                    break
            }
        }
        
        return fieldToReturn
    }
    
    private func changeCvvValidIndicator(isValid: Bool) {
        cvvField.textColor = isValid ? nil : UIColor.red
    }
}

extension CvvFlowViewController: AccessCheckoutCvvOnlyValidationDelegate {
    public func cvvValidChanged(isValid: Bool) {
        changeCvvValidIndicator(isValid: isValid)
        
        if !isValid {
            submitButton.isEnabled = false
        }
    }

    public func validationSuccess() {
        submitButton.isEnabled = true
    }
}
