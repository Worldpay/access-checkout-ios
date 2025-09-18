import Cuckoo
import Foundation

@testable import AccessCheckoutSDK

class MockRestClient<T: Decodable>: RestClient<T>, Cuckoo.ClassMock {

    typealias MocksType = RestClient<T>

    typealias Stubbing = __StubbingProxy_RestClient
    typealias Verification = __VerificationProxy_RestClient

    let cuckoo_manager =
        Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    private var __defaultImplStub: RestClient<T>?

    func enableDefaultImplementation(_ stub: RestClient<T>) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    override func send(
        urlSession: URLSession, request: URLRequest,
        completionHandler: @escaping (Result<T, AccessCheckoutError>, Int?) -> Void
    ) -> URLSessionTask {

        return cuckoo_manager.call(
            """
            send(urlSession: URLSession, request: URLRequest, completionHandler: @escaping (Result<T, AccessCheckoutError>, Int?) -> Void) -> URLSessionTask
            """,
            parameters: (urlSession, request, completionHandler),
            escapingParameters: (urlSession, request, completionHandler),
            superclassCall:

                super.send(
                    urlSession: urlSession, request: request, completionHandler: completionHandler),
            defaultCall: __defaultImplStub!.send(
                urlSession: urlSession, request: request, completionHandler: completionHandler))

    }

    struct __StubbingProxy_RestClient: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }

        func send<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(
            urlSession: M1, request: M2, completionHandler: M3
        )
            -> Cuckoo.ClassStubFunction<
                (URLSession, URLRequest, (Result<T, AccessCheckoutError>, Int?) -> Void),
                URLSessionTask
            >
        where
            M1.MatchedType == URLSession, M2.MatchedType == URLRequest,
            M3.MatchedType == (Result<T, AccessCheckoutError>, Int?) -> Void
        {
            let matchers:
                [Cuckoo.ParameterMatcher<
                    (URLSession, URLRequest, (Result<T, AccessCheckoutError>, Int?) -> Void)
                >] = [
                    wrap(matchable: urlSession) { $0.0 }, wrap(matchable: request) { $0.1 },
                    wrap(matchable: completionHandler) { $0.2 },
                ]
            return .init(
                stub: cuckoo_manager.createStub(
                    for: MockRestClient.self,
                    method:
                        """
                        send(urlSession: URLSession, request: URLRequest, completionHandler: @escaping (Result<T, AccessCheckoutError>, Int?) -> Void) -> URLSessionTask
                        """, parameterMatchers: matchers))
        }

    }

    struct __VerificationProxy_RestClient: Cuckoo.VerificationProxy {
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
        func send<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(
            urlSession: M1, request: M2, completionHandler: M3
        )
            -> Cuckoo.__DoNotUse<
                (URLSession, URLRequest, (Result<T, AccessCheckoutError>, Int?) -> Void),
                URLSessionTask
            >
        where
            M1.MatchedType == URLSession, M2.MatchedType == URLRequest,
            M3.MatchedType == (Result<T, AccessCheckoutError>, Int?) -> Void
        {
            let matchers:
                [Cuckoo.ParameterMatcher<
                    (URLSession, URLRequest, (Result<T, AccessCheckoutError>, Int?) -> Void)
                >] = [
                    wrap(matchable: urlSession) { $0.0 }, wrap(matchable: request) { $0.1 },
                    wrap(matchable: completionHandler) { $0.2 },
                ]
            return cuckoo_manager.verify(
                """
                send(urlSession: URLSession, request: URLRequest, completionHandler: @escaping (Result<T, AccessCheckoutError>, Int?) -> Void) -> URLSessionTask
                """, callMatcher: callMatcher, parameterMatchers: matchers,
                sourceLocation: sourceLocation)
        }

    }
}

class RestClientStub<T: Decodable>: RestClient<T> {

    override func send(
        urlSession: URLSession, request: URLRequest,
        completionHandler: @escaping (Result<T, AccessCheckoutError>, Int?) -> Void
    ) -> URLSessionTask {
        return DefaultValueRegistry.defaultValue(for: (URLSessionTask).self)
    }

}
