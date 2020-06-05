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
            && lhs.cvvValidationRule == rhs.cvvValidationRule
    }
}

extension CardBrandClient: Equatable {
    public static func == (lhs: CardBrandClient, rhs: CardBrandClient) -> Bool {
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
            && lhs.cvvLength == rhs.cvvLength
            && lhs.images == rhs.images
    }
}

extension CardBrandImageModel: Equatable {
    public static func == (lhs: CardBrandImageModel, rhs: CardBrandImageModel) -> Bool {
        return lhs.type == rhs.type
            && lhs.url == rhs.url
    }
}

extension CardBrandImageClient: Equatable {
    public static func == (lhs: CardBrandImageClient, rhs: CardBrandImageClient) -> Bool {
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
        return lhs.brands == rhs.brands
            && lhs.validationRulesDefaults == rhs.validationRulesDefaults
    }
}

extension ValidationRulesDefaults: Equatable {
    public static func == (lhs: ValidationRulesDefaults, rhs: ValidationRulesDefaults) -> Bool {
        return lhs.cvv == rhs.cvv
            && lhs.expiryMonth == rhs.expiryMonth
            && lhs.expiryYear == rhs.expiryYear
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
