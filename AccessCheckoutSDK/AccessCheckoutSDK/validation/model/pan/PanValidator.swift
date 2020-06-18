class PanValidator {
    private var cardBrandsConfigurationProvider: CardBrandsConfigurationProvider
    
    init(_ cardBrandsConfigurationProvider: CardBrandsConfigurationProvider) {
        self.cardBrandsConfigurationProvider = cardBrandsConfigurationProvider
    }
    
    func validate(pan: String) -> PanValidationResult {
        let cardBrand = cardBrandsConfigurationProvider.get().cardBrand(forPan: pan)
        let validationRule = cardBrand?.panValidationRule ?? ValidationRulesDefaults.instance().pan
        
        var isValid: Bool = false
        if validationRule.validate(text: pan) {
            isValid = isValidLuhn(pan)
        }
        
        return PanValidationResult(isValid, cardBrand)
    }
    
    func canValidate(_ pan: String) -> Bool {
        let cardBrand = cardBrandsConfigurationProvider.get().cardBrand(forPan: pan)
        let validationRule = cardBrand?.panValidationRule ?? ValidationRulesDefaults.instance().pan
        
        return validationRule.textIsMatched(pan) && validationRule.textIsShorterOrAsLongAsMaxLength(pan)
    }
    
    private func isValidLuhn(_ pan: String) -> Bool {
        var sum = 0
        let reversedCharacters = pan.reversed().map {
            String($0)
        }
        for (idx, element) in reversedCharacters.enumerated() {
            guard let digit = Int(element) else {
                return false
            }
            switch (idx % 2 == 1, digit) {
            case (true, 9): sum += 9
            case (true, 0...8): sum += (digit * 2) % 9
            default: sum += digit
            }
        }
        return sum % 10 == 0
    }
}
