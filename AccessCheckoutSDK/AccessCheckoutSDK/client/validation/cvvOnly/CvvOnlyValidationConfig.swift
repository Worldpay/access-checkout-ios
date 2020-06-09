public struct CvvOnlyValidationConfig: ValidationConfig {
    public let cvvView: CVVView
    public let validationDelegate: AccessCheckoutCvvOnlyValidationDelegate
    
    public init(cvvView: CVVView, validationDelegate: AccessCheckoutCvvOnlyValidationDelegate) {
        self.cvvView = cvvView
        self.validationDelegate = validationDelegate
    }
}
