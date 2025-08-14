import Cuckoo

@testable import AccessCheckoutSDK

class MockCvcValidationFlow: CvcValidationFlow, Cuckoo.ClassMock {

    typealias MocksType = CvcValidationFlow

    typealias Stubbing = __StubbingProxy_CvcValidationFlow
    typealias Verification = __VerificationProxy_CvcValidationFlow

    let cuckoo_manager =
        Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    private var __defaultImplStub: CvcValidationFlow?

    func enableDefaultImplementation(_ stub: CvcValidationFlow) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    override var validationRule: ValidationRule {
        return cuckoo_manager.getter(
            "validationRule",
            superclassCall:

                super.validationRule,
            defaultCall: __defaultImplStub!.validationRule)

    }

    override var cvc: String? {
        return cuckoo_manager.getter(
            "cvc",
            superclassCall:

                super.cvc,
            defaultCall: __defaultImplStub!.cvc)

    }

    override func validate(cvc: String?) {

        return cuckoo_manager.call(
            """
            validate(cvc: String?)
            """,
            parameters: (cvc),
            escapingParameters: (cvc),
            superclassCall:

                super.validate(cvc: cvc),
            defaultCall: __defaultImplStub!.validate(cvc: cvc))

    }

    override func resetValidationRule() {

        return cuckoo_manager.call(
            """
            resetValidationRule()
            """,
            parameters: (),
            escapingParameters: (),
            superclassCall:

                super.resetValidationRule(),
            defaultCall: __defaultImplStub!.resetValidationRule())

    }

    override func revalidate() {

        return cuckoo_manager.call(
            """
            revalidate()
            """,
            parameters: (),
            escapingParameters: (),
            superclassCall:

                super.revalidate(),
            defaultCall: __defaultImplStub!.revalidate())

    }

    override func updateValidationRule(with rule: ValidationRule) {

        return cuckoo_manager.call(
            """
            updateValidationRule(with: ValidationRule)
            """,
            parameters: (rule),
            escapingParameters: (rule),
            superclassCall:

                super.updateValidationRule(with: rule),
            defaultCall: __defaultImplStub!.updateValidationRule(with: rule))

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

    struct __StubbingProxy_CvcValidationFlow: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }

        var validationRule:
            Cuckoo.ClassToBeStubbedReadOnlyProperty<MockCvcValidationFlow, ValidationRule>
        {
            return .init(manager: cuckoo_manager, name: "validationRule")
        }

        var cvc: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockCvcValidationFlow, String?> {
            return .init(manager: cuckoo_manager, name: "cvc")
        }

        func validate<M1: Cuckoo.OptionalMatchable>(cvc: M1)
            -> Cuckoo.ClassStubNoReturnFunction<(String?)> where M1.OptionalMatchedType == String
        {
            let matchers: [Cuckoo.ParameterMatcher<(String?)>] = [wrap(matchable: cvc) { $0 }]
            return .init(
                stub: cuckoo_manager.createStub(
                    for: MockCvcValidationFlow.self,
                    method:
                        """
                        validate(cvc: String?)
                        """, parameterMatchers: matchers))
        }

        func resetValidationRule() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(
                stub: cuckoo_manager.createStub(
                    for: MockCvcValidationFlow.self,
                    method:
                        """
                        resetValidationRule()
                        """, parameterMatchers: matchers))
        }

        func revalidate() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(
                stub: cuckoo_manager.createStub(
                    for: MockCvcValidationFlow.self,
                    method:
                        """
                        revalidate()
                        """, parameterMatchers: matchers))
        }

        func updateValidationRule<M1: Cuckoo.Matchable>(with rule: M1)
            -> Cuckoo.ClassStubNoReturnFunction<(ValidationRule)>
        where M1.MatchedType == ValidationRule {
            let matchers: [Cuckoo.ParameterMatcher<(ValidationRule)>] = [
                wrap(matchable: rule) { $0 }
            ]
            return .init(
                stub: cuckoo_manager.createStub(
                    for: MockCvcValidationFlow.self,
                    method:
                        """
                        updateValidationRule(with: ValidationRule)
                        """, parameterMatchers: matchers))
        }

        func notifyMerchant() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(
                stub: cuckoo_manager.createStub(
                    for: MockCvcValidationFlow.self,
                    method:
                        """
                        notifyMerchant()
                        """, parameterMatchers: matchers))
        }

    }

    struct __VerificationProxy_CvcValidationFlow: Cuckoo.VerificationProxy {
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

        var validationRule: Cuckoo.VerifyReadOnlyProperty<ValidationRule> {
            return .init(
                manager: cuckoo_manager, name: "validationRule", callMatcher: callMatcher,
                sourceLocation: sourceLocation)
        }

        var cvc: Cuckoo.VerifyReadOnlyProperty<String?> {
            return .init(
                manager: cuckoo_manager, name: "cvc", callMatcher: callMatcher,
                sourceLocation: sourceLocation)
        }

        @discardableResult
        func validate<M1: Cuckoo.OptionalMatchable>(cvc: M1) -> Cuckoo.__DoNotUse<(String?), Void>
        where M1.OptionalMatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String?)>] = [wrap(matchable: cvc) { $0 }]
            return cuckoo_manager.verify(
                """
                validate(cvc: String?)
                """, callMatcher: callMatcher, parameterMatchers: matchers,
                sourceLocation: sourceLocation)
        }

        @discardableResult
        func resetValidationRule() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                """
                resetValidationRule()
                """, callMatcher: callMatcher, parameterMatchers: matchers,
                sourceLocation: sourceLocation)
        }

        @discardableResult
        func revalidate() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                """
                revalidate()
                """, callMatcher: callMatcher, parameterMatchers: matchers,
                sourceLocation: sourceLocation)
        }

        @discardableResult
        func updateValidationRule<M1: Cuckoo.Matchable>(with rule: M1)
            -> Cuckoo.__DoNotUse<(ValidationRule), Void> where M1.MatchedType == ValidationRule
        {
            let matchers: [Cuckoo.ParameterMatcher<(ValidationRule)>] = [
                wrap(matchable: rule) { $0 }
            ]
            return cuckoo_manager.verify(
                """
                updateValidationRule(with: ValidationRule)
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

    }
}

class CvcValidationFlowStub: CvcValidationFlow {

    override var validationRule: ValidationRule {
        return DefaultValueRegistry.defaultValue(for: (ValidationRule).self)

    }

    override var cvc: String? {
        return DefaultValueRegistry.defaultValue(for: (String?).self)

    }

    override func validate(cvc: String?) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }

    override func resetValidationRule() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }

    override func revalidate() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }

    override func updateValidationRule(with rule: ValidationRule) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }

    override func notifyMerchant() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }

}
