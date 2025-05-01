import AccessCheckoutSDK
import UIKit

class CvcFlowViewController: UIViewController {
    @IBOutlet var cvcTextField: AccessCheckoutUITextField!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var cvcIsValidLabel: UILabel!
    
    @IBAction func submitTouchUpInsideHandler(_ sender: Any) {
        self.cvcTextField.isEnabled = false
        
        spinner.startAnimating()

        let cardDetails = try! CardDetailsBuilder()
            .cvc(cvcTextField)
            .build()

        let accessCheckoutClient = try? AccessCheckoutClientBuilder().accessBaseUrl(Configuration.accessBaseUrl)
            .checkoutId(Configuration.checkoutId)
            .build()

        try? accessCheckoutClient?.generateSessions(cardDetails: cardDetails, sessionTypes: [SessionType.cvc]) { result in
            DispatchQueue.main.async {
                self.spinner.stopAnimating()

                switch result {
                    case .success(let sessions):
                        AlertView.display(using: self, title: "CVC Session", message: sessions[SessionType.cvc], closeHandler: {
                            self.cvcTextField.isEnabled = true
                            self.cvcTextField.clear()
                        })
                    case .failure(let error):
                        self.cvcTextField.isEnabled = true
                        self.highlightCvcField(error: error)

                        AlertView.display(using: self, title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cvcTextField.placeholder = "123"
        cvcTextField.font = .preferredFont(forTextStyle: .body)
        
        // Control used as helpers for the automated tests - Start of section
        // Label colour is changed to make it invisible
        cvcIsValidLabel.textColor = Configuration.backgroundColor
        // Controls used as helpers for the automated tests - End of section
        
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
