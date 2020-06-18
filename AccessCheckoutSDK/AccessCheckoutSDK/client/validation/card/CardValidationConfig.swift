public struct CardValidationConfig: ValidationConfig {
    public let panView: PANView
    public let expiryDateView: ExpiryDateView
    public let cvcView: CvcView
    public let accessBaseUrl: String
    public let validationDelegate: AccessCheckoutCardValidationDelegate

    public init(panView: PANView,
                expiryDateView: ExpiryDateView,
                cvcView: CvcView,
                accessBaseUrl: String,
                validationDelegate: AccessCheckoutCardValidationDelegate) {
        self.panView = panView
        self.expiryDateView = expiryDateView
        self.cvcView = cvcView
        self.accessBaseUrl = accessBaseUrl
        self.validationDelegate = validationDelegate
    }
}
