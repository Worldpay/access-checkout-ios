@testable import AccessCheckoutSDK

extension CardBrandModel: Equatable {
    public static func == (lhs: CardBrandModel, rhs: CardBrandModel) -> Bool {
        if lhs.name != rhs.name {
            return false
        }

        if !lhs.images.isEmpty {
            for i in 0...lhs.images.count - 1 {
                if lhs.images[i] != rhs.images[i] {
                    return false
                }
            }
        }

        return lhs.panValidationRule == rhs.panValidationRule
            && lhs.cvcValidationRule == rhs.cvcValidationRule
    }
}

extension CardBrand: Equatable {
    public static func == (lhs: CardBrand, rhs: CardBrand) -> Bool {
        if !lhs.images.isEmpty {
            for i in 0...lhs.images.count - 1 {
                if lhs.images[i] != rhs.images[i] {
                    return true
                }
            }
        }

        return lhs.name == rhs.name
    }
}

extension CardBrandDto: Equatable {
    public static func == (lhs: CardBrandDto, rhs: CardBrandDto) -> Bool {
        return lhs.name == rhs.name
            && lhs.pattern == rhs.pattern
            && lhs.panLengths == rhs.panLengths
            && lhs.cvcLength == rhs.cvcLength
            && lhs.images == rhs.images
    }
}

extension CardBrandImageModel: Equatable {
    public static func == (lhs: CardBrandImageModel, rhs: CardBrandImageModel) -> Bool {
        return lhs.type == rhs.type
            && lhs.url == rhs.url
    }
}

extension CardBrandImage: Equatable {
    public static func == (lhs: CardBrandImage, rhs: CardBrandImage) -> Bool {
        return lhs.type == rhs.type
            && lhs.url == rhs.url
    }
}

extension CardBrandImageDto: Equatable {
    public static func == (lhs: CardBrandImageDto, rhs: CardBrandImageDto) -> Bool {
        return lhs.type == rhs.type
            && lhs.url == rhs.url
    }
}

extension CardBrandsConfiguration: Equatable {
    public static func == (lhs: CardBrandsConfiguration, rhs: CardBrandsConfiguration) -> Bool {
        return lhs.allCardBrands == rhs.allCardBrands
            && lhs.acceptedCardBrands == rhs.acceptedCardBrands
    }
}

extension ValidationRulesDefaults: Equatable {
    public static func == (lhs: ValidationRulesDefaults, rhs: ValidationRulesDefaults) -> Bool {
        return lhs.cvc == rhs.cvc
            && lhs.expiryDate == rhs.expiryDate
            && lhs.expiryDateInput == rhs.expiryDateInput
            && lhs.pan == rhs.pan
    }
}

extension PanValidationResult: Equatable {
    public static func == (lhs: PanValidationResult, rhs: PanValidationResult) -> Bool {
        return lhs.isValid == rhs.isValid
            && lhs.cardBrand == rhs.cardBrand
    }
}

extension ValidationRule: Equatable {
    public static func == (lhs: ValidationRule, rhs: ValidationRule) -> Bool {
        return lhs.matcher == rhs.matcher
            && lhs.validLengths == rhs.validLengths
    }
}
