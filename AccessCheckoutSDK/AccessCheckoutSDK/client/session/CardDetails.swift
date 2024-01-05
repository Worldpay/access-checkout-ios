/**
 A class representing a shopper's card details that can be constructed with a `CardDetailsBuilder`
 All properties are internal and only accessible to the Access Checkout SDK.
 This is designed to protect merchants from exposure to the card details so that they can reach the lowest level of compliance (SAQ-A)
 */
public class CardDetails {
    internal var pan: String? { return nil }
    internal var expiryMonth: UInt? { return nil }
    internal var expiryYear: UInt? { return nil }
    internal var cvc: String? { return nil }
    
    fileprivate init() {}
}

/**
 An internal class representing a shopper's card details that can be constructed with a `CardDetailsBuilder` using plain `String` objects for the PAN and cvc, and plain `UInt` for the expiry month and year
 
 - `pan`: an optional `String` containing the PAN
 - `expiryMonth`: an optional `UInt` containing the month part of an expiry date
 - `expiryYear`: an optional `UInt` containing the year part of an expiry date in a 4 digits format
 - `cvc`: an optional `String` containing the cvc
 */
internal class CardDetailsFromValues: CardDetails {
    private var _pan: String?
    override internal private(set) var pan: String? {
        get {
            return _pan
        }
        set {
            _pan = newValue
        }
    }
    
    private var _expiryMonth: UInt?
    override internal private(set) var expiryMonth: UInt? {
        get {
            return _expiryMonth
        }
        set {
            _expiryMonth = newValue
        }
    }
    
    private var _expiryYear: UInt?
    override internal private(set) var expiryYear: UInt? {
        get {
            return _expiryYear
        }
        set {
            _expiryYear = newValue
        }
    }
    
    private var _cvc: String?
    override internal private(set) var cvc: String? {
        get {
            return _cvc
        }
        set {
            _cvc = newValue
        }
    }
    
    fileprivate init(pan: String?, expiryMonth: UInt?, expiryYear: UInt?, cvc: String?) {
        self._pan = pan
        self._expiryMonth = expiryMonth
        self._expiryYear = expiryYear
        self._cvc = cvc
    }
}

/**
 An internal class representing a shopper's card details that can be constructed with a `CardDetailsBuilder` using instances of `AccessCheckoutUITextField` for the PAN, expiry date and cvc
 - `pan`: an optional `AccessCheckoutUITextField` containing the PAN text
 - `expiryDate`: an optional `AccessCheckoutUITextField` containing the expiry date text
 - `cvc`: an optional `AccessCheckoutUITextField` containing the cvc text
 */
internal class CardDetailsFromUIComponents: CardDetails {
    private let panUITextField: AccessCheckoutUITextField?
    private let expiryDateUITextField: AccessCheckoutUITextField?
    private let cvcUITextField: AccessCheckoutUITextField?
    
    override internal var pan: String? {
        return panUITextField?.text?.replacingOccurrences(of: " ", with: "")
    }
    
    override internal var expiryMonth: UInt? {
        guard let expiryDateText = expiryDateUITextField?.text else {
            return nil
        }
        return ExpiryDateUtils.expiryMonth(of: expiryDateText)
    }
    
    override internal var expiryYear: UInt? {
        guard let expiryDateText = expiryDateUITextField?.text else {
            return nil
        }
        return ExpiryDateUtils.expiryYearOn4Digits(of: expiryDateText)
    }
    
    override internal var cvc: String? {
        return cvcUITextField?.text
    }

    fileprivate init(panUITextField: AccessCheckoutUITextField?,
                     expiryDateUITextField: AccessCheckoutUITextField?,
                     cvcUITextField: AccessCheckoutUITextField?)
    {
        self.panUITextField = panUITextField
        self.expiryDateUITextField = expiryDateUITextField
        self.cvcUITextField = cvcUITextField
    }
}

/**
 A builder designed to create an instance of the `CardDetails` class by passing references to:
 - the `AccessCheckoutUITextField` components used to capture pan, expiry date and cvc (card payment flow)
 - or the `AccessCheckoutUITextField` component used to capture the cvc (cvc only payment flow)
 */
public final class CardDetailsBuilder {
    private var pan: String?
    private var cvc: String?
    private var expiryDate: String?
    
    private var panUITextFied: AccessCheckoutUITextField?
    private var expiryDateUITextField: AccessCheckoutUITextField?
    private var cvcUITextField: AccessCheckoutUITextField?
    
    public init() {}
    
    /**
     Sets the pan using an instance of `String`
     
     - Parameter pan: `String` that represents the pan
     
     - Returns: the `CardDetailsBuilder` instance in order to chain further operations
     */
    @available(*, deprecated, message: "CardDetails should now be built using instances of `AccessCheckoutUITextField` rather than actual card details. The support for passing card details as `String` will be removed in the next major version.")
    public func pan(_ pan: String) -> CardDetailsBuilder {
        self.pan = pan.replacingOccurrences(of: " ", with: "")
        return self
    }
    
    /**
     Sets the expiry month and year using an instance of `String`
     
     - Parameter expiryDate: `String` that represents the expiry date in mm/yy format
     
     - Returns: the `CardDetailsBuilder` instance in order to chain further operations
     */
    @available(*, deprecated, message: "CardDetails should now be built using instances of `AccessCheckoutUITextField` rather than actual card details. The support for passing card details as `String` will be removed in the next major version.")
    public func expiryDate(_ expiryDate: String) -> CardDetailsBuilder {
        self.expiryDate = expiryDate
        return self
    }
    
    /**
     Sets the cvc using an instance of `String`
     
     - Parameter cvc: `String` that represents the cvc
     
     - Returns: the `CardDetailsBuilder` instance in order to chain further operations
     */
    @available(*, deprecated, message: "CardDetails should now be built using instances of `AccessCheckoutUITextField` rather than actual card details. The support for passing card details as `String` will be removed in the next major version.")
    public func cvc(_ cvc: String) -> CardDetailsBuilder {
        self.cvc = cvc
        return self
    }
    
    /**
     Sets the pan using an instance of `AccessCheckoutUITextField`
     
     - Parameter accessCheckoutUITextField: `AccessCheckoutUITextField` used to capture the pan

     - Returns: the `CardDetailsBuilder` instance in order to chain further operations
     */
    public func pan(_ accessCheckoutUITextField: AccessCheckoutUITextField) -> CardDetailsBuilder {
        panUITextFied = accessCheckoutUITextField
        return self
    }
    
    /**
     Sets the expiry date using an instance of `AccessCheckoutUITextField`
     
     - Parameter pan: `AccessCheckoutUITextField` used to capture the expiry date

     - Returns: the `CardDetailsBuilder` instance in order to chain further operations
     */
    public func expiryDate(_ accessCheckoutUITextField: AccessCheckoutUITextField) -> CardDetailsBuilder {
        expiryDateUITextField = accessCheckoutUITextField
        return self
    }
    
    /**
     Sets the cvc using an instance of `AccessCheckoutUITextField`
     
     - Parameter accessCheckoutUITextField: `AccessCheckoutUITextField` used to capture the cvc

     - Returns: the `CardDetailsBuilder` instance in order to chain further operations
     */
    public func cvc(_ accessCheckoutUITextField: AccessCheckoutUITextField) -> CardDetailsBuilder {
        cvcUITextField = accessCheckoutUITextField
        return self
    }
    
    /**
     Builds an instance of a class that conform to the internal contract of `CardDetails`
     
     - Returns: an instance of a class conforming to the internal contract of `CardDetails` and containig card details
     
     - Throws: `AccessCheckoutIllegalArgumentError` in case where the expiry date is provided in an invalid format
     */
    public func build() throws -> CardDetails {
        if pan != nil || expiryDate != nil || cvc != nil {
            if let expiryDateForTest = expiryDate, !expiryDateForTest.isEmpty, !ExpiryDateUtils.isValidExpiryDate(expiryDateForTest) {
                throw AccessCheckoutIllegalArgumentError.invalidExpiryDateFormat(expiryDate: expiryDateForTest)
            }
            
            return CardDetailsFromValues(pan: pan,
                                         expiryMonth: ExpiryDateUtils.expiryMonth(of: expiryDate),
                                         expiryYear: ExpiryDateUtils.expiryYearOn4Digits(of: expiryDate),
                                         cvc: cvc)
        } else if panUITextFied != nil || expiryDateUITextField != nil || cvcUITextField != nil {
            if let expiryDateForTest = expiryDateUITextField?.text, !expiryDateForTest.isEmpty, !ExpiryDateUtils.isValidExpiryDate(expiryDateForTest) {
                throw AccessCheckoutIllegalArgumentError.invalidExpiryDateFormat(expiryDate: expiryDateForTest)
            }
            return CardDetailsFromUIComponents(
                panUITextField: panUITextFied,
                expiryDateUITextField: expiryDateUITextField,
                cvcUITextField: cvcUITextField
            )
        }
        return CardDetailsFromValues(pan: nil, expiryMonth: nil, expiryYear: nil, cvc: nil)
    }
}

private enum ExpiryDateUtils {
    private static let expiryDateValidationPattern = "^((0[1-9])|(1[0-2]))\\/?(\\d{2})$"
    
    fileprivate static func isValidExpiryDate(_ text: String) -> Bool {
        return text.range(of: expiryDateValidationPattern, options: .regularExpression) != nil
    }

    fileprivate static func expiryMonth(of expiryDate: String?) -> UInt? {
        guard let expiryDate = expiryDate else {
            return nil
        }
        
        return UInt(expiryDate.prefix(2))
    }
    
    fileprivate static func expiryYearOn4Digits(of expiryDate: String?) -> UInt? {
        guard let expiryDate = expiryDate else {
            return nil
        }
        
        return toFourDigitFormat(UInt(expiryDate.suffix(2)))
    }
    
    fileprivate static func toFourDigitFormat(_ number: UInt?) -> UInt? {
        guard let number = number else {
            return nil
        }
        return number < 100 ? number + 2000 : number
    }
}
