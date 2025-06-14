import Cuckoo
import Foundation

@testable import AccessCheckoutSDK

class MockPanValidationFlow: PanValidationFlow, Cuckoo.ClassMock {

    typealias MocksType = PanValidationFlow

    typealias Stubbing = __StubbingProxy_PanValidationFlow
    typealias Verification = __VerificationProxy_PanValidationFlow

    let cuckoo_manager =
        Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    private var __defaultImplStub: PanValidationFlow?

    func enableDefaultImplementation(_ stub: PanValidationFlow) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    override func validate(pan: String) {

        return cuckoo_manager.call(
            """
            validate(pan: String)
            """,
            parameters: (pan),
            escapingParameters: (pan),
            superclassCall:

                super.validate(pan: pan),
            defaultCall: __defaultImplStub!.validate(pan: pan))

    }

    override func notifyMerchant() {

        return cuckoo_manager.call(
            """
            notifyMerchant()
            """,
            parameters: (),
            escapingParameters: (),
            superclassCall:

                super.notifyMerchant(),
            defaultCall: __defaultImplStub!.notifyMerchant())

    }

    override func getCardBrand() -> CardBrandModel? {

        return cuckoo_manager.call(
            """
            getCardBrand() -> CardBrandModel?
            """,
            parameters: (),
            escapingParameters: (),
            superclassCall:

                super.getCardBrand(),
            defaultCall: __defaultImplStub!.getCardBrand())

    }

    struct __StubbingProxy_PanValidationFlow: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }

        func validate<M1: Cuckoo.Matchable>(pan: M1) -> Cuckoo.ClassStubNoReturnFunction<(String)>
        where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pan) { $0 }]
            return .init(
                stub: cuckoo_manager.createStub(
                    for: MockPanValidationFlow.self,
                    method:
                        """
                        validate(pan: String)
                        """, parameterMatchers: matchers))
        }

        func notifyMerchant() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(
                stub: cuckoo_manager.createStub(
                    for: MockPanValidationFlow.self,
                    method:
                        """
                        notifyMerchant()
                        """, parameterMatchers: matchers))
        }

        func getCardBrand() -> Cuckoo.ClassStubFunction<(), CardBrandModel?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(
                stub: cuckoo_manager.createStub(
                    for: MockPanValidationFlow.self,
                    method:
                        """
                        getCardBrand() -> CardBrandModel?
                        """, parameterMatchers: matchers))
        }

    }

    struct __VerificationProxy_PanValidationFlow: Cuckoo.VerificationProxy {
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
        func validate<M1: Cuckoo.Matchable>(pan: M1) -> Cuckoo.__DoNotUse<(String), Void>
        where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pan) { $0 }]
            return cuckoo_manager.verify(
                """
                validate(pan: String)
                """, callMatcher: callMatcher, parameterMatchers: matchers,
                sourceLocation: sourceLocation)
        }

        @discardableResult
        func notifyMerchant() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                """
                notifyMerchant()
                """, callMatcher: callMatcher, parameterMatchers: matchers,
                sourceLocation: sourceLocation)
        }

        @discardableResult
        func getCardBrand() -> Cuckoo.__DoNotUse<(), CardBrandModel?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                """
                getCardBrand() -> CardBrandModel?
                """, callMatcher: callMatcher, parameterMatchers: matchers,
                sourceLocation: sourceLocation)
        }

    }
}

class PanValidationFlowStub: PanValidationFlow {

    override func validate(pan: String) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }

    override func notifyMerchant() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }

    override func getCardBrand() -> CardBrandModel? {
        return DefaultValueRegistry.defaultValue(for: (CardBrandModel?).self)
    }

}
