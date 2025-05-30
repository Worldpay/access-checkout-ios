class CardBrandDtoTransformer {
    private let cvcMatcher = "^\\d*$"

    func transform(_ dto: CardBrandDto) -> CardBrandModel {
        let images = dto.images.map { self.transform(image: $0) }
        let panRule = ValidationRule(matcher: dto.pattern, validLengths: dto.panLengths)
        let cvcRule = ValidationRule(matcher: cvcMatcher, validLengths: [dto.cvcLength])

        return CardBrandModel(
            name: dto.name,
            images: images,
            panValidationRule: panRule,
            cvcValidationRule: cvcRule
        )
    }

    private func transform(image: CardBrandImageDto) -> CardBrandImageModel {
        return CardBrandImageModel(type: image.type, url: image.url)
    }
}
