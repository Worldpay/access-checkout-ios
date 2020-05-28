import Foundation

struct ExpiryDateValidator {
    
    let lengthValidator = LengthValidator()

    func validate(expiryMonth: ExpiryMonth?, expiryYear: ExpiryYear?) -> Bool {
        guard let month = expiryMonth, let year = expiryYear else {
            return false
        }
        
        if month.isEmpty || year.isEmpty {
            return false
        }
        
        let monthRule = AccessCardConfiguration.CardDefaults.baseDefaults().month
        let yearRule = AccessCardConfiguration.CardDefaults.baseDefaults().year
        
        if !lengthValidator.validate(text: month, againstValidationRule: monthRule) {
            return false
        }
        
        if !lengthValidator.validate(text: year, againstValidationRule: yearRule) {
            return false
        }
        
        let dateComponents = Calendar.current.dateComponents([.month, .year], from: Date())
        if let targetMonth = dateComponents.month,
            let targetYear = dateComponents.year,
            let intMonth = Int(month),
            let fourDigitYear = year.toFourDigitFormat() {
                if intMonth == 0 {
                    return false
                } else if fourDigitYear < targetYear {
                    return false
                } else if fourDigitYear == targetYear && intMonth < targetMonth {
                    return false
                } else {
                    return true
                }
            }
        return false
    }
}
