@testable import AccessCheckoutSDK

extension CardBrand2: Equatable {
    public static func == (lhs: CardBrand2, rhs: CardBrand2) -> Bool {
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
            && lhs.cvvValidationRule == rhs.cvvValidationRule
    }
}

extension CardBrandDto: Equatable {
    public static func == (lhs: CardBrandDto, rhs: CardBrandDto) -> Bool {
        return lhs.name == rhs.name
            && lhs.pattern == rhs.pattern
            && lhs.panLengths == rhs.panLengths
            && lhs.cvvLength == rhs.cvvLength
            && lhs.images == rhs.images
    }
}

extension CardBrandImage2: Equatable {
    public static func == (lhs: CardBrandImage2, rhs: CardBrandImage2) -> Bool {
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
