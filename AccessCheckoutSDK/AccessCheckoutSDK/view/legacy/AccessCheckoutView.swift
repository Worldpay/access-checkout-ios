import Foundation

/// A view subject to validation
protocol AccessCheckoutView {
    
    /// Is enabled for editing
    var isEnabled: Bool { get set }
    
    /// Colour of the text displayed
    var textColor: UIColor? { get set }
    
    /// Clear the contents of any view input
    func clear()
    
    /// Presenter instance used by the view to interact with the business layer
    var presenter: Presenter? { get set }
}
