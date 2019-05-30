import Foundation

/// A payment card. Manages card input and validation.
public protocol Card: CardViewDelegate {
    
    /// View capturing the card number
    var panView: CardTextView { get }
    
    /// View capturing the card expiry date
    var expiryDateView: CardDateView { get }
    
    /// View capturing the card CVV
    var cvvView: CardTextView { get }
    
    /// The Card's delegate
    var cardDelegate: CardDelegate? { get set }
    
    /// The card validator
    var cardValidator: CardValidator? { get set }
    
    /**
     - Returns: Whether the input captured by the `Card` views
     represent a valid payment card.
     */
    func isValid() -> Bool
}

/// An AccessCheckout card
public final class AccessCheckoutCard: Card {
    
    /// A view representing the card number
    public var panView: CardTextView
    
    /// A view representing the card expiry date
    public var expiryDateView: CardDateView
    
    /// A view representing the card CVV
    public var cvvView: CardTextView
    
    /// The delegate to receive card events
    public var cardDelegate: CardDelegate?
    
    /// Validates card inputs
    public var cardValidator: CardValidator?
    
    /**
     Initialises a card with the card views.
     
     - Parameters:
        - panView: The card number view
        - expiryDateView: The card expiry date view
        - cvvView: The card CVV view
     
     - Returns: An AccessCheckoutCard object
    */
    public init(panView: CardTextView,
                expiryDateView: CardDateView,
                cvvView: CardTextView) {
        
        self.panView = panView
        self.expiryDateView = expiryDateView
        self.cvvView = cvvView
     
        self.panView.cardViewDelegate = self
        self.expiryDateView.cardViewDelegate = self
        self.cvvView.cardViewDelegate = self
    }
    
    /**
     - Returns: The result of card validation; defaults to `true` if the optional `CardValidator`
     property is not set
     */
    public func isValid() -> Bool {
        return cardValidator?.isValid(pan: panView.text,
                                      expiryMonth: expiryDateView.month,
                                      expiryYear: expiryDateView.year,
                                      cvv: cvvView.text) ?? true
    }
}

extension AccessCheckoutCard: CardViewDelegate {
    
    /**
     The card number was updated.
     - Parameter pan: The card number
     */
    public func didUpdate(pan: PAN) {
     
        if let result = cardValidator?.validate(pan: pan) {
            cardDelegate?.cardView(panView, isValid: result.valid.partial)
            cardDelegate?.didChangeCardBrand(result.brand)
        }
        if let cvv = cvvView.text, let validationResult = cardValidator?.validate(cvv: cvv, withPAN: pan) {
            cardDelegate?.cardView(cvvView, isValid: validationResult.partial)
        }
    }
    
    /**
     Card number updates have completed.
     - Parameter pan: The card number
     */
    public func didEndUpdate(pan: PAN) {
        if let validationResult = cardValidator?.validate(pan: pan).valid {
            cardDelegate?.cardView(panView, isValid: validationResult.complete)
        }
    }
    
    /**
     Request permission to update card number.
     
     - Parameters:
        - pan: The card number
        - text: The updated text
        - range: The range of the updated text
     
     - Returns: Permission for the update.
     */
    public func canUpdate(pan: PAN?, withText text: String, inRange range: NSRange) -> Bool {
        return cardValidator?.canUpdate(pan: pan, withText: text, inRange: range) ?? true
    }
    
    /**
     The CVV was updated.
     - Parameter cvv: The card CVV
     */
    public func didUpdate(cvv: CVV) {
        if let valid = cardValidator?.validate(cvv: cvv, withPAN: panView.text) {
            cardDelegate?.cardView(cvvView, isValid: valid.partial)
        }
    }
    
    /**
     CVV updates have completed.
     - Parameter cvv: The card CVV
     */
    public func didEndUpdate(cvv: CVV) {
        if let valid = cardValidator?.validate(cvv: cvv, withPAN: panView.text) {
            cardDelegate?.cardView(cvvView, isValid: valid.complete)
        }
    }
    
    /**
     Request permission to update card CVV.
     
     - Parameters:
        - cvv: The card CVV
        - text: The updated text
        - range: The range of the updated text
     
     - Returns: Permission for the update.
     */
    public func canUpdate(cvv: CVV?, withText text: String, inRange range: NSRange) -> Bool {
        return cardValidator?.canUpdate(cvv: cvv, withPAN: panView.text, withText: text, inRange: range) ?? true
    }
    
    /**
     The expiry month or year was updated.
     
     - Parameters:
        - expiryMonth: The card expiry month
        - expiryYear: The card expiry year
     */
    public func didUpdate(expiryMonth: ExpiryMonth?, expiryYear: ExpiryYear?) {
        if let valid = cardValidator?.validate(month: expiryMonth ?? expiryDateView.month,
                                               year: expiryYear ?? expiryDateView.year,
                                               target: Date()) {
            cardDelegate?.cardView(expiryDateView, isValid: valid.partial)
        }
    }
    
    /**
     The expiry month or year updates have completed.
     
     - Parameters:
        - expiryMonth: The card expiry month
        - expiryYear: The card expiry year
     */
    public func didEndUpdate(expiryMonth: ExpiryMonth?, expiryYear: ExpiryYear?) {
        guard let month = expiryMonth ?? expiryDateView.month, let year = expiryYear ?? expiryDateView.year else {
            return
        }
        if let valid = cardValidator?.validate(month: month,
                                               year: year,
                                               target: Date()) {
            cardDelegate?.cardView(expiryDateView, isValid: valid.complete)
        }
    }
    
    /**
     Request permission to update card expiry month.
     
     - Parameters:
        - expiryMonth: The card expiry month
        - text: The updated text
        - range: The range of the updated text
     
     - Returns: Permission for the update.
     */
    public func canUpdate(expiryMonth: ExpiryMonth?, withText text: String, inRange range: NSRange) -> Bool {
        return cardValidator?.canUpdate(expiryMonth: expiryMonth, withText: text, inRange: range) ?? true
    }
    
    /**
     Request permission to update card expiry year.
     
     - Parameters:
        - expiryYear: The card expiry year
        - text: The updated text
        - range: The range of the updated text
     
     - Returns: Permission for the update.
     */
    public func canUpdate(expiryYear: ExpiryYear?, withText text: String, inRange range: NSRange) -> Bool {
        return cardValidator?.canUpdate(expiryYear: expiryYear, withText: text, inRange: range) ?? true
    }
}

/// A delegate for handling card input
public protocol CardDelegate {
    /// The card brand has changed
    func didChangeCardBrand(_ cardBrand: CardConfiguration.CardBrand?)
    
    /// The card view has been validated
    func cardView(_ cardView: CardView, isValid: Bool)
}

/// The card number or 'Primary Account Number'
public typealias PAN = String
/// The card CVV
public typealias CVV = String
/// The card expiry date month
public typealias ExpiryMonth = String
/// The card expiry date year
public typealias ExpiryYear = String
