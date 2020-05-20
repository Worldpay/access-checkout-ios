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
        let validLengths = validationRule.validLengths
        
        if !validLengths.isEmpty {
            partiallyValid = text.count <= validLengths.max()!
            completelyValid = validLengths.contains(text.count)
        } else {
            partiallyValid = true
            completelyValid = true
        }
        return ValidationResult(partial: partiallyValid, complete: completelyValid)
    }
}
