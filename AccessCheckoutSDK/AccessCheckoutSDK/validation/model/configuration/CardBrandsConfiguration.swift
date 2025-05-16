struct CardBrandsConfiguration {
    let allCardBrands: [CardBrandModel]
    let acceptedCardBrands: [String]

    init(allCardBrands: [CardBrandModel], acceptedCardBrands: [String]) {
        self.allCardBrands = allCardBrands
        self.acceptedCardBrands = acceptedCardBrands
    }

    func cardBrand(forPan pan: String) -> CardBrandModel? {
        if allCardBrands.isEmpty {
            return nil
        }

        return allCardBrands.first { $0.panValidationRule.textIsMatched(pan) == true }
    }

    func panValidationRule(using cardBrand: CardBrandModel?) -> ValidationRule {
        guard let cardBrand = cardBrand else {
            return ValidationRulesDefaults.instance().pan
        }

        return cardBrand.panValidationRule
    }
}
