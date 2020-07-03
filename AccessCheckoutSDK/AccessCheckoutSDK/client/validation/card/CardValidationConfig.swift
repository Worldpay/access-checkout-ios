/**
 An implementation of the `ValidationConfig` that represents the card validation configuration.

 This configuration should be build to register the relevant fields and the listeners.

 - pan: `PanView` that represents the pan ui element
 - expiryDate: `ExpiryDateView` that represents the expiry date ui element
 - cvc: `CvcView` that represents the cvc ui element
 - accessBaseUrl: `String` that represents the base url to use when calling Worldpay services
 - validationDelegate: `AccessCheckoutCardValidationDelegate` that represents the validation delegate that should be notified on validation changes

 - SeeAlso: PanView
 - SeeAlso: ExpiryDateView
 - SeeAlso: CvcView
 - SeeAlso: AccessCheckoutCardValidationDelegate
 */
public struct CardValidationConfig: ValidationConfig {
    public let panView: PanView
    public let expiryDateView: ExpiryDateView
    public let cvcView: CvcView
    public let accessBaseUrl: String
    public let validationDelegate: AccessCheckoutCardValidationDelegate

    /**
    Creates an instance of `CardValidationConfig`

    - Parameter panView: `PanView` that represents the pan ui element
    - Parameter expiryDateView: `ExpiryDateView` that represents the expiry date ui element
    - Parameter cvcView: `CvcView` that represents the cvc ui element
    - Parameter accessBaseUrl: `String` that represents the base url
    - Parameter validationDelegate: `AccessCheckoutCardValidationDelegate` that represents the validation events listener
    */
    public init(panView: PanView,
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
