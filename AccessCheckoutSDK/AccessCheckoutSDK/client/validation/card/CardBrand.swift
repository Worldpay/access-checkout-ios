/*
 A struct representing a card brand as detected by the SDK
 - name: `String` containing the name of the card brand
 - images: an `Array` of `CardBrandImage` containing each the same image but in different formats
 **/
public struct CardBrand {
    public let name: String
    public let images: [CardBrandImage]
}
