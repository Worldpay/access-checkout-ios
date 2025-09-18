import XCTest

@testable import AccessCheckoutSDK

class CardBinCacheManagerTests: XCTestCase {
    let cardBinCacheManager = CardBinCacheManager()

    func testCacheManagerGetCacheKeyReturnsExpectedKeyWhen12DigitsEntered() {
        let expectedKey = "444433332222"

        let cacheKey = cardBinCacheManager.getCacheKey(from: "444433332222")

        XCTAssertEqual(expectedKey, cacheKey)
    }

    func testCacheManagerGetCacheKeyDoesNotReturnErrorWhenLessThan12Digits() {
        let expectedKey = "4444"

        let cacheKey = cardBinCacheManager.getCacheKey(from: "4444")

        XCTAssertEqual(expectedKey, cacheKey)
    }

    func testCacheManagerGetCacheKeyReturnsExpectedKeyWhenMoreThan12Digits() {
        let expectedKey = "444433332222"

        let cacheKey = cardBinCacheManager.getCacheKey(from: "4444333322221111")

        XCTAssertEqual(expectedKey, cacheKey)
    }
}
