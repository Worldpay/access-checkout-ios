/**
 An implementation of the [ValidationConfig] that represents the cvc validation configuration.

 This configuration should be built to register the relevant fields and the listeners.
 - cvcTextField: `UITextField` that represents the cvc ui element
 - accessBaseUrl: `String` that represents the base url to use when calling Worldpay services
 - validationDelegate: `AccessCheckoutCardValidationDelegate` that represents the validation delegate that should be notified on validation changes
 
 Deprecated - using the `CvcView` below to initialise the validation is deprecated and will not be supported on future major versions of the SDK.  A `UITextField` should be used as above.
 - cvc:  `CvcView` that represents the cvc ui element
 - validationDelegate: `AccessCheckoutCvcOnlyValidationDelegate` that represents the validation delegate that should be notified on validation changes
 */
public struct CvcOnlyValidationConfig: ValidationConfig {
    let cvcView: CvcView?
    let cvcTextField: UITextField?
    
    let textFieldMode: Bool
    let validationDelegate: AccessCheckoutCvcOnlyValidationDelegate

    /**
    Deprecated
    Creates an instance of `CvcOnlyValidationConfig`

    - Parameter cvcView: `CvcView` that represents the cvc ui element
    - Parameter validationDelegate: `AccessCheckoutCvcOnlyValidationDelegate` that represents the validation events listener
    */
    @available(*, deprecated, message: "Using CvcView to initialize the validation is deprecated and will not be supported on future major versions of the SDK. A `UITextField` should be used instead.")
    public init(cvcView: CvcView, validationDelegate: AccessCheckoutCvcOnlyValidationDelegate) {
        self.cvcView = cvcView
        self.validationDelegate = validationDelegate
        self.cvcTextField = nil
        self.textFieldMode = false
    }
    
    /**
    Creates an instance of `CvcOnlyValidationConfig`

    - Parameter cvcView: `UITextField` that represents the cvc ui element
    - Parameter validationDelegate: `AccessCheckoutCvcOnlyValidationDelegate` that represents the validation events listener
    */
    public init(cvcTextField: UITextField, validationDelegate: AccessCheckoutCvcOnlyValidationDelegate) {
        self.cvcTextField = cvcTextField
        self.validationDelegate = validationDelegate
        self.cvcView = nil
        self.textFieldMode = true
    }
}
