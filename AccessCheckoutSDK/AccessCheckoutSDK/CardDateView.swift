/// A view representing a date field
public protocol CardDateView: CardView {
    
    /// The date's month
    var month: String? { get }
    
    /// The date's year
    var year: String? { get }
}
