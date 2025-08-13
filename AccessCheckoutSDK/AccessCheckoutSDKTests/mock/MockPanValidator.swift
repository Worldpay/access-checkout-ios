import Cuckoo
@testable import AccessCheckoutSDK






 class MockPanValidator: PanValidator, Cuckoo.ClassMock {
    
     typealias MocksType = PanValidator
    
     typealias Stubbing = __StubbingProxy_PanValidator
     typealias Verification = __VerificationProxy_PanValidator

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: PanValidator?

     func enableDefaultImplementation(_ stub: PanValidator) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func validate(pan: String) -> PanValidationResult {
        
    return cuckoo_manager.call(
    """
    validate(pan: String) -> PanValidationResult
    """,
            parameters: (pan),
            escapingParameters: (pan),
            superclassCall:
                
                super.validate(pan: pan)
                ,
            defaultCall: __defaultImplStub!.validate(pan: pan))
        
    }
    
    
    
    
    
     override func canValidate(_ pan: String) -> Bool {
        
    return cuckoo_manager.call(
    """
    canValidate(_: String) -> Bool
    """,
            parameters: (pan),
            escapingParameters: (pan),
            superclassCall:
                
                super.canValidate(pan)
                ,
            defaultCall: __defaultImplStub!.canValidate(pan))
        
    }
    
    

     struct __StubbingProxy_PanValidator: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func validate<M1: Cuckoo.Matchable>(pan: M1) -> Cuckoo.ClassStubFunction<(String), PanValidationResult> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pan) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPanValidator.self, method:
    """
    validate(pan: String) -> PanValidationResult
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func canValidate<M1: Cuckoo.Matchable>(_ pan: M1) -> Cuckoo.ClassStubFunction<(String), Bool> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pan) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPanValidator.self, method:
    """
    canValidate(_: String) -> Bool
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_PanValidator: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func validate<M1: Cuckoo.Matchable>(pan: M1) -> Cuckoo.__DoNotUse<(String), PanValidationResult> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pan) { $0 }]
            return cuckoo_manager.verify(
    """
    validate(pan: String) -> PanValidationResult
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func canValidate<M1: Cuckoo.Matchable>(_ pan: M1) -> Cuckoo.__DoNotUse<(String), Bool> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pan) { $0 }]
            return cuckoo_manager.verify(
    """
    canValidate(_: String) -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class PanValidatorStub: PanValidator {
    

    

    
    
    
    
     override func validate(pan: String) -> PanValidationResult  {
        return DefaultValueRegistry.defaultValue(for: (PanValidationResult).self)
    }
    
    
    
    
    
     override func canValidate(_ pan: String) -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
}
