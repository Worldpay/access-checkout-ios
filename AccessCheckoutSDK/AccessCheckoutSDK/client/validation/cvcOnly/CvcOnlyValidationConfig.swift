public struct CvcOnlyValidationConfig: ValidationConfig {
    public let cvcView: CvcView
    public let validationDelegate: AccessCheckoutCvcOnlyValidationDelegate
    
    public init(cvcView: CvcView, validationDelegate: AccessCheckoutCvcOnlyValidationDelegate) {
        self.cvcView = cvcView
        self.validationDelegate = validationDelegate
    }
}
