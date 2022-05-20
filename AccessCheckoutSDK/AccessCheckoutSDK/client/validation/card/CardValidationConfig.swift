import UIKit

/**
 An implementation of the `ValidationConfig` that represents the card validation configuration.
 
 Use this configuration to register the relevant fields and listener.
 
 - panTextField: `UITextField` that represents the pan ui element
 - expiryDateTextField: `UITextField` that represents the expiry date ui element
 - cvcTextField: `UITextField` that represents the cvc ui element
 - accessBaseUrl: `String` that represents the base url to use when calling Worldpay services
 - validationDelegate: `AccessCheckoutCardValidationDelegate` that represents the validation delegate that should be notified on validation changes
 - acceptedCardBrands: `Array` of `String` that represents the list of card brands to accept for validation. Any unrecognised card brand will be accepted at all times.
 - panFormattingEnabled: `Bool` that represents whether the PAN field will be formatted.
 
 Deprecated - using the Views below to initialise the validation is deprecated and will not be supported on future major versions of the SDK. `UITextField`s should be used as above.
 
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
     
     - Parameter panTextField: `UITextField` that represents the pan ui element
     - Parameter expiryDateTextField: `UITextField` that represents the expiry date ui element
     - Parameter cvcTextField: `UITextField` that represents the cvc ui element
     - Parameter accessBaseUrl: `String` that represents the base url
     - Parameter validationDelegate: `AccessCheckoutCardValidationDelegate` that represents the validation events listener
     - Parameter acceptedCardBrands: `Array` of `String` that represents the list of card brands to accept for validation. Any unrecognised card brand will be accepted at all times.
     - Parameter panFormattingEnabled: `Bool` that represents whether the PAN field will be formatted.
     */
    @available(*, deprecated, message: "This constructor is deprecated and will not be supported on future major versions of the SDK. Instead, use the static `builder()` method to get an instance of a `CardValidationConfigBuilder` to create your `CardValidationConfig`.")
    public init(panTextField: UITextField,
                expiryDateTextField: UITextField,
                cvcTextField: UITextField,
                accessBaseUrl: String,
                validationDelegate: AccessCheckoutCardValidationDelegate,
                acceptedCardBrands: [String] = [],
                panFormattingEnabled: Bool = false) {
        self.panTextField = panTextField
        self.expiryDateTextField = expiryDateTextField
        self.cvcTextField = cvcTextField
        self.accessBaseUrl = accessBaseUrl
        self.validationDelegate = validationDelegate
        
        self.panView = nil
        self.expiryDateView = nil
        self.cvcView = nil
        
        self.textFieldMode = true
        self.acceptedCardBrands = acceptedCardBrands
        self.panFormattingEnabled = panFormattingEnabled
    }
    
    /**
     Deprecated
     Creates an instance of `CardValidationConfig`
     
     - Parameter panView: `PanView` that represents the pan ui element
     - Parameter expiryDateView: `ExpiryDateView` that represents the expiry date ui element
     - Parameter cvcView: `CvcView` that represents the cvc ui element
     - Parameter accessBaseUrl: `String` that represents the base url
     - Parameter validationDelegate: `AccessCheckoutCardValidationDelegate` that represents the validation events listener
     - Parameter acceptedCardBrands: `Array` of `String` that represents the list of card brands to accept for validation. Any unrecognised card brand will be accepted at all times.
     - Parameter panFormattingEnabled: `Bool` that represents whether the PAN field will be formatted.
     */
    @available(*, deprecated, message: "Using PanView, ExpiryDateView and CvcView to initialize the validation is deprecated and will not be supported on future major versions of the SDK. `UITextField`s should be used instead.")
    public init(panView: PanView,
                expiryDateView: ExpiryDateView,
                cvcView: CvcView,
                accessBaseUrl: String,
                validationDelegate: AccessCheckoutCardValidationDelegate,
                acceptedCardBrands: [String] = [],
                panFormattingEnabled: Bool = false) {
        self.panView = panView
        self.expiryDateView = expiryDateView
        self.cvcView = cvcView
        self.accessBaseUrl = accessBaseUrl
        self.validationDelegate = validationDelegate
        
        self.panTextField = nil
        self.expiryDateTextField = nil
        self.cvcTextField = nil
        
        self.textFieldMode = false
        self.acceptedCardBrands = acceptedCardBrands
        self.panFormattingEnabled = panFormattingEnabled
    }
}

/**
 Creates an instance of `CardValidationConfig`
 An instance of this builder can be obtained by calling `CardValidationConfig.builder()`
 */
public class CardValidationConfigBuilder {
    private var pan: UITextField?
    private var expiryDate: UITextField?
    private var cvc: UITextField?
    private var accessBaseUrl: String?
    private var validationDelegate: AccessCheckoutCardValidationDelegate?
    private var acceptedCardBrands: [String] = []
    private var panFormattingEnabled: Bool = false
    
    fileprivate init() {}
    
    /**
     - Parameter pan: UITextField that represents the pan ui element
     - Returns: the same instance of the builder
     */
    public func pan(_ pan: UITextField) -> CardValidationConfigBuilder {
        self.pan = pan
        return self
    }
    
    /**
     - Parameter expiryDate: `UITextField` that represents the expiry date ui element
     - Returns: the same instance of the builder
     */
    public func expiryDate(_ expiryDate: UITextField) -> CardValidationConfigBuilder {
        self.expiryDate = expiryDate
        return self
    }
    
    /**
     - Parameter cvc: `UITextField` that represents the cvc ui element
     - Returns: the same instance of the builder
     */
    public func cvc(_ cvc: UITextField) -> CardValidationConfigBuilder {
        self.cvc = cvc
        return self
    }
    
    /**
     - Parameter accessBaseUrl: `String` that represents the base url
     - Returns: the same instance of the builder
     */
    public func accessBaseUrl(_ accessBaseUrl: String) -> CardValidationConfigBuilder {
        self.accessBaseUrl = accessBaseUrl
        return self
    }
    
    /**
     - Parameter validationDelegate: `AccessCheckoutCardValidationDelegate` that represents the validation events listener
     - Returns: the same instance of the builder
     */
    public func validationDelegate(_ validationDelegate: AccessCheckoutCardValidationDelegate) -> CardValidationConfigBuilder {
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
     - Parameter enablePanFormatting: enables the automatic formatting of Pan field
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
        guard let pan = pan else {
            throw AccessCheckoutIllegalArgumentError.missingPan()
        }
        guard let expiryDate = expiryDate else {
            throw AccessCheckoutIllegalArgumentError.missingExpiryDate()
        }
        guard let cvc = cvc else {
            throw AccessCheckoutIllegalArgumentError.missingCvc()
        }
        guard let accessBaseUrl = accessBaseUrl else {
            throw AccessCheckoutIllegalArgumentError.missingAccessBaseUrl()
        }
        guard let validationDelegate = validationDelegate else {
            throw AccessCheckoutIllegalArgumentError.missingValidationDelegate()
        }
        
        return CardValidationConfig(panTextField: pan,
                                    expiryDateTextField: expiryDate,
                                    cvcTextField: cvc,
                                    accessBaseUrl: accessBaseUrl,
                                    validationDelegate: validationDelegate,
                                    acceptedCardBrands: acceptedCardBrands,
                                    panFormattingEnabled: panFormattingEnabled)
    }
}
