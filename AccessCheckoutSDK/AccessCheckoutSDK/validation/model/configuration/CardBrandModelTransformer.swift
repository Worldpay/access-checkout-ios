class CardBrandModelTransformer {
    func transform(_ model: CardBrandModel) -> CardBrand {
        let images = model.images.map { self.transform(image: $0) }

        return CardBrand(name: model.name, images: images)
    }

    private func transform(image: CardBrandImageModel) -> CardBrandImage {
        return CardBrandImage(type: image.type, url: image.url)
    }
}
