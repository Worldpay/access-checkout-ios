/// Delegate to handle interactions between the business and view layers for a CVV UI component
public protocol CVVViewDelegate: AccessCheckoutViewDelegate {
    
    /// The CVV has been updated
    func didUpdate(cvv: CVV)
    
    /// The CVV updates are complete
    func didEndUpdate(cvv: CVV)
    
    /// Request permission to update CVV with changes
    func canUpdate(cvv: CVV?, withText text: String, inRange range: NSRange) -> Bool
}
