/**
 An implementation of the [ValidationConfig] that represents the cvc validation configuration.

 This configuration should be build to register the relevant fields and the listeners.

 - cvc:  `CvcView` that represents the cvc ui element
 - validationDelegate: `AccessCheckoutCvcOnlyValidationDelegate` that represents the validation delegate that should be notified on validation changes
 */
public struct CvcOnlyValidationConfig: ValidationConfig {
    public let cvcView: CvcView
    public let validationDelegate: AccessCheckoutCvcOnlyValidationDelegate

    public init(cvcView: CvcView, validationDelegate: AccessCheckoutCvcOnlyValidationDelegate) {
        self.cvcView = cvcView
        self.validationDelegate = validationDelegate
    }
}
