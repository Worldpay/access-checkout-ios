import Dispatch
import Foundation

/// A class representing a shopper's card details that can be constructed with a `CardDetailsBuilder`
/// All properties are internal and only accessible to the Access Checkout SDK.
/// This is designed to protect merchants from exposure to the card details so that they can reach the lowest level of compliance (SAQ-A)
public class CardDetails {
    internal var pan: String? { return nil }
    internal var expiryMonth: UInt? { return nil }
    internal var expiryYear: UInt? { return nil }
    internal var cvc: String? { return nil }

    fileprivate init() {}
}

/// An internal class representing a shopper's card details that can be constructed with a `CardDetailsBuilder` using instances of `AccessCheckoutUITextField` for the PAN, expiry date and cvc
/// - `pan`: an optional `AccessCheckoutUITextField` containing the PAN text
/// - `expiryDate`: an optional `AccessCheckoutUITextField` containing the expiry date text
/// - `cvc`: an optional `AccessCheckoutUITextField` containing the cvc text
internal class CardDetailsFromUIComponents: CardDetails {
    private let panUITextField: AccessCheckoutUITextField?
    private let expiryDateUITextField: AccessCheckoutUITextField?
    private let cvcUITextField: AccessCheckoutUITextField?

    override internal var pan: String? {
        if Thread.isMainThread {
            return panUITextField?.text?.replacingOccurrences(of: " ", with: "")
        } else {
            var panText: String?
            DispatchQueue.main.sync {
                panText = panUITextField?.text?.replacingOccurrences(of: " ", with: "")
            }
            return panText
        }
    }

    override internal var expiryMonth: UInt? {
        var expiryDateText: String?
        
        if Thread.isMainThread {
            expiryDateText = expiryDateUITextField?.text
        } else {
            DispatchQueue.main.sync {
                expiryDateText = expiryDateUITextField?.text
            }
        }
        
        guard let text = expiryDateText else {
            return nil
        }
        return ExpiryDateUtils.expiryMonth(of: text)
    }

    override internal var expiryYear: UInt? {
        var expiryDateText: String?
        
        if Thread.isMainThread {
            expiryDateText = expiryDateUITextField?.text
        } else {
            DispatchQueue.main.sync {
                expiryDateText = expiryDateUITextField?.text
            }
        }
        
        guard let text = expiryDateText else {
            return nil
        }
        return ExpiryDateUtils.expiryYearOn4Digits(of: text)
    }

    override internal var cvc: String? {
        var cvcText: String?
        
        if Thread.isMainThread {
            cvcText = cvcUITextField?.text
        } else {
            DispatchQueue.main.sync {
                cvcText = cvcUITextField?.text
            }
        }
        
        return cvcText
    }

    fileprivate init(
        panUITextField: AccessCheckoutUITextField?,
        expiryDateUITextField: AccessCheckoutUITextField?,
        cvcUITextField: AccessCheckoutUITextField?
    ) {
        self.panUITextField = panUITextField
        self.expiryDateUITextField = expiryDateUITextField
        self.cvcUITextField = cvcUITextField
    }
}

/// A builder designed to create an instance of the `CardDetails` class by passing references to:
/// - the `AccessCheckoutUITextField` components used to capture pan, expiry date and cvc (card payment flow)
/// - or the `AccessCheckoutUITextField` component used to capture the cvc (cvc only payment flow)
public final class CardDetailsBuilder {
    private var panUITextFied: AccessCheckoutUITextField?
    private var expiryDateUITextField: AccessCheckoutUITextField?
    private var cvcUITextField: AccessCheckoutUITextField?

    public init() {}

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
    public func expiryDate(_ accessCheckoutUITextField: AccessCheckoutUITextField)
        -> CardDetailsBuilder
    {
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
        if let expiryDateForTest = expiryDateUITextField?.text, !expiryDateForTest.isEmpty,
            !ExpiryDateUtils.isValidExpiryDate(expiryDateForTest)
        {
            throw AccessCheckoutIllegalArgumentError.invalidExpiryDateFormat(
                expiryDate: expiryDateForTest
            )
        }

        return CardDetailsFromUIComponents(
            panUITextField: panUITextFied,
            expiryDateUITextField: expiryDateUITextField,
            cvcUITextField: cvcUITextField
        )
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
