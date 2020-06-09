class CardBrandDtoTransformer {
    func transform(_ dto: CardBrandDto) -> CardBrandModel {
        let images = dto.images.map { self.transform(image: $0) }
        let panRule = ValidationRule(matcher: dto.pattern, validLengths: dto.panLengths)
        let cvvRule = ValidationRule(matcher: nil, validLengths: [dto.cvvLength])
        
        return CardBrandModel(name: dto.name, images: images, panValidationRule: panRule, cvvValidationRule: cvvRule)
    }
    
    private func transform(image: CardBrandImageDto) -> CardBrandImageModel {
        return CardBrandImageModel(type: image.type, url: image.url)
    }
}
