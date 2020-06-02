@testable import AccessCheckoutSDK
import Cuckoo

extension AccessCardConfiguration.CardBrand: Matchable, OptionalMatchable {}

extension CardBrandDto: Matchable {}

extension PanValidationResult: Matchable {}

extension URLRequest: Matchable {}
