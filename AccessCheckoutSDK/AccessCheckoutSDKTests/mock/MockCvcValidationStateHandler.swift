import Cuckoo
@testable import AccessCheckoutSDK






 class MockCvcValidationStateHandler: CvcValidationStateHandler, Cuckoo.ProtocolMock {
    
     typealias MocksType = CvcValidationStateHandler
    
     typealias Stubbing = __StubbingProxy_CvcValidationStateHandler
     typealias Verification = __VerificationProxy_CvcValidationStateHandler

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: CvcValidationStateHandler?

     func enableDefaultImplementation(_ stub: CvcValidationStateHandler) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func handleCvcValidation(isValid: Bool)  {
        
    return cuckoo_manager.call(
    """
    handleCvcValidation(isValid: Bool)
    """,
            parameters: (isValid),
            escapingParameters: (isValid),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.handleCvcValidation(isValid: isValid))
        
    }
    
    
    
    
    
     func notifyMerchantOfCvcValidationState()  {
        
    return cuckoo_manager.call(
    """
    notifyMerchantOfCvcValidationState()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.notifyMerchantOfCvcValidationState())
        
    }
    
    

     struct __StubbingProxy_CvcValidationStateHandler: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func handleCvcValidation<M1: Cuckoo.Matchable>(isValid: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: isValid) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockCvcValidationStateHandler.self, method:
    """
    handleCvcValidation(isValid: Bool)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func notifyMerchantOfCvcValidationState() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockCvcValidationStateHandler.self, method:
    """
    notifyMerchantOfCvcValidationState()
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_CvcValidationStateHandler: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func handleCvcValidation<M1: Cuckoo.Matchable>(isValid: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: isValid) { $0 }]
            return cuckoo_manager.verify(
    """
    handleCvcValidation(isValid: Bool)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func notifyMerchantOfCvcValidationState() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    notifyMerchantOfCvcValidationState()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class CvcValidationStateHandlerStub: CvcValidationStateHandler {
    

    

    
    
    
    
     func handleCvcValidation(isValid: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     func notifyMerchantOfCvcValidationState()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}




