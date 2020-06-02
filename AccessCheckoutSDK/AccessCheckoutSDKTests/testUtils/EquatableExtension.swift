@testable import AccessCheckoutSDK

extension PanValidationResult: Equatable {
    public static func == (lhs: PanValidationResult, rhs: PanValidationResult) -> Bool {
        return lhs.isValid == rhs.isValid
            && lhs.cardBrand == rhs.cardBrand
    }
}
