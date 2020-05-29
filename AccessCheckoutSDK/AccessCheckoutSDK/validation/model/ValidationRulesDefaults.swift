class ValidationRulesDefaults {
    let pan: ValidationRule?
    let cvv: ValidationRule?
    let expiryMonth: ValidationRule?
    let expiryYear: ValidationRule?
    
    fileprivate init() {
        self.pan = ValidationRule(
            matcher: "^\\d{0,19}$",
            validLengths: [12, 13, 14, 15, 16, 17, 18, 19]
        )
        
        self.cvv = ValidationRule(
            matcher: "^\\d{0,4}$",
            validLengths: [3, 4]
        )
        
        self.expiryMonth = ValidationRule(
            matcher: "^0[1-9]{0,1}$|^1[0-2]{0,1}$",
            validLengths: [2]
        )
        
        self.expiryYear = ValidationRule(
            matcher: "^\\d{0,2}$",
            validLengths: [2]
        )
    }
    
    static func instance() -> ValidationRulesDefaults {
        return ValidationRulesDefaults()
    }
}
