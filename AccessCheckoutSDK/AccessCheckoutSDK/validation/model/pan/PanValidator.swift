class PanValidator {
    private var cardBrandsConfigurationProvider: CardBrandsConfigurationProvider
    
    init(_ cardBrandsConfigurationProvider: CardBrandsConfigurationProvider) {
        self.cardBrandsConfigurationProvider = cardBrandsConfigurationProvider
    }
    
    func validate(pan: String) -> PanValidationResult {
        let config = cardBrandsConfigurationProvider.get()
        let cardBrand = cardBrandsConfigurationProvider.get().cardBrand(forPan: pan)
        
        if !isValidLuhn(pan) {
            return PanValidationResult(false, cardBrand)
        } else if cardBrand != nil, !isAcceptedBrand(config, cardBrand) {
            return PanValidationResult(false, cardBrand)
        }
        
        let validationRule = cardBrand?.panValidationRule ?? ValidationRulesDefaults.instance().pan
        return PanValidationResult(validationRule.validate(text: pan), cardBrand)
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
    
    private func isAcceptedBrand(_ config: CardBrandsConfiguration, _ cardBrand: CardBrandModel?) -> Bool {
        return config.acceptedCardBrands.isEmpty
            || config.acceptedCardBrands.contains(where: { $0.lowercased() == cardBrand!.name.lowercased() })
    }
}
