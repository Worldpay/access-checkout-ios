import Foundation

/// Validates a card PAN, expiry date and CVV input
public protocol CardValidator {
    /// Card configuration rules
    var cardConfiguration: CardConfiguration? { get set }
    
    /// Validates combined card number, expiry date and CVV fields based on the `cardConfiguration`
    func isValid(pan: PAN?, expiryMonth: ExpiryMonth?, expiryYear: ExpiryYear?, cvv: CVV?) -> Bool
    
    /// Validates a card number
    func validate(pan: PAN) -> (valid: ValidationResult, brand: CardConfiguration.CardBrand?)
    
    /// Permits potential card number text updates
    func canUpdate(pan: PAN?, withText text: String, inRange range: NSRange) -> Bool
    
    /// Validates card CVV and any card number
    func validate(cvv: CVV, withPAN pan: PAN?) -> ValidationResult
    
    /// Permits potential card CVV text updates
    func canUpdate(cvv: CVV?, withPAN pan: PAN?, withText text: String, inRange range: NSRange) -> Bool
    
    /// Validates a card expiry date
    func validate(month: ExpiryMonth?, year: ExpiryYear?, target: Date) -> ValidationResult
    
    /// Permits potential card expiry month updates
    func canUpdate(expiryMonth: ExpiryMonth?, withText text: String, inRange range: NSRange) -> Bool
    
    /// Permits potential card expiry year updates
    func canUpdate(expiryYear: ExpiryYear?, withText text: String, inRange range: NSRange) -> Bool
}
