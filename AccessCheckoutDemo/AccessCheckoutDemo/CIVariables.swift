import Foundation

/// This struct is used for CI related variables.
/// The value is injected by the variable-injector plugin at build time.
/// Bitrise Swift variable injector step, see https://github.com/LucianoPAlmeida/variable-injector
struct CI {
    /// The checkoutId
    static var checkoutId = "$(CHECKOUT_ID)"

    /// The base URL for Access services
    static var accessBaseUrl = "$(ACCESS_BASE_URL)"
}
