import Foundation

/// Delegate to handle interactions between the business and view layers for a CVV UI component
public protocol CVVValidationDelegate: ValidationDelegate {
    
    /// The CVV is being updated and this notifies the merchant whether the CVV is a partial match to a valid CVV
    func notifyPartialMatchValidation(forCvv cvv: CVV)
    
    /// The CVV has finished being updated and this notifies the merchant whether the CVV is a complete match to a valid CVV
    func notifyCompleteMatchValidation(forCvv: CVV)
    
    /// Returns true if the text applied to cvv using the range is a valid CVV, false otherwise
    func canUpdate(cvv: CVV?, withText text: String, inRange range: NSRange) -> Bool
}
