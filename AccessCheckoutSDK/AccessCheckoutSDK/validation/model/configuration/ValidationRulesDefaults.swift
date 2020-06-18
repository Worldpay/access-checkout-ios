struct ValidationRulesDefaults {
    let pan: ValidationRule
    let cvc: ValidationRule
    let expiryDate: ValidationRule
    let expiryDateInput: ValidationRule
    
    private static let defaults = ValidationRulesDefaults()
    
    private init() {
        self.pan = ValidationRule(
            matcher: "^\\d{0,19}$",
            validLengths: [12, 13, 14, 15, 16, 17, 18, 19]
        )
        
        self.cvc = ValidationRule(
            matcher: "^\\d{0,4}$",
            validLengths: [3, 4]
        )
        
        self.expiryDate = ValidationRule(
            matcher: "^((0[1-9])|(1[0-2]))\\/(\\d{2})$",
            validLengths: [5]
        )
        
        self.expiryDateInput = ValidationRule(
            matcher: "^(\\d{0,4})?\\/?(\\d{0,4})?$",
            validLengths: [5]
        )
    }
    
    static func instance() -> ValidationRulesDefaults {
        return defaults
    }
}
