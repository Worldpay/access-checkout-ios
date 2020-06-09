public struct CardValidationConfig: ValidationConfig {
    public let panView: PANView
    public let expiryDateView: ExpiryDateView
    public let cvvView: CVVView
    public let accessBaseUrl: String
    public let validationDelegate: AccessCheckoutCardValidationDelegate

    public init(panView: PANView,
                expiryDateView: ExpiryDateView,
                cvvView: CVVView,
                accessBaseUrl: String,
                validationDelegate: AccessCheckoutCardValidationDelegate) {
        self.panView = panView
        self.expiryDateView = expiryDateView
        self.cvvView = cvvView
        self.accessBaseUrl = accessBaseUrl
        self.validationDelegate = validationDelegate
    }
}
