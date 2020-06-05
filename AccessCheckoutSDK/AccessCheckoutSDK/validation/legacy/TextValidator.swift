import Foundation

class TextValidator {
    func validate(text: String, againstValidationRule validationRule: CardConfiguration.CardValidationRule) -> ValidationResult {
        guard !text.isEmpty else {
            return ValidationResult(partial: true, complete: false)
        }
        if let matcher = validationRule.matcher, matcher.regexMatches(text: text) == false {
            return ValidationResult(partial: false, complete: false)
        }

        let validLengths = validationRule.validLengths
        
        if validLengths.isEmpty {
            return ValidationResult(partial: true, complete: true)
        }
        
        let partiallyValid = text.count <= validLengths.max()!
        let completelyValid = validLengths.contains(text.count)
        return ValidationResult(partial: partiallyValid, complete: completelyValid)
    }
}
