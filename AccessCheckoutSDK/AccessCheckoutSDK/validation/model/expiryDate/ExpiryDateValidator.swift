import Foundation

class ExpiryDateValidator {
    func validate(_ expiryDate: String) -> Bool {
        if expiryDate.isEmpty {
            return false
        }
        
        let validationRule = ValidationRulesDefaults.instance().expiryDate
        if !validationRule.validate(text: expiryDate) {
            return false
        }
        
        let dateComponents = Calendar.current.dateComponents([.month, .year], from: Date())
        let currentMonth = dateComponents.month!
        let currentYear = dateComponents.year!
        
        let monthToValidate = Int(expiryDate.prefix(2))!
        let fourDigitYearToValidate = toFourDigitFormat(expiryDate.suffix(2))
        
        if fourDigitYearToValidate < currentYear {
            return false
        } else if fourDigitYearToValidate == currentYear, monthToValidate < currentMonth {
            return false
        }
        
        return true
    }
    
    func canValidate(_ text: String) -> Bool {
        let validationRule = ValidationRulesDefaults.instance().expiryDateInput
        
        return validationRule.textIsMatched(text)
            && validationRule.textIsShorterOrAsLongAsMaxLength(text)
    }
    
    private func toFourDigitFormat(_ string: Substring?) -> Int {
        let number = Int(string!)!
        
        return number < 100 ? number + 2000 : number
    }
}
