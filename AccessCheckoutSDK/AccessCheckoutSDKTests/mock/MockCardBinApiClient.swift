import Cuckoo
import Foundation

@testable import AccessCheckoutSDK

class MockCardBinApiClient: CardBinApiClient, Cuckoo.ClassMock {

    typealias MocksType = CardBinApiClient

    typealias Stubbing = __StubbingProxy_CardBinApiClient
    typealias Verification = __VerificationProxy_CardBinApiClient

    let cuckoo_manager =
        Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    private var __defaultImplStub: CardBinApiClient?

    func enableDefaultImplementation(_ stub: CardBinApiClient) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    override func retrieveBinInfo(
        request: CardBinRequest,
        completionHandler: @escaping (Result<CardBinResponse, AccessCheckoutError>) -> Void
    ) {

        return cuckoo_manager.call(
            """
            retrieveBinInfo(request: CardBinRequest, completionHandler: @escaping (Result<CardBinResponse, AccessCheckoutError>) -> Void)
            """,
            parameters: (request, completionHandler),
            escapingParameters: (request, completionHandler),
            superclassCall:

                super.retrieveBinInfo(request: request, completionHandler: completionHandler),
            defaultCall: __defaultImplStub!.retrieveBinInfo(
                request: request, completionHandler: completionHandler))

    }

    struct __StubbingProxy_CardBinApiClient: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }

        func retrieveBinInfo<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(
            request: M1, completionHandler: M2
        )
            -> Cuckoo.ClassStubNoReturnFunction<
                (CardBinRequest, (Result<CardBinResponse, AccessCheckoutError>) -> Void)
            >
        where
            M1.MatchedType == CardBinRequest,
            M2.MatchedType == (Result<CardBinResponse, AccessCheckoutError>) -> Void
        {
            let matchers:
                [Cuckoo.ParameterMatcher<
                    (CardBinRequest, (Result<CardBinResponse, AccessCheckoutError>) -> Void)
                >] = [
                    wrap(matchable: request) { $0.0 }, wrap(matchable: completionHandler) { $0.1 },
                ]
            return .init(
                stub: cuckoo_manager.createStub(
                    for: MockCardBinApiClient.self,
                    method:
                        """
                        retrieveBinInfo(request: CardBinRequest, completionHandler: @escaping (Result<CardBinResponse, AccessCheckoutError>) -> Void)
                        """, parameterMatchers: matchers))
        }

    }

    struct __VerificationProxy_CardBinApiClient: Cuckoo.VerificationProxy {
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
        func retrieveBinInfo<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(
            request: M1, completionHandler: M2
        )
            -> Cuckoo.__DoNotUse<
                (CardBinRequest, (Result<CardBinResponse, AccessCheckoutError>) -> Void), Void
            >
        where
            M1.MatchedType == CardBinRequest,
            M2.MatchedType == (Result<CardBinResponse, AccessCheckoutError>) -> Void
        {
            let matchers:
                [Cuckoo.ParameterMatcher<
                    (CardBinRequest, (Result<CardBinResponse, AccessCheckoutError>) -> Void)
                >] = [
                    wrap(matchable: request) { $0.0 }, wrap(matchable: completionHandler) { $0.1 },
                ]
            return cuckoo_manager.verify(
                """
                retrieveBinInfo(request: CardBinRequest, completionHandler: @escaping (Result<CardBinResponse, AccessCheckoutError>) -> Void)
                """, callMatcher: callMatcher, parameterMatchers: matchers,
                sourceLocation: sourceLocation)
        }

    }
}

class CardBinApiClientStub: CardBinApiClient {

    override func retrieveBinInfo(
        request: CardBinRequest,
        completionHandler: @escaping (Result<CardBinResponse, AccessCheckoutError>) -> Void
    ) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }

}
