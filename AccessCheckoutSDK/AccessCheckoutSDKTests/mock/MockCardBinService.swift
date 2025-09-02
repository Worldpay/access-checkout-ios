import Cuckoo
import Foundation

@testable import AccessCheckoutSDK

class MockCardBinService: CardBinService, Cuckoo.ClassMock {

    typealias MocksType = CardBinService

    typealias Stubbing = __StubbingProxy_CardBinService
    typealias Verification = __VerificationProxy_CardBinService

    let cuckoo_manager =
        Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    private var __defaultImplStub: CardBinService?

    func enableDefaultImplementation(_ stub: CardBinService) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    override func getCardBrands(
        globalBrand: CardBrandModel?, cardNumber: String,
        completion: @escaping (Result<[CardBrandModel], AccessCheckoutError>) -> Void
    ) {

        return cuckoo_manager.call(
            """
            getCardBrands(globalBrand: CardBrandModel?, cardNumber: String, completion: @escaping (Result<[CardBrandModel], AccessCheckoutError>) -> Void)
            """,
            parameters: (globalBrand, cardNumber, completion),
            escapingParameters: (globalBrand, cardNumber, completion),
            superclassCall:

                super.getCardBrands(
                    globalBrand: globalBrand, cardNumber: cardNumber, completion: completion),
            defaultCall: __defaultImplStub!.getCardBrands(
                globalBrand: globalBrand, cardNumber: cardNumber, completion: completion))

    }

    struct __StubbingProxy_CardBinService: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }

        func getCardBrands<
            M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable
        >(globalBrand: M1, cardNumber: M2, completion: M3)
            -> Cuckoo.ClassStubNoReturnFunction<
                (CardBrandModel?, String, (Result<[CardBrandModel], AccessCheckoutError>) -> Void)
            >
        where
            M1.OptionalMatchedType == CardBrandModel, M2.MatchedType == String,
            M3.MatchedType == (Result<[CardBrandModel], AccessCheckoutError>) -> Void
        {
            let matchers:
                [Cuckoo.ParameterMatcher<
                    (
                        CardBrandModel?, String,
                        (Result<[CardBrandModel], AccessCheckoutError>) -> Void
                    )
                >] = [
                    wrap(matchable: globalBrand) { $0.0 }, wrap(matchable: cardNumber) { $0.1 },
                    wrap(matchable: completion) { $0.2 },
                ]
            return .init(
                stub: cuckoo_manager.createStub(
                    for: MockCardBinService.self,
                    method:
                        """
                        getCardBrands(globalBrand: CardBrandModel?, cardNumber: String, completion: @escaping (Result<[CardBrandModel], AccessCheckoutError>) -> Void)
                        """, parameterMatchers: matchers))
        }

    }

    struct __VerificationProxy_CardBinService: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(
            manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher,
            sourceLocation: Cuckoo.SourceLocation
        ) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        @discardableResult
        func getCardBrands<
            M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable
        >(globalBrand: M1, cardNumber: M2, completion: M3)
            -> Cuckoo.__DoNotUse<
                (CardBrandModel?, String, (Result<[CardBrandModel], AccessCheckoutError>) -> Void),
                Void
            >
        where
            M1.OptionalMatchedType == CardBrandModel, M2.MatchedType == String,
            M3.MatchedType == (Result<[CardBrandModel], AccessCheckoutError>) -> Void
        {
            let matchers:
                [Cuckoo.ParameterMatcher<
                    (
                        CardBrandModel?, String,
                        (Result<[CardBrandModel], AccessCheckoutError>) -> Void
                    )
                >] = [
                    wrap(matchable: globalBrand) { $0.0 }, wrap(matchable: cardNumber) { $0.1 },
                    wrap(matchable: completion) { $0.2 },
                ]
            return cuckoo_manager.verify(
                """
                getCardBrands(globalBrand: CardBrandModel?, cardNumber: String, completion: @escaping (Result<[CardBrandModel], AccessCheckoutError>) -> Void)
                """, callMatcher: callMatcher, parameterMatchers: matchers,
                sourceLocation: sourceLocation)
        }

    }
}

class CardBinServiceStub: CardBinService {

    override func getCardBrands(
        globalBrand: CardBrandModel?, cardNumber: String,
        completion: @escaping (Result<[CardBrandModel], AccessCheckoutError>) -> Void
    ) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }

}
