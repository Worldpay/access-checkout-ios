import UIKit
import AccessCheckoutSDK

class CvvFlowViewController: UIViewController {

    @IBOutlet weak var cvvField: CVVView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private var cvvOnly:AccessCheckoutCVVOnly?
    private var cvvOnlyClient:AccessCheckoutCVVOnlyClient?
    
    @IBAction func submitTouchUpInsideHandler(_ sender: Any) {
        guard let cvv = cvvField.text else {
            return
        }
        
        spinner.startAnimating()
        
        cvvField.isEnabled = false
        
        cvvOnlyClient?.createSession(cvv: cvv,
                                    urlSession: URLSession.shared) { result in
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                
                switch result {
                case .success(let session):
                    AlertView.display(using: self, title: "Session", message: session, closeHandler: {
                        self.cvvField.clear()
                        self.cvvField.isEnabled = true
                        self.submitButton.isEnabled = self.cvvOnly!.isValid()
                    })
                case .failure(let error):
                    self.highlightCvvField(error: error)
                    
                    AlertView.display(using: self, title: "Error", message: error.localizedDescription, closeHandler: {
                        self.cvvField.isEnabled = true
                        self.submitButton.isEnabled = self.cvvOnly!.isValid()
                    })
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cvvField.layer.borderWidth = 1
        cvvField.layer.borderColor = UIColor.lightText.cgColor
        cvvField.layer.cornerRadius = 8
        
        submitButton.isEnabled = false
        
        cvvOnly = AccessCheckoutCVVOnly(cvvView: cvvField, cvvOnlyDelegate: self)
        
        if let baseUrl = Bundle.main.infoDictionary?["AccessBaseURL"] as? String, let url = URL(string: baseUrl) {
            let discovery = AccessCheckoutDiscovery(baseUrl: url)
            discovery.discover(serviceLinks: ApiLinks.sessions, urlSession: URLSession.shared) {
                self.cvvOnlyClient = AccessCheckoutCVVOnlyClient(discovery: discovery, merchantIdentifier: CI.merchantId)
            }
        }
    }
    
    private func highlightCvvField(error:AccessCheckoutClientError) {
        if (extractFieldThatCausedError(from: error) == "$.cvv") {
            self.cvvField.isValid(valid: false)
        }
    }
    
    private func extractFieldThatCausedError(from error: AccessCheckoutClientError) -> String? {
        var validationErrors:[AccessCheckoutClientValidationError] = []
        switch error {
            case .bodyDoesNotMatchSchema(_, let errors):
                validationErrors += errors!
            default:
                return nil
        }
        
        var fieldToReturn:String?
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
}

extension CvvFlowViewController : CVVOnlyDelegate {
    public func handleValidationResult(cvvView: AccessCheckoutView, isValid: Bool) {
        cvvView.isValid(valid: isValid)
        
        submitButton.isEnabled = self.cvvOnly!.isValid()
    }
}
