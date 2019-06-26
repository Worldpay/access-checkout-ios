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

/// An Access Checkout `CardValidator`
final public class AccessCheckoutCardValidator: CardValidator {
    
    /// The base card configuration, will be overridden by any `cardConfiguration`
    private let baseCardDefaults: CardConfiguration.CardDefaults
    
    /// The configuration to validate against
    public var cardConfiguration: CardConfiguration?
    
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
        
        var cardBrand = cardConfiguration?.cardBrand(forPAN: pan)
        
        switch cardBrand?.name {
        case "visa":
            cardBrand?.imageUrl = Bundle(for: type(of: self)).url(forResource: "visa", withExtension: "png")?.absoluteString
        case "mastercard":
            cardBrand?.imageUrl = Bundle(for: type(of: self)).url(forResource: "mastercard", withExtension: "png")?.absoluteString
        case "amex":
            cardBrand?.imageUrl = Bundle(for: type(of: self)).url(forResource: "amex", withExtension: "png")?.absoluteString
        default:
            break
        }
            
        let panRule = cardBrand?.cardValidationRule(forPAN: pan) ?? cardConfiguration?.defaults?.pan ?? baseCardDefaults.pan!
        var validationResult = validate(text: pan, againstValidationRule: panRule)

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
        return validate(text: expectedPan, againstValidationRule: rule).partial
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
        return validate(text: cvv, againstValidationRule: rule)
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
        return validate(text: expectedCVV, againstValidationRule: rule).partial
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
        return validate(text: expectedMonth, againstValidationRule: rule).partial
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
            let monthValid = validate(text: expiryMonth, againstValidationRule: monthRule)
            let yearValid = validate(text: expiryYear, againstValidationRule: yearRule)
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
            let valid = validate(text: expiryMonth, againstValidationRule: monthRule)
            partiallyValid = valid.partial
            completelyValid = valid.complete
            // Numeric month handling
            if completelyValid, let intMonth = Int(expiryMonth) {
                completelyValid = intMonth > 0
            }
        } else if let expiryYear = year {
            let valid = validate(text: expiryYear, againstValidationRule: yearRule)
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
        return validate(text: expectedYear, againstValidationRule: rule).partial
    }
    
    private func validate(text: String, againstValidationRule validationRule: CardConfiguration.CardValidationRule) -> ValidationResult {
        
        guard !text.isEmpty else {
            return ValidationResult(partial: true, complete: false)
        }
        if let matcher = validationRule.matcher, matcher.regexMatches(text: text) == false {
            return ValidationResult(partial: false, complete: false)
        }
        
        let partiallyValid: Bool
        let completelyValid: Bool
        
        if let validLength = validationRule.validLength {
            partiallyValid = text.count <= validLength
            completelyValid = text.count == validLength
        } else if let minLength = validationRule.minLength, let maxLength = validationRule.maxLength {
            partiallyValid = text.count <= maxLength
            completelyValid = text.count >= minLength && text.count <= maxLength
        } else if let minLength = validationRule.minLength {
            partiallyValid = true
            completelyValid = text.count >= minLength
        } else if let maxLength = validationRule.maxLength {
            partiallyValid = text.count <= maxLength
            completelyValid = text.count == maxLength
        } else {
            partiallyValid = true
            completelyValid = true
        }
        return ValidationResult(partial: partiallyValid, complete: completelyValid)
    }
    
    private func isNumeric(text: String) -> Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: text))
    }
}

/// Result of validation
public struct ValidationResult {
    
    /// Result is partially valid
    public let partial: Bool
    
    /// Result is completely valid
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
