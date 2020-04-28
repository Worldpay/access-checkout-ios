import Foundation

class TextValidator {
    func validate(text: String, againstValidationRule validationRule: CardConfiguration.CardValidationRule) -> ValidationResult {
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
}
