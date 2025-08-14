import Cuckoo

@testable import AccessCheckoutSDK

class MockExpiryDateValidationStateHandler: ExpiryDateValidationStateHandler, Cuckoo.ProtocolMock {

    typealias MocksType = ExpiryDateValidationStateHandler

    typealias Stubbing = __StubbingProxy_ExpiryDateValidationStateHandler
    typealias Verification = __VerificationProxy_ExpiryDateValidationStateHandler

    let cuckoo_manager =
        Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: ExpiryDateValidationStateHandler?

    func enableDefaultImplementation(_ stub: ExpiryDateValidationStateHandler) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    func handleExpiryDateValidation(isValid: Bool) {

        return cuckoo_manager.call(
            """
            handleExpiryDateValidation(isValid: Bool)
            """,
            parameters: (isValid),
            escapingParameters: (isValid),
            superclassCall:

                Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.handleExpiryDateValidation(isValid: isValid))

    }

    func notifyMerchantOfExpiryDateValidationState() {

        return cuckoo_manager.call(
            """
            notifyMerchantOfExpiryDateValidationState()
            """,
            parameters: (),
            escapingParameters: (),
            superclassCall:

                Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.notifyMerchantOfExpiryDateValidationState())

    }

    struct __StubbingProxy_ExpiryDateValidationStateHandler: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }

        func handleExpiryDateValidation<M1: Cuckoo.Matchable>(isValid: M1)
            -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool
        {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: isValid) { $0 }]
            return .init(
                stub: cuckoo_manager.createStub(
                    for: MockExpiryDateValidationStateHandler.self,
                    method:
                        """
                        handleExpiryDateValidation(isValid: Bool)
                        """, parameterMatchers: matchers))
        }

        func notifyMerchantOfExpiryDateValidationState() -> Cuckoo.ProtocolStubNoReturnFunction<()>
        {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(
                stub: cuckoo_manager.createStub(
                    for: MockExpiryDateValidationStateHandler.self,
                    method:
                        """
                        notifyMerchantOfExpiryDateValidationState()
                        """, parameterMatchers: matchers))
        }

    }

    struct __VerificationProxy_ExpiryDateValidationStateHandler: Cuckoo.VerificationProxy {
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
        func handleExpiryDateValidation<M1: Cuckoo.Matchable>(isValid: M1)
            -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool
        {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: isValid) { $0 }]
            return cuckoo_manager.verify(
                """
                handleExpiryDateValidation(isValid: Bool)
                """, callMatcher: callMatcher, parameterMatchers: matchers,
                sourceLocation: sourceLocation)
        }

        @discardableResult
        func notifyMerchantOfExpiryDateValidationState() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                """
                notifyMerchantOfExpiryDateValidationState()
                """, callMatcher: callMatcher, parameterMatchers: matchers,
                sourceLocation: sourceLocation)
        }

    }
}

class ExpiryDateValidationStateHandlerStub: ExpiryDateValidationStateHandler {

    func handleExpiryDateValidation(isValid: Bool) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }

    func notifyMerchantOfExpiryDateValidationState() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }

}
