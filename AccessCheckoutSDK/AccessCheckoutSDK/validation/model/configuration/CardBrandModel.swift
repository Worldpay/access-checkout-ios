struct CardBrandModel {
    let name: String
    let images: [CardBrandImageModel]
    let panValidationRule: ValidationRule
    let cvcValidationRule: ValidationRule

    init(
        name: String,
        images: [CardBrandImageModel],
        panValidationRule: ValidationRule,
        cvcValidationRule: ValidationRule
    ) {
        self.name = name
        self.images = images
        self.panValidationRule = panValidationRule
        self.cvcValidationRule = cvcValidationRule
    }
}
