import AccessCheckoutSDK
import UIKit

class CvcFlowViewController: UIViewController {
    @IBOutlet weak var cvcTextField: AccessCheckoutUITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var cvcIsValidLabel: UILabel!
    
    @IBAction func submitTouchUpInsideHandler(_ sender: Any) {
//        let cvc = cvcTextField.text
//
//        spinner.startAnimating()
//
//        let cardDetails = try! CardDetailsBuilder()
//            .cvc(cvc ?? "")
//            .build()
//
//        let accessCheckoutClient = try? AccessCheckoutClientBuilder().accessBaseUrl(Configuration.accessBaseUrl)
//            .merchantId(Configuration.merchantId)
//            .build()
//
//        try? accessCheckoutClient?.generateSessions(cardDetails: cardDetails, sessionTypes: [SessionType.cvc]) { result in
//            DispatchQueue.main.async {
//                self.spinner.stopAnimating()
//
//                switch result {
//                    case .success(let sessions):
//                        AlertView.display(using: self, title: "Payments CVC Session", message: sessions[SessionType.cvc], closeHandler: {
//                            self.cvcTextField.text = ""
//                            self.cvcTextField.sendActions(for: .editingChanged)
//                    })
//                    case .failure(let error):
//                        self.highlightCvcField(error: error)
//
//                        AlertView.display(using: self, title: "Error", message: error.localizedDescription)
//                }
//            }
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cvcTextField.layer.borderWidth = 1
        cvcTextField.layer.borderColor = UIColor.lightText.cgColor
        cvcTextField.layer.cornerRadius = 8
        cvcTextField.backgroundColor = UIColor.white
        cvcTextField.placeholder = "123"
        
        cvcIsValidLabel.font = UIFont.systemFont(ofSize: 0)
        
        let validationConfig = try! CvcOnlyValidationConfig.builder()
            .cvc(cvcTextField)
            .validationDelegate(self)
            .build()
        AccessCheckoutValidationInitialiser().initialise(validationConfig)
        
        cvcValidChanged(isValid: false)
    }
    
    private func highlightCvcField(error: AccessCheckoutError) {
        if extractFieldThatCausedError(from: error) == "$.cvv" {
            changeCvcValidIndicator(isValid: false)
        }
    }
    
    private func extractFieldThatCausedError(from error: AccessCheckoutError) -> String? {
        var validationErrors = [AccessCheckoutError.AccessCheckoutValidationError]()
        if error.message.contains("bodyDoesNotMatchSchema") {
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
        cvcTextField.textColor = isValid ? nil : UIColor.red
        cvcIsValidLabel.text = isValid ? "valid" : "invalid"
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
