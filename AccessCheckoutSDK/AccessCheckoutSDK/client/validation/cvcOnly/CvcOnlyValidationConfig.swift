import UIKit

/**
 An implementation of the `ValidationConfig` that represents the cvc validation configuration and that can be built using the `CvcOnlyValidationConfigBuilder`

 Use this configuration to register the relevant fields and listener.
 
 - Deprecated - using `UITextField` instances to capture cvc information is deprecated and will not be supported on future major versions of the SDK. `AccessCheckoutUITextField` should be used instead
 
 - Deprecated - using `CvcView` to initialise the validation is deprecated and will not be supported on future major versions of the SDK.  A `UITextField` should be used as above. `AccessCheckoutUITextField` should be used instead

 - SeeAlso: AccessCheckoutUITextField
 - SeeAlso: AccessCheckoutCvcOnlyValidationDelegate
 */
public struct CvcOnlyValidationConfig: ValidationConfig {
    let cvcView: CvcView?
    let cvcTextField: UITextField?
    let cvc: AccessCheckoutUITextField?

    let accessCheckoutUITextFieldMode: Bool
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
    @available(*, deprecated, message: "This constructor is deprecated and will not be supported on future major versions of the SDK. Instead, use the static `builder()` method to get an instance of a `CvcOnlyValidationConfigBuilder` to create your `CvcOnlyValidationConfig`.")
    public init(cvcView: CvcView, validationDelegate: AccessCheckoutCvcOnlyValidationDelegate) {
        self.cvcView = cvcView
        self.validationDelegate = validationDelegate
        self.cvcTextField = nil
        self.cvc = nil
        self.textFieldMode = false
        self.accessCheckoutUITextFieldMode = false
    }

    /**
     Creates an instance of `CvcOnlyValidationConfig`

     - Parameter cvcTextField: `UITextField` that represents the cvc ui element
     - Parameter validationDelegate: `AccessCheckoutCvcOnlyValidationDelegate` that represents the validation events listener
     */
    @available(*, deprecated, message: "This constructor is deprecated and will not be supported on future major versions of the SDK. Instead, use the static `builder()` method to get an instance of a `CvcOnlyValidationConfigBuilder` to create your `CvcOnlyValidationConfig`.")
    public init(cvcTextField: UITextField, validationDelegate: AccessCheckoutCvcOnlyValidationDelegate) {
        self.cvcTextField = cvcTextField
        self.validationDelegate = validationDelegate
        self.cvcView = nil
        self.cvc = nil
        self.textFieldMode = true
        self.accessCheckoutUITextFieldMode = false
    }

    /**
     Creates an instance of `CvcOnlyValidationConfig`

     - Parameter cvc: `AccessCheckoutUITextField` that represents the cvc ui element
     - Parameter validationDelegate: `AccessCheckoutCvcOnlyValidationDelegate` that represents the validation events listener
     */
    internal init(cvc: AccessCheckoutUITextField, validationDelegate: AccessCheckoutCvcOnlyValidationDelegate) {
        self.cvc = cvc
        self.validationDelegate = validationDelegate
        self.cvcView = nil
        self.cvcTextField = nil
        self.textFieldMode = false
        self.accessCheckoutUITextFieldMode = true
    }
}

/**
 Creates an instance of `CvcOnlyValidationConfig`
 An instance of this builder can be obtained by calling `CvcOnlyValidationConfig.builder()`
 
 - Deprecated - using `UITextField` instances to initialise the validation is deprecated and will not be supported on future major versions of the SDK. `AccessCheckoutUITextField` instances should be used instead
 
 - Deprecated - using `CvcView` to initialise the validation is deprecated and will not be supported on future major versions of the SDK. `AccessCheckoutUITextField` instances should be used
 */
public class CvcOnlyValidationConfigBuilder {
    private var cvcLegacy: UITextField?
    private var cvc: AccessCheckoutUITextField?
    private var validationDelegate: AccessCheckoutCvcOnlyValidationDelegate?

    fileprivate init() {}

    /**
     Deprecated
      - Parameter cvc: `UITextField` that represents the cvc ui element
      - Returns: the same instance of the builder
      */
    @available(*, deprecated, message: "This method is deprecated and will not be supported on future major versions of the SDK. `cvc(AccessCheckoutUITextField)` should be used instead.")
    public func cvc(_ cvc: UITextField) -> CvcOnlyValidationConfigBuilder {
        cvcLegacy = cvc
        return self
    }

    /**
     Sets the cvc ui element to be validated
     - Parameter cvc: `AccessCheckoutUITextField` to be validated
     - Returns: the same instance of the builder
     */
    public func cvc(_ cvc: AccessCheckoutUITextField) -> CvcOnlyValidationConfigBuilder {
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
        if cvc == nil && cvcLegacy == nil {
            throw AccessCheckoutIllegalArgumentError.missingCvc()
        }
        guard let validationDelegate = validationDelegate else {
            throw AccessCheckoutIllegalArgumentError.missingValidationDelegate()
        }

        if let cvc = cvc {
            return CvcOnlyValidationConfig(cvc: cvc, validationDelegate: validationDelegate)
        }
        return CvcOnlyValidationConfig(cvcTextField: cvcLegacy!, validationDelegate: validationDelegate)
    }
}
