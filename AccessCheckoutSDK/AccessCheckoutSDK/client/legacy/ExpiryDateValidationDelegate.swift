import Foundation

/// Delegate to handle interactions between the business and view layers for an Expiry Date UI component
public protocol ExpiryDateValidationDelegate: ValidationDelegate {
    
    /// The expiry month and year are being updated and this notifies the merchant whether they are a partial match to a valid expiry month and year
    func notifyPartialMatchValidation(forExpiryMonth expiryMonth: ExpiryMonth?, andExpiryYear expiryYear: ExpiryYear?)
    
    /// The expiry month and year have finished being updated and this notifies the merchant whether they are a complete match to a valid expiry month and year
    func notifyCompleteMatchValidation(forExpiryMonth expiryMonth: ExpiryMonth?, andExpiryYear expiryYear: ExpiryYear?)
    
    /// Returns true if the text applied to expiryMonth using the range is a valid expiry month, false otherwise
    func canUpdate(expiryMonth: ExpiryMonth?, withText text: String, inRange range: NSRange) -> Bool
    
    /// Returns true if the text applied to expiryYear using the range is a valid expiry year, false otherwise
    func canUpdate(expiryYear: ExpiryYear?, withText text: String, inRange range: NSRange) -> Bool
}
