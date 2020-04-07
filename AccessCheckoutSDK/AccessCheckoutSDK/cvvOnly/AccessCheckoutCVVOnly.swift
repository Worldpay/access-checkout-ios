import Foundation

public class AccessCheckoutCVVOnly {
    
    private let cvvView:CardTextView
    private let cvvValidator:CVVValidator?
    private let cvvOnlyDelegate:CVVOnlyDelegate?

    /**
     Creates an instance of AccessCheckoutCVVOnly with validation of the CVV field text enabled.
     The CVV field text is validated whenever the user types text or exits the control.
     - Parameters:
        - cvvView: the CVVView field being validated
        - cvvOnlyDelegate: an instance of CVVOnlyDelegate which will be called on validation of the CVV entered in the cvvView field
    */
    public init (cvvView:CardTextView, cvvOnlyDelegate:CVVOnlyDelegate?) {
        self.cvvView = cvvView
        self.cvvValidator = CVVValidator()
        self.cvvOnlyDelegate = cvvOnlyDelegate
        
        cvvView.cardViewDelegate = self
    }
    
    /**
     Convenience constructor used by unit tests
     */
    init (cvvView:CardTextView, cvvOnlyDelegate:CVVOnlyDelegate?, cvvValidator:CVVValidator?) {
        self.cvvView = cvvView
        self.cvvValidator = cvvValidator
        self.cvvOnlyDelegate = cvvOnlyDelegate
        
        cvvView.cardViewDelegate = self
    }
    
    /**
     - Returns: True if the text entered in the CVVView control is a valid CVV, false otherwise.
     */
    public func isValid() -> Bool {
        return cvvValidator?.validate(cvv: cvvView.text).complete ?? true
    }
}

extension AccessCheckoutCVVOnly : CardViewDelegate {
    /**
     Returns true if the result of applying withText using selection range inRange to cvv makes up a text which is a partially valid CVV
     This is used when the text (i.e. cvv) is being edited in the CvvView UI component in order to allow or reject text edits based on the text being inputed
     - Parameters:
        - cvv: the cvv text coming from the CvvView UI component
        - withText: the text to be applied to cvv
        - range: the selection range to use to apply withText
     - Returns: True if the resulting text is a partially valid CVV, False otherwise
    */
    public func canUpdate(cvv: CVV?, withText text: String, inRange range: NSRange) -> Bool {
        let updatedText = applyTextUpdate(toText: cvv, usingRange: range, usingText: text)
        return cvvValidator?.validate(cvv: updatedText).partial ?? true
    }
    
    /**
     Notifies the client's CVVOnlyDelegate instance whether the CVV text is a partially valid CVV
     This is used when the text (i.e. cvv) is being edited in the CvvView UI component and editing has not yet finished
     - Parameter cvv: the cvv text coming from the CvvView UI component
    */
    public func didUpdate(cvv: CVV) {
        guard let cvvOnlyDelegate = self.cvvOnlyDelegate, let cvvValidator = self.cvvValidator else {
            return
        }
        
        cvvOnlyDelegate.handleValidationResult(cvvView: cvvView, isValid: cvvValidator.validate(cvv: cvv).partial)
    }
    
    /**
     Notifies the client's CVVOnlyDelegate instance whether the CVV text is a completely valid CVV
     This is used when the text (i.e. cvv) editing has finished in the CvvView UI component
     - Parameter cvv: the cvv text coming from the CvvView UI component
    */
    public func didEndUpdate(cvv: CVV) {
        guard let cvvOnlyDelegate = self.cvvOnlyDelegate, let cvvValidator = self.cvvValidator else {
            return
        }
        
        cvvOnlyDelegate.handleValidationResult(cvvView: cvvView, isValid: cvvValidator.validate(cvv: cvv).complete)
    }
    
    /**
     Unused for the CVV-only workflow but implementation is required by design.
     - Returns: false
     */
    public func canUpdate(pan: PAN?, withText text: String, inRange range: NSRange) -> Bool {
        return false
    }
    
    /**
     Unused for the CVV-only workflow but implementation is required by design. Does nothing.
    */
    public func didUpdate(pan: PAN) {
        
    }
    
    /**
     Unused for the CVV-only workflow but implementation is required by design. Does nothing.
    */
    public func didEndUpdate(pan: PAN) {
        
    }
    
    /**
     Unused for the CVV-only workflow but implementation is required by design.
     - Returns: false
    */
    public func canUpdate(expiryMonth: ExpiryMonth?, withText text: String, inRange range: NSRange) -> Bool {
        return false
    }
    
    /**
     Unused for the CVV-only workflow but implementation is required by design.
     - Returns: false
    */
    public func canUpdate(expiryYear: ExpiryYear?, withText text: String, inRange range: NSRange) -> Bool {
        return false
    }
    
    /**
     Unused for the CVV-only workflow but implementation is required by design. Does nothing.
    */
    public func didUpdate(expiryMonth: ExpiryMonth?, expiryYear: ExpiryYear?) {
        
    }
    
    /**
     Unused for the CVV-only workflow but implementation is required by design. Does nothing.
    */
    public func didEndUpdate(expiryMonth: ExpiryMonth?, expiryYear: ExpiryYear?) {
        
    }
    
    private func applyTextUpdate(toText originalText:String?, usingRange range:NSRange, usingText:String) -> String {
        if let originalText = originalText, let range = Range(range, in: originalText) {
            return originalText.replacingCharacters(in: range, with: usingText)
        } else {
            return usingText
        }
    }
    
}
