/**
 An implementation of the `ValidationConfig` that represents the card validation configuration.

 This configuration should be build to register the relevant fields and the listeners.

 - panTextField: `UITextField` that represents the pan ui element
 - expiryDateTextField: `UITextField` that represents the expiry date ui element
 - cvcTextField: `UITextField` that represents the cvc ui element
 - accessBaseUrl: `String` that represents the base url to use when calling Worldpay services
 - validationDelegate: `AccessCheckoutCardValidationDelegate` that represents the validation delegate that should be notified on validation changes
 
 Deprecated - using the Views below to initialise the validation is deprecated and will not be supported on future versions of the SDK. `UITextField`s should be used as above.
 
 - panView: `PanView` that represents the pan ui element
 - expiryDateView: `ExpiryDateView` that represents the expiry date ui element
 - cvcView: `CvcView` that represents the cvc ui element
 
 - SeeAlso: PanView
 - SeeAlso: ExpiryDateView
 - SeeAlso: CvcView
 - SeeAlso: AccessCheckoutCardValidationDelegate
 */
public struct CardValidationConfig: ValidationConfig {
    let panTextField: UITextField?
    let expiryDateTextField: UITextField?
    let cvcTextField: UITextField?
    
    let panView: PanView?
    let expiryDateView: ExpiryDateView?
    let cvcView: CvcView?

    let accessBaseUrl: String
    let validationDelegate: AccessCheckoutCardValidationDelegate
    
    let textFieldMode: Bool

    
    /**
    Creates an instance of `CardValidationConfig`

    - Parameter panTextField: `UITextField` that represents the pan ui element
    - Parameter expiryDateTextField: `UITextField` that represents the expiry date ui element
    - Parameter cvcTextField: `UITextField` that represents the cvc ui element
    - Parameter accessBaseUrl: `String` that represents the base url
    - Parameter validationDelegate: `AccessCheckoutCardValidationDelegate` that represents the validation events listener
    */
    public init(panTextField: UITextField,
                expiryDateTextField: UITextField,
                cvcTextField: UITextField,
                accessBaseUrl: String,
                validationDelegate: AccessCheckoutCardValidationDelegate) {
        self.panTextField = panTextField
        self.expiryDateTextField = expiryDateTextField
        self.cvcTextField = cvcTextField
        self.accessBaseUrl = accessBaseUrl
        self.validationDelegate = validationDelegate
        
        self.panView = nil
        self.expiryDateView = nil
        self.cvcView = nil
        
        self.textFieldMode = true
    }
    
    /**
    Deprecated
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
        
        self.panTextField = nil
        self.expiryDateTextField = nil
        self.cvcTextField = nil
        
        self.textFieldMode = false
    }
}
