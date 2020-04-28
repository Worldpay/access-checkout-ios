import Foundation

/// Delegate to handle interactions between the business and view layers for a PAN UI component
public protocol PANValidationDelegate: ValidationDelegate {
    
    /// The PAN is being updated and this notifies the merchant whether the PAN is a partial match to a valid PAN
    func notifyPartialMatchValidation(forPan pan: PAN)
    
    /// The PAN ihas finished being updated and this notifies the merchant whether the PAN is a complete match to a valid PAN
    func notifyCompleteMatchValidation(forPan pan: PAN)
    
    /// Returns true if the text applied to pan using the range is a valid PAN, false otherwise
    func canUpdate(pan: PAN?, withText text: String, inRange range: NSRange) -> Bool
}
