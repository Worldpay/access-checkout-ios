struct CardBrandModel {
    let name: String
    let images: [CardBrandImageModel]
    let panValidationRule: ValidationRule
    let cvvValidationRule: ValidationRule

    init(name: String, images: [CardBrandImageModel], panValidationRule: ValidationRule, cvvValidationRule: ValidationRule) {
        self.name = name
        self.images = images
        self.panValidationRule = panValidationRule
        self.cvvValidationRule = cvvValidationRule
    }
}
