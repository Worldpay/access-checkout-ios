import Foundation

/// Validates a card PAN, expiry date and CVV input
public protocol CardValidator {
    /// Card configuration rules
    var cardConfiguration: CardConfiguration? { get set }
    
    /// Validates combined card number, expiry date and CVV fields based on the `cardConfiguration`
    func isValid(pan: PAN?, expiryMonth: ExpiryMonth?, expiryYear: ExpiryYear?, cvv: CVV?) -> Bool
    
    /// Validates a card number
    func validate(pan: PAN) -> (valid: ValidationResult, brand: CardConfiguration.CardBrand?)
    
    /// Permits potential card number text updates
    func canUpdate(pan: PAN?, withText text: String, inRange range: NSRange) -> Bool
    
    /// Validates card CVV and any card number
    func validate(cvv: CVV, withPAN pan: PAN?) -> ValidationResult
    
    /// Permits potential card CVV text updates
    func canUpdate(cvv: CVV?, withPAN pan: PAN?, withText text: String, inRange range: NSRange) -> Bool
    
    /// Validates a card expiry date
    func validate(month: ExpiryMonth?, year: ExpiryYear?, target: Date) -> ValidationResult
    
    /// Permits potential card expiry month updates
    func canUpdate(expiryMonth: ExpiryMonth?, withText text: String, inRange range: NSRange) -> Bool
    
    /// Permits potential card expiry year updates
    func canUpdate(expiryYear: ExpiryYear?, withText text: String, inRange range: NSRange) -> Bool
}

// An Access Checkout `CardValidator`
final public class AccessCheckoutCardValidator: CardValidator {
    
    /// The configuration to validate against
    public var cardConfiguration: CardConfiguration?
    
    /**
     Initializes the validator.
     
     - Parameter cardConfiguration: Optional `CardConfiguration`
    */
    public init(cardConfiguration: CardConfiguration?) {
        self.cardConfiguration = cardConfiguration
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
        guard let panRule = cardBrand?.cardValidationRule(forPAN: pan) ?? cardConfiguration?.defaults?.pan else {
            return (ValidationResult(partial: true, complete: pan.isValidLuhn()), cardBrand)
        }
        var valid = validate(text: pan, againstValidationRule: panRule)
        if valid.complete {
            let validLuhn = pan.isValidLuhn()
            valid = ValidationResult(partial: validLuhn, complete: validLuhn)
        }
        return (valid, cardBrand)
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
            let cardBrand = cardConfiguration?.cardBrand(forPAN: currentPan)
            panRule = cardBrand?.cardValidationRule(forPAN: currentPan) ?? cardConfiguration?.defaults?.pan
        } else {
            expectedPan = text
            panRule = cardConfiguration?.defaults?.pan
        }
        return validate(text: expectedPan, againstValidationRule: panRule).partial
    }
    
    /**
     Validates a card CVV.
     
     - Parameter cvv: The card CVV
     
     - Returns: The result of the validation.
     */
    public func validate(cvv: CVV, withPAN pan: PAN?) -> ValidationResult {
        let cvvRule: CardConfiguration.CardValidationRule?
        if let pan = pan {
            cvvRule = cardConfiguration?.cardBrand(forPAN: pan)?.cvv ?? cardConfiguration?.defaults?.cvv
        } else {
            cvvRule = cardConfiguration?.defaults?.cvv
        }
        return validate(text: cvv, againstValidationRule: cvvRule)
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
        
        let cvvRule: CardConfiguration.CardValidationRule?
        if let pan = pan {
            cvvRule = cardConfiguration?.cardBrand(forPAN: pan)?.cvv ?? cardConfiguration?.defaults?.cvv
        } else {
            cvvRule = cardConfiguration?.defaults?.cvv
        }
        
        let expectedCVV: String
        if let cvv = cvv, let range = Range(range, in: cvv) {
            expectedCVV = cvv.replacingCharacters(in: range, with: text)
        } else {
            expectedCVV = text
        }
        return validate(text: expectedCVV, againstValidationRule: cvvRule).partial
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
        return validate(text: expectedMonth, againstValidationRule: cardConfiguration?.defaults?.month).partial
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
        
        var partiallyValid = true
        var completelyValid = true
        
        if let expiryMonth = month, let expiryYear = year {
            let monthValid = validate(text: expiryMonth, againstValidationRule: cardConfiguration?.defaults?.month)
            let yearValid = validate(text: expiryYear, againstValidationRule: cardConfiguration?.defaults?.year)
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
            let valid = validate(text: expiryMonth, againstValidationRule: cardConfiguration?.defaults?.month)
            partiallyValid = valid.partial
            completelyValid = valid.complete
            // Numeric month handling
            if completelyValid, let intMonth = Int(expiryMonth) {
                completelyValid = intMonth > 0
            }
        } else if let expiryYear = year {
            let valid = validate(text: expiryYear, againstValidationRule: cardConfiguration?.defaults?.year)
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
        return validate(text: expectedYear, againstValidationRule: cardConfiguration?.defaults?.year).partial
    }
    
    private func validate(text: String, againstValidationRule validationRule: CardConfiguration.CardValidationRule?) -> ValidationResult {
        
        guard text.isEmpty == false else {
            return ValidationResult(partial: true, complete: false)
        }
        
        var partiallyValid = true
        var completelyValid = true
        
        guard let rule = validationRule else {
            return ValidationResult(partial: partiallyValid, complete: completelyValid)
        }

        if let matcher = rule.matcher {
            guard matcher.regexMatches(text: text) == true else {
                return ValidationResult(partial: false, complete: false)
            }
        }
        if let validLength = rule.validLength {
            partiallyValid = text.count <= validLength
            completelyValid = text.count == validLength
        } else if let minLength = rule.minLength, let maxLength = rule.maxLength {
            partiallyValid = text.count <= maxLength
            completelyValid = text.count >= minLength && text.count <= maxLength
        } else if let minLength = rule.minLength {
            partiallyValid = true
            completelyValid = text.count >= minLength
        } else if let maxLength = rule.maxLength {
            partiallyValid = text.count <= maxLength
            completelyValid = text.count == maxLength
        }
        return ValidationResult(partial: partiallyValid, complete: completelyValid)
    }
}

/// Result of validation
public struct ValidationResult {
    /// The validity of a partially complete input
    public let partial: Bool
    /// The validity of a complete input
    public let complete: Bool
}

extension PAN {
    
    /**
     Convenience regex matcher function.
     
     - Parameter text: Input text to match against
     - Returns: If any match exists
     */
    func regexMatches(text: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: self) else {
            return false
        }
        return regex.firstMatch(in: text, range: NSRange(location: 0, length: text.count)) != nil
    }
    
    /**
     Convenience Luhn check.
     - Returns: Is a valid Luhn.
     */
    func isValidLuhn() -> Bool {
        var sum = 0
        let reversedCharacters = self.reversed().map {
            String($0)
        }
        for (idx, element) in reversedCharacters.enumerated() {
            guard let digit = Int(element) else {
                return false
            }
            switch ((idx % 2 == 1), digit) {
            case (true, 9): sum += 9
            case (true, 0...8): sum += (digit * 2) % 9
            default: sum += digit
            }
        }
        return sum % 10 == 0
    }
}
