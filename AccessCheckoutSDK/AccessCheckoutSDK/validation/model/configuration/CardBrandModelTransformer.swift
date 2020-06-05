class CardBrandModelTransformer {
    func transform(_ model: CardBrandModel) -> CardBrandClient {
        let images = model.images.map { self.transform(image: $0) }
        
        return CardBrandClient(name: model.name, images: images)
    }
    
    private func transform(image: CardBrandImageModel) -> CardBrandImageClient {
        return CardBrandImageClient(type: image.type, url: image.url)
    }
}
