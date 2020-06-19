import AccessCheckoutSDK
import UIKit

class CvcFlowViewController: UIViewController {
    @IBOutlet weak var cvcView: CvcView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private let accessBaseUrl = Bundle.main.infoDictionary?["AccessBaseURL"] as! String
    
    @IBAction func submitTouchUpInsideHandler(_ sender: Any) {
        guard let cvc = cvcView.text else {
            return
        }
        
        spinner.startAnimating()
        
        let cardDetails = try! CardDetailsBuilder()
            .cvc(cvc)
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
                            self.cvcView.clear()
                    })
                    case .failure(let error):
                        self.highlightCvcField(error: error)
                        
                        AlertView.display(using: self, title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cvcView.layer.borderWidth = 1
        cvcView.layer.borderColor = UIColor.lightText.cgColor
        cvcView.layer.cornerRadius = 8
        
        let validationConfig = CvcOnlyValidationConfig(cvcView: cvcView, validationDelegate: self)
        AccessCheckoutValidationInitialiser().initialise(validationConfig)
        
        cvcValidChanged(isValid: false)
    }
    
    private func highlightCvcField(error: AccessCheckoutError) {
        if extractFieldThatCausedError(from: error) == "$.cvv" {
            changeCvcValidIndicator(isValid: false)
        }
    }
    
    private func extractFieldThatCausedError(from error: AccessCheckoutError) -> String? {
        var validationErrors = [AccessCheckoutError.ValidationError]()
        if error.errorName == "bodyDoesNotMatchSchema" {
            validationErrors += error.validationErrors
        }
        
        var fieldToReturn: String?
        validationErrors.forEach { validationError in
            if validationError.errorName == "stringFailedRegexCheck", validationError.jsonPath == "$.cvv" {
                fieldToReturn = validationError.jsonPath
            }
        }
        
        return fieldToReturn
    }
    
    private func changeCvcValidIndicator(isValid: Bool) {
        cvcView.textColor = isValid ? nil : UIColor.red
    }
}

extension CvcFlowViewController: AccessCheckoutCvcOnlyValidationDelegate {
    public func cvcValidChanged(isValid: Bool) {
        changeCvcValidIndicator(isValid: isValid)
        
        if !isValid {
            submitButton.isEnabled = false
        }
    }
    
    public func validationSuccess() {
        submitButton.isEnabled = true
    }
}
