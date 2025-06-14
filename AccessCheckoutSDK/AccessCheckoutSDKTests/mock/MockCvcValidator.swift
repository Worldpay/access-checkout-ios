import Cuckoo

@testable import AccessCheckoutSDK

class MockCvcValidator: CvcValidator, Cuckoo.ClassMock {

    typealias MocksType = CvcValidator

    typealias Stubbing = __StubbingProxy_CvcValidator
    typealias Verification = __VerificationProxy_CvcValidator

    let cuckoo_manager =
        Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    private var __defaultImplStub: CvcValidator?

    func enableDefaultImplementation(_ stub: CvcValidator) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    override func validate(cvc: String?, validationRule: ValidationRule) -> Bool {

        return cuckoo_manager.call(
            """
            validate(cvc: String?, validationRule: ValidationRule) -> Bool
            """,
            parameters: (cvc, validationRule),
            escapingParameters: (cvc, validationRule),
            superclassCall:

                super.validate(cvc: cvc, validationRule: validationRule),
            defaultCall: __defaultImplStub!.validate(cvc: cvc, validationRule: validationRule))

    }

    override func canValidate(_ text: String, using validationRule: ValidationRule) -> Bool {

        return cuckoo_manager.call(
            """
            canValidate(_: String, using: ValidationRule) -> Bool
            """,
            parameters: (text, validationRule),
            escapingParameters: (text, validationRule),
            superclassCall:

                super.canValidate(text, using: validationRule),
            defaultCall: __defaultImplStub!.canValidate(text, using: validationRule))

    }

    struct __StubbingProxy_CvcValidator: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }

        func validate<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable>(
            cvc: M1, validationRule: M2
        ) -> Cuckoo.ClassStubFunction<(String?, ValidationRule), Bool>
        where M1.OptionalMatchedType == String, M2.MatchedType == ValidationRule {
            let matchers: [Cuckoo.ParameterMatcher<(String?, ValidationRule)>] = [
                wrap(matchable: cvc) { $0.0 }, wrap(matchable: validationRule) { $0.1 },
            ]
            return .init(
                stub: cuckoo_manager.createStub(
                    for: MockCvcValidator.self,
                    method:
                        """
                        validate(cvc: String?, validationRule: ValidationRule) -> Bool
                        """, parameterMatchers: matchers))
        }

        func canValidate<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(
            _ text: M1, using validationRule: M2
        ) -> Cuckoo.ClassStubFunction<(String, ValidationRule), Bool>
        where M1.MatchedType == String, M2.MatchedType == ValidationRule {
            let matchers: [Cuckoo.ParameterMatcher<(String, ValidationRule)>] = [
                wrap(matchable: text) { $0.0 }, wrap(matchable: validationRule) { $0.1 },
            ]
            return .init(
                stub: cuckoo_manager.createStub(
                    for: MockCvcValidator.self,
                    method:
                        """
                        canValidate(_: String, using: ValidationRule) -> Bool
                        """, parameterMatchers: matchers))
        }

    }

    struct __VerificationProxy_CvcValidator: Cuckoo.VerificationProxy {
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
        func validate<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable>(
            cvc: M1, validationRule: M2
        ) -> Cuckoo.__DoNotUse<(String?, ValidationRule), Bool>
        where M1.OptionalMatchedType == String, M2.MatchedType == ValidationRule {
            let matchers: [Cuckoo.ParameterMatcher<(String?, ValidationRule)>] = [
                wrap(matchable: cvc) { $0.0 }, wrap(matchable: validationRule) { $0.1 },
            ]
            return cuckoo_manager.verify(
                """
                validate(cvc: String?, validationRule: ValidationRule) -> Bool
                """, callMatcher: callMatcher, parameterMatchers: matchers,
                sourceLocation: sourceLocation)
        }

        @discardableResult
        func canValidate<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(
            _ text: M1, using validationRule: M2
        ) -> Cuckoo.__DoNotUse<(String, ValidationRule), Bool>
        where M1.MatchedType == String, M2.MatchedType == ValidationRule {
            let matchers: [Cuckoo.ParameterMatcher<(String, ValidationRule)>] = [
                wrap(matchable: text) { $0.0 }, wrap(matchable: validationRule) { $0.1 },
            ]
            return cuckoo_manager.verify(
                """
                canValidate(_: String, using: ValidationRule) -> Bool
                """, callMatcher: callMatcher, parameterMatchers: matchers,
                sourceLocation: sourceLocation)
        }

    }
}

class CvcValidatorStub: CvcValidator {

    override func validate(cvc: String?, validationRule: ValidationRule) -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }

    override func canValidate(_ text: String, using validationRule: ValidationRule) -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }

}
