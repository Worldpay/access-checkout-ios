@testable import AccessCheckoutSDK
import Cuckoo

extension AccessCardConfiguration.CardBrand: Matchable, OptionalMatchable {}

extension CardBrandClient: Matchable, OptionalMatchable {}

extension CardBrandDto: Matchable {}

extension CardBrandModel: Matchable, OptionalMatchable {}

extension PanValidationResult: Matchable {}

extension URLRequest: Matchable {}

extension ValidationRule: Matchable, OptionalMatchable {}
