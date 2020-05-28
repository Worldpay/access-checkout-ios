import Foundation

class LengthValidator {
    func validate(text: String, againstValidationRule validationRule: AccessCardConfiguration.CardValidationRule) -> Bool {
        guard !text.isEmpty else {
            return false
        }
        
        if let matcher = validationRule.matcher, matcher.regexMatches(text: text) == false {
            return false
        }
        
        let validLengths = validationRule.validLengths
        
        if validLengths.isEmpty {
            return true
        }

        return validLengths.contains(text.count)
    }
}
