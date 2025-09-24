@testable import AccessCheckoutSDK

extension ServiceDiscoveryProvider {
    static func clearCache() {
        ServiceDiscoveryProvider.cachedResponses = [:]
        ServiceDiscoveryProvider.cachedResults = [:]
    }
}
