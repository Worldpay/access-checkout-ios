import Cuckoo

@testable import AccessCheckoutSDK

class MockCardValidationStateHandler: CardValidationStateHandler, Cuckoo.ClassMock {

    typealias MocksType = CardValidationStateHandler

    typealias Stubbing = __StubbingProxy_CardValidationStateHandler
    typealias Verification = __VerificationProxy_CardValidationStateHandler

    let cuckoo_manager =
        Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    private var __defaultImplStub: CardValidationStateHandler?

    func enableDefaultImplementation(_ stub: CardValidationStateHandler) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    override var merchantDelegate: AccessCheckoutCardValidationDelegate {
        return cuckoo_manager.getter(
            "merchantDelegate",
            superclassCall:

                super.merchantDelegate,
            defaultCall: __defaultImplStub!.merchantDelegate)

    }

    override var panIsValid: Bool {
        return cuckoo_manager.getter(
            "panIsValid",
            superclassCall:

                super.panIsValid,
            defaultCall: __defaultImplStub!.panIsValid)

    }

    override var expiryDateIsValid: Bool {
        return cuckoo_manager.getter(
            "expiryDateIsValid",
            superclassCall:

                super.expiryDateIsValid,
            defaultCall: __defaultImplStub!.expiryDateIsValid)

    }

    override var cvcIsValid: Bool {
        return cuckoo_manager.getter(
            "cvcIsValid",
            superclassCall:

                super.cvcIsValid,
            defaultCall: __defaultImplStub!.cvcIsValid)

    }

    override var cardBrands: [CardBrandModel] {
        return cuckoo_manager.getter(
            "cardBrands",
            superclassCall:

                super.cardBrands,
            defaultCall: __defaultImplStub!.cardBrands)

    }

    struct __StubbingProxy_CardValidationStateHandler: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }

        var merchantDelegate:
            Cuckoo.ClassToBeStubbedReadOnlyProperty<
                MockCardValidationStateHandler, AccessCheckoutCardValidationDelegate
            >
        {
            return .init(manager: cuckoo_manager, name: "merchantDelegate")
        }

        var panIsValid:
            Cuckoo.ClassToBeStubbedReadOnlyProperty<MockCardValidationStateHandler, Bool>
        {
            return .init(manager: cuckoo_manager, name: "panIsValid")
        }

        var expiryDateIsValid:
            Cuckoo.ClassToBeStubbedReadOnlyProperty<MockCardValidationStateHandler, Bool>
        {
            return .init(manager: cuckoo_manager, name: "expiryDateIsValid")
        }

        var cvcIsValid:
            Cuckoo.ClassToBeStubbedReadOnlyProperty<MockCardValidationStateHandler, Bool>
        {
            return .init(manager: cuckoo_manager, name: "cvcIsValid")
        }

        var cardBrands:
            Cuckoo.ClassToBeStubbedReadOnlyProperty<
                MockCardValidationStateHandler, [CardBrandModel]
            >
        {
            return .init(manager: cuckoo_manager, name: "cardBrands")
        }

    }

    struct __VerificationProxy_CardValidationStateHandler: Cuckoo.VerificationProxy {
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

        var merchantDelegate: Cuckoo.VerifyReadOnlyProperty<AccessCheckoutCardValidationDelegate> {
            return .init(
                manager: cuckoo_manager, name: "merchantDelegate", callMatcher: callMatcher,
                sourceLocation: sourceLocation)
        }

        var panIsValid: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(
                manager: cuckoo_manager, name: "panIsValid", callMatcher: callMatcher,
                sourceLocation: sourceLocation)
        }

        var expiryDateIsValid: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(
                manager: cuckoo_manager, name: "expiryDateIsValid", callMatcher: callMatcher,
                sourceLocation: sourceLocation)
        }

        var cvcIsValid: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(
                manager: cuckoo_manager, name: "cvcIsValid", callMatcher: callMatcher,
                sourceLocation: sourceLocation)
        }

        var cardBrands: Cuckoo.VerifyReadOnlyProperty<[CardBrandModel]> {
            return .init(
                manager: cuckoo_manager, name: "cardBrands", callMatcher: callMatcher,
                sourceLocation: sourceLocation)
        }

    }
}

class CardValidationStateHandlerStub: CardValidationStateHandler {

    override var merchantDelegate: AccessCheckoutCardValidationDelegate {
        return DefaultValueRegistry.defaultValue(for: (AccessCheckoutCardValidationDelegate).self)

    }

    override var panIsValid: Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)

    }

    override var expiryDateIsValid: Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)

    }

    override var cvcIsValid: Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)

    }

    override var cardBrands: [CardBrandModel] {
        return DefaultValueRegistry.defaultValue(for: ([CardBrandModel]).self)

    }

}
