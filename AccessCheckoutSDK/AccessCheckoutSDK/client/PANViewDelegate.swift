/// Delegate to handle interactions between the business and view layers for a PAN UI component
public protocol PANViewDelegate: AccessCheckoutViewDelegate {
    
    /// The card number has been updated
    func didUpdate(pan: PAN)
    
    /// The card number updates are complete
    func didEndUpdate(pan: PAN)
    
    /// Request permission to update card number with changes
    func canUpdate(pan: PAN?, withText text: String, inRange range: NSRange) -> Bool
}
