/// An Access Checkout `CardValidator`
final public class AccessCheckoutCardValidator: CardValidator {
    
    /// The base card configuration, will be overridden by any `cardConfiguration`
    private let baseCardDefaults: CardConfiguration.CardDefaults
    
    /// The configuration to validate against
    public var cardConfiguration: CardConfiguration?
    
    /// The validor used to validate text against a generic validation rule
    private var textValidator = TextValidator()
    
    /// The validor used to validate a CVV against a validation rule
    private var cvvValidator = CVVValidator()
    
    /// Initializes the validator with basic card configuration defaults
    public init(cardDefaults: CardConfiguration.CardDefaults = CardConfiguration.CardDefaults.baseDefaults()) {
        baseCardDefaults = cardDefaults
    }
    
    /**
     Validates all card input.
     
     - Parameters:
        - pan: The card number
        - expiryMonth: The card expiry month
        - expiryYear: The card expiry year
        - cvv: The card CVV
     
     - Returns: The result of validation.
    */
    public func isValid(pan: PAN?, expiryMonth: ExpiryMonth?, expiryYear: ExpiryYear?, cvv: CVV?) -> Bool {
        guard let pan = pan, let month = expiryMonth, let year = expiryYear, let cvv = cvv else {
            return false
        }
        let now = Date()
        return validate(pan: pan).valid.complete &&
            validate(month: month, year: year, target: now).complete &&
            validate(cvv: cvv, withPAN: pan).complete
    }
    
    /**
     Validates a card number.
     
     - Parameter pan: The card number
     
     - Returns: A tuple containing the result of the validation and any matching card brand.
     */
    public func validate(pan: PAN) -> (valid: ValidationResult, brand: CardConfiguration.CardBrand?) {
        
        let cardBrand = cardConfiguration?.cardBrand(forPAN: pan)
        let panRule = cardBrand?.cardValidationRule(forPAN: pan) ?? cardConfiguration?.defaults?.pan ?? baseCardDefaults.pan!
        var validationResult = textValidator.validate(text: pan, againstValidationRule: panRule)

        if validationResult.complete {
            let validLuhn = pan.isValidLuhn()
            validationResult = ValidationResult(partial: validLuhn, complete: validLuhn)
        }
        return (validationResult, cardBrand)
    }
    
    /**
     Requests permission to update the card number.
     
     - Parameters:
        - pan: The card number
        - text: Proposed text
        - range: Proposed text range
     
     - Returns: Permission for the update.
     */
    public func canUpdate(pan: PAN?, withText text: String, inRange range: NSRange) -> Bool {
        guard text.isEmpty == false else {
            return true // Always allow deletion
        }
        let expectedPan: String
        var panRule: CardConfiguration.CardValidationRule?
        if let currentPan = pan, let range = Range(range, in: currentPan) {
            expectedPan = currentPan.replacingCharacters(in: range, with: text)
            panRule = cardConfiguration?.cardBrand(forPAN: currentPan)?.cardValidationRule(forPAN: currentPan)
        } else {
            expectedPan = text
        }
        let rule = panRule ?? cardConfiguration?.defaults?.pan ?? baseCardDefaults.pan!
        return textValidator.validate(text: expectedPan, againstValidationRule: rule).partial
    }
    
    /**
     Validates a card CVV against a card number if present.
     
     - Parameters:
        - cvv: The card CVV
        - withPAN: The card number
     
     - Returns: The result of the validation.
     */
    public func validate(cvv: CVV, withPAN pan: PAN?) -> ValidationResult {
        var cvvRule: CardConfiguration.CardValidationRule?
        if let pan = pan {
            cvvRule = cardConfiguration?.cardBrand(forPAN: pan)?.cvv
        }
        let rule = cvvRule ?? cardConfiguration?.defaults?.cvv ?? baseCardDefaults.cvv!
        return cvvValidator.validate(cvv: cvv, againstValidationRule: rule)
    }
    
    /**
     Requests permission to update the card CVV.
     
     - Parameters:
        - cvv: The card CVV
        - pan: The card number
        - text: Proposed text
        - range: Proposed text range
     
     - Returns: Permission for the update.
     */
    public func canUpdate(cvv: CVV?, withPAN pan: PAN?, withText text: String, inRange range: NSRange) -> Bool {
        guard text.isEmpty == false else {
            return true // Always allow deletion
        }
        
        var cvvRule: CardConfiguration.CardValidationRule?
        if let pan = pan {
            cvvRule = cardConfiguration?.cardBrand(forPAN: pan)?.cvv
        }
        let rule = cvvRule ?? cardConfiguration?.defaults?.cvv ?? baseCardDefaults.cvv!
        
        let expectedCVV: String
        if let cvv = cvv, let range = Range(range, in: cvv) {
            expectedCVV = cvv.replacingCharacters(in: range, with: text)
        } else {
            expectedCVV = text
        }
        return cvvValidator.validate(cvv: expectedCVV, againstValidationRule: rule).partial
    }
    
    /**
     Requests permission to update the card expiry month.
     
     - Parameters:
        - expiryMonth: The card expiry date month
        - text: Proposed text
        - range: Proposed text range
     
     - Returns: Permission for the update.
     */
    public func canUpdate(expiryMonth: ExpiryMonth?, withText text: String, inRange range: NSRange) -> Bool {
        guard text.isEmpty == false else {
            return true // Always allow deletion
        }
        guard let month = expiryMonth else {
            return true
        }
        let expectedMonth: String
        if let range = Range(range, in: month) {
            expectedMonth = month.replacingCharacters(in: range, with: text)
        } else {
            expectedMonth = text
        }
        let rule = cardConfiguration?.defaults?.month ?? baseCardDefaults.month!
        return textValidator.validate(text: expectedMonth, againstValidationRule: rule).partial
    }
    
    /**
     Validates a card expiry date.
     
     - Parameters:
        - month: The card expiry date month
        - year: The card expiry date year
        - target: The date against which to validate, typically the current current date
     
     - Returns: The result of the validation.
     */
    public func validate(month: ExpiryMonth?, year: ExpiryYear?, target: Date) -> ValidationResult {
        
        let monthRule = cardConfiguration?.defaults?.month ?? baseCardDefaults.month!
        let yearRule = cardConfiguration?.defaults?.year ?? baseCardDefaults.year!
        
        var partiallyValid = true
        var completelyValid = true
        
        if let expiryMonth = month, let expiryYear = year {
            let monthValid = textValidator.validate(text: expiryMonth, againstValidationRule: monthRule)
            let yearValid = textValidator.validate(text: expiryYear, againstValidationRule: yearRule)
            partiallyValid = monthValid.partial && yearValid.partial
            completelyValid = monthValid.complete && yearValid.complete
            if completelyValid {
                let dateComponents = Calendar.current.dateComponents([.month, .year], from: target)
                if let targetMonth = dateComponents.month,
                    let targetYear = dateComponents.year,
                    let month = Int(expiryMonth),
                    let year = expiryYear.toFourDigitFormat() {
                        if month == 0 {
                            completelyValid = false
                        }
                        if year < targetYear {
                            partiallyValid = false
                            completelyValid = false
                        } else if year == targetYear && month < targetMonth {
                            partiallyValid = false
                            completelyValid = false
                        }
                }
            }
        } else if let expiryMonth = month {
            let valid = textValidator.validate(text: expiryMonth, againstValidationRule: monthRule)
            partiallyValid = valid.partial
            completelyValid = valid.complete
            // Numeric month handling
            if completelyValid, let intMonth = Int(expiryMonth) {
                completelyValid = intMonth > 0
            }
        } else if let expiryYear = year {
            let valid = textValidator.validate(text: expiryYear, againstValidationRule: yearRule)
            partiallyValid = valid.partial
            completelyValid = valid.complete
            if completelyValid {
                let dateComponents = Calendar.current.dateComponents([.month, .year], from: target)
                if let year = Int(expiryYear), let targetYear = dateComponents.year {
                    var inputYear = year
                    if expiryYear.count == 2 { // 2 digit date handling
                        inputYear += 2000
                    }
                    partiallyValid = inputYear >= targetYear
                    completelyValid = false
                }
            }
        } else {
            completelyValid = false
        }
        return ValidationResult(partial: partiallyValid, complete: completelyValid)
    }
    
    /**
     Requests permission to update the card expiry year.
     
     - Parameters:
     - expiryYear: The card expiry date month
     - text: Proposed text
     - range: Proposed text range
     
     - Returns: Permission for the update.
     */
    public func canUpdate(expiryYear: ExpiryYear?, withText text: String, inRange range: NSRange) -> Bool {
        guard text.isEmpty == false else {
            return true // Always allow deletion
        }
        guard let year = expiryYear else {
            return true
        }
        let expectedYear: String
        if let range = Range(range, in: year) {
            expectedYear = year.replacingCharacters(in: range, with: text)
        } else {
            expectedYear = text
        }
        let rule = cardConfiguration?.defaults?.year ?? baseCardDefaults.year!
        return textValidator.validate(text: expectedYear, againstValidationRule: rule).partial
    }
    
    private func isNumeric(text: String) -> Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: text))
    }
}
