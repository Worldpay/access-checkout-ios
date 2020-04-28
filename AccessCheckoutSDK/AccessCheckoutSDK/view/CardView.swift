import Foundation

/// A view managed by a `Card`
public protocol CardView : class {
    
    /// Is enabled for editing
    var isEnabled: Bool { get set }
    
    /// A delegate property
    var cardViewDelegate: CardViewDelegate? { get set }
    
    /// Called when a `CardView` validity changes
    func isValid(valid: Bool)
    
    /// Clear the contents of any view input
    func clear()
}
