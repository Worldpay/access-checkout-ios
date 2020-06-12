import Foundation

/// A view managed by a `Card`
protocol AccessCheckoutView {
    
    /// Is enabled for editing
    var isEnabled: Bool { get set }
    
    /// Called when a `CardView` validity changes
    func isValid(valid: Bool)
    
    /// Clear the contents of any view input
    func clear()
    
    var presenter: Presenter? { get set }
}
