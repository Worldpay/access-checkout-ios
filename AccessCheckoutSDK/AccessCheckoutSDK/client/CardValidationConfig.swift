import UIKit

/// An implementation of the `ValidationConfig` that represents the card validation configuration and that can be built using the `CardValidationConfigBuilder`
///
/// Use this configuration to register the relevant fields and listener.
///
/// - SeeAlso: AccessCheckoutUITextField
/// - SeeAlso: AccessCheckoutCardValidationDelegate
public struct CardValidationConfig: ValidationConfig {
    let pan: AccessCheckoutUITextField?
    let expiryDate: AccessCheckoutUITextField?
    let cvc: AccessCheckoutUITextField?

    let validationDelegate: AccessCheckoutCardValidationDelegate

    let acceptedCardBrands: [String]
    let panFormattingEnabled: Bool

    /**
     - Returns: an instance of a builder used to create an instance  of `CardValidationConfig`
     - SeeAlso: CardValidationConfigBuilder
     **/
    public static func builder() -> CardValidationConfigBuilder {
        return CardValidationConfigBuilder()
    }

    /**
     Creates an instance of `CardValidationConfig`
    
     - Parameter pan: `AccessCheckoutUITextField` that represents the pan ui element
     - Parameter expiryDate: `AccessCheckoutUITextField` that represents the expiry date ui element
     - Parameter cvc: `AccessCheckoutUITextField` that represents the cvc ui element
     - Parameter validationDelegate: `AccessCheckoutCardValidationDelegate` that represents the validation events listener
     - Parameter acceptedCardBrands: `Array` of `String` that represents the list of card brands to accept for validation. Any unrecognised card brand will be accepted at all times.
     - Parameter panFormattingEnabled: `Bool` that represents whether the PAN field will be formatted.
     */
    internal init(
        pan: AccessCheckoutUITextField,
        expiryDate: AccessCheckoutUITextField,
        cvc: AccessCheckoutUITextField,
        validationDelegate: AccessCheckoutCardValidationDelegate,
        acceptedCardBrands: [String] = [],
        panFormattingEnabled: Bool = false
    ) {
        self.pan = pan
        self.expiryDate = expiryDate
        self.cvc = cvc

        self.validationDelegate = validationDelegate

        self.acceptedCardBrands = acceptedCardBrands
        self.panFormattingEnabled = panFormattingEnabled
    }
}

/// Creates an instance of `CardValidationConfig`
/// An instance of this builder can be obtained by calling `CardValidationConfig.builder()
public class CardValidationConfigBuilder {
    private var pan: AccessCheckoutUITextField?
    private var expiryDate: AccessCheckoutUITextField?
    private var cvc: AccessCheckoutUITextField?

    private var validationDelegate: AccessCheckoutCardValidationDelegate?
    private var acceptedCardBrands: [String] = []
    private var panFormattingEnabled: Bool = false

    fileprivate init() {}

    /**
     Sets the pan ui element to be validated
     - Parameter pan: `AccessCheckoutUITextField` to be validated
     - Returns: the same instance of the builder
     */
    public func pan(_ pan: AccessCheckoutUITextField) -> CardValidationConfigBuilder {
        self.pan = pan
        return self
    }

    /**
     Sets the expiry date ui element to be validated
     - Parameter expiryDate: `AccessCheckoutUITextField` to be validated
     - Returns: the same instance of the builder
     */
    public func expiryDate(_ expiryDate: AccessCheckoutUITextField) -> CardValidationConfigBuilder {
        self.expiryDate = expiryDate
        return self
    }

    /**
     Sets the cvc ui element to be validated
     - Parameter cvc: `AccessCheckoutUITextField` to be validated
     - Returns: the same instance of the builder
     */
    public func cvc(_ cvc: AccessCheckoutUITextField) -> CardValidationConfigBuilder {
        self.cvc = cvc
        return self
    }

    /**
     - Parameter validationDelegate: `AccessCheckoutCardValidationDelegate` that represents the merchant's delegate that should be notified on validation changes
     - Returns: the same instance of the builder
     */
    public func validationDelegate(_ validationDelegate: AccessCheckoutCardValidationDelegate)
        -> CardValidationConfigBuilder
    {
        self.validationDelegate = validationDelegate
        return self
    }

    /**
     - Parameter acceptedCardBrands: `Array` of `String`that represents the list of card brands to accept for validation. Any unrecognised card brand will be accepted at all times.
     - Returns: the same instance of the builder
     */
    public func acceptedCardBrands(_ acceptedCardBrands: [String]) -> CardValidationConfigBuilder {
        self.acceptedCardBrands = acceptedCardBrands
        return self
    }

    /**
     - Parameter enablePanFormatting: enables the automatic formatting of the pan field
     - Returns: the same instance of the builder
     */
    public func enablePanFormatting() -> CardValidationConfigBuilder {
        panFormattingEnabled = true
        return self
    }

    /**
     Use this method to create an instance of `CardValidationConfig`
     - Returns: an instance of `CardValidationConfig`
    
     - Throws: an `AccessCheckoutIllegalArgumentError` if either the pan, expiryDate, cvc, accessBaseUrl or validationDelegate have not been specified
     */
    public func build() throws -> CardValidationConfig {
        if pan == nil {
            throw AccessCheckoutIllegalArgumentError.missingPan()
        }
        if expiryDate == nil {
            throw AccessCheckoutIllegalArgumentError.missingExpiryDate()
        }
        if cvc == nil {
            throw AccessCheckoutIllegalArgumentError.missingCvc()
        }
        guard let validationDelegate = validationDelegate else {
            throw AccessCheckoutIllegalArgumentError.missingValidationDelegate()
        }
        return CardValidationConfig(
            pan: pan!,
            expiryDate: expiryDate!,
            cvc: cvc!,
            validationDelegate: validationDelegate,
            acceptedCardBrands: acceptedCardBrands,
            panFormattingEnabled: panFormattingEnabled
        )
    }
}
