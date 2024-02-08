import UIKit

/**
 An implementation of the `ValidationConfig` that represents the cvc validation configuration and that can be built using the `CvcOnlyValidationConfigBuilder`

 Use this configuration to register the relevant fields and listener.

 - SeeAlso: AccessCheckoutUITextField
 - SeeAlso: AccessCheckoutCvcOnlyValidationDelegate
 */
public struct CvcOnlyValidationConfig: ValidationConfig {
    let cvc: AccessCheckoutUITextField?
    let validationDelegate: AccessCheckoutCvcOnlyValidationDelegate

    /**
     - Returns: an instance of a builder used to create an instance  of `CvcOnlyValidationConfig`
     - SeeAlso: CvcOnlyValidationConfigBuilder
     **/
    public static func builder() -> CvcOnlyValidationConfigBuilder {
        return CvcOnlyValidationConfigBuilder()
    }

    /**
     Creates an instance of `CvcOnlyValidationConfig`

     - Parameter cvc: `AccessCheckoutUITextField` that represents the cvc ui element
     - Parameter validationDelegate: `AccessCheckoutCvcOnlyValidationDelegate` that represents the validation events listener
     */
    internal init(cvc: AccessCheckoutUITextField, validationDelegate: AccessCheckoutCvcOnlyValidationDelegate) {
        self.cvc = cvc
        self.validationDelegate = validationDelegate
    }
}

/**
 Creates an instance of `CvcOnlyValidationConfig`
 An instance of this builder can be obtained by calling `CvcOnlyValidationConfig.builder()`
 */
public class CvcOnlyValidationConfigBuilder {
    private var cvc: AccessCheckoutUITextField?
    private var validationDelegate: AccessCheckoutCvcOnlyValidationDelegate?

    fileprivate init() {}

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
        if cvc == nil {
            throw AccessCheckoutIllegalArgumentError.missingCvc()
        }
        guard let validationDelegate = validationDelegate else {
            throw AccessCheckoutIllegalArgumentError.missingValidationDelegate()
        }

        return CvcOnlyValidationConfig(cvc: cvc!, validationDelegate: validationDelegate)
    }
}
