class CardBrandDtoTransformer {
    func transform(_ dto: CardBrandDto) -> CardBrand2 {
        let images = dto.images.map { self.transform(image: $0) }
        let panRule = ValidationRule(matcher: dto.pattern, validLengths: dto.panLengths)
        let cvvRule = ValidationRule(matcher: nil, validLengths: [dto.cvvLength])
        
        return CardBrand2(name: dto.name, images: images, panValidationRule: panRule, cvvValidationRule: cvvRule)
    }
    
    private func transform(image: CardBrandImageDto) -> CardBrandImage2 {
        return CardBrandImage2(type: image.type, url: image.url)
    }
}
