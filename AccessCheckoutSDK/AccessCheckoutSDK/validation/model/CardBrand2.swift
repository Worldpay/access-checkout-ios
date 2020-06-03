public struct CardBrand2 {
    let name: String
    let images: [CardBrandImage2]
    let panValidationRule: ValidationRule
    let cvvValidationRule: ValidationRule

    init(name: String, images: [CardBrandImage2], panValidationRule: ValidationRule, cvvValidationRule: ValidationRule) {
        self.name = name
        self.images = images
        self.panValidationRule = panValidationRule
        self.cvvValidationRule = cvvValidationRule
    }
}
