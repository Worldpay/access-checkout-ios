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
        if let targetMonth = dateComponents.month,
            let targetYear = dateComponents.year,
            let intMonth = Int(expiryDate.prefix(2)),
            let fourDigitYear = ExpiryYear(expiryDate.suffix(2)).toFourDigitFormat() {
            if intMonth == 0 {
                return false
            } else if fourDigitYear < targetYear {
                return false
            } else if fourDigitYear == targetYear, intMonth < targetMonth {
                return false
            } else {
                return true
            }
        }
        return false
    }
    
    func canValidate(_ text: String) -> Bool {
        let validationRule = ValidationRulesDefaults.instance().expiryDateInput
        
        return validationRule.textIsMatched(text)
            && validationRule.textIsShorterOrAsLongAsMaxLength(text)
    }
}
