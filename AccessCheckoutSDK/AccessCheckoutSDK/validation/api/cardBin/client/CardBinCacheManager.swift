import Foundation

internal class CardBinCacheManager {
    private var cache: [String: CardBinResponse] = [:]

    func getCacheKey(from cardNumber: String) -> String {
        return String(cardNumber.prefix(12))
    }

    func getCachedResponse(for key: String) -> CardBinResponse? {
        return cache[key]
    }

    func putInCache(key: String, response: CardBinResponse) {
        cache[key] = response
        return
    }
}
