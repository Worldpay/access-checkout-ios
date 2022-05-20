import UIKit

/**
 An implementation of the [ValidationConfig] that represents the cvc validation configuration.

 This configuration should be built to register the relevant fields and the listeners.
 - cvcTextField: `UITextField` that represents the cvc ui element
 - accessBaseUrl: `String` that represents the base url to use when calling Worldpay services
 - validationDelegate: `AccessCheckoutCvcOnlyValidationDelegate` that represents the validation delegate that should be notified on validation changes
 
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
     - Returns: an instance of a builder used to create an instance  of `CvcOnlyValidationConfig`
     - SeeAlso: CvcOnlyValidationConfigBuilder
     **/
    public static func builder() -> CvcOnlyValidationConfigBuilder {
        return CvcOnlyValidationConfigBuilder()
    }
    
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
    @available(*, deprecated, message: "This constructor is deprecated and will not be supported on future major versions of the SDK. Instead, use the static `builder()` method to get an instance of a `CvcOnlyValidationConfigBuilder` to create your `CvcOnlyValidationConfig`.")
    public init(cvcTextField: UITextField, validationDelegate: AccessCheckoutCvcOnlyValidationDelegate) {
        self.cvcTextField = cvcTextField
        self.validationDelegate = validationDelegate
        self.cvcView = nil
        self.textFieldMode = true
    }
}

/**
 Creates an instance of `CvcOnlyValidationConfig`
 An instance of this builder can be obtained by calling `CvcOnlyValidationConfig.builder()`
 */
public class CvcOnlyValidationConfigBuilder {
    private var cvc: UITextField?
    private var validationDelegate: AccessCheckoutCvcOnlyValidationDelegate?

    fileprivate init() {}

    /**
     - Parameter cvc: `UITextField` that represents the cvc ui element
     - Returns: the same instance of the builder
     */
    public func cvc(_ cvc: UITextField) -> CvcOnlyValidationConfigBuilder {
        self.cvc = cvc
        return self
    }

    /**
     - Parameter validationDelegate: `AccessCheckoutCvcOnlyValidationDelegate` that represents the validation events listener
     - Returns: the same instance of the builder
     */
    public func validationDelegate(_ validationDelegate: AccessCheckoutCvcOnlyValidationDelegate) -> CvcOnlyValidationConfigBuilder {
        self.validationDelegate = validationDelegate
        return self
    }

    /**
     Use this method to create an instance of `CvcOnlyValidationConfig`
     - Returns: an instance of `CvcOnlyValidationConfig`
     - Throws: an `AccessCheckoutIllegalArgumentError` if either the cvc or validationDelegate have not been specified
     */
    public func build() throws -> CvcOnlyValidationConfig {
        guard let cvc = cvc else {
            throw AccessCheckoutIllegalArgumentError.missingCvc()
        }
        guard let validationDelegate = validationDelegate else {
            throw AccessCheckoutIllegalArgumentError.missingValidationDelegate()
        }

        return CvcOnlyValidationConfig(cvcTextField: cvc, validationDelegate: validationDelegate)
    }
}

