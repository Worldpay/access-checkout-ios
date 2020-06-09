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
    

    

    

    
    
    
     override func validate(pan: PAN) -> PanValidationResult {
        
    return cuckoo_manager.call("validate(pan: PAN) -> PanValidationResult",
            parameters: (pan),
            escapingParameters: (pan),
            superclassCall:
                
                super.validate(pan: pan)
                ,
            defaultCall: __defaultImplStub!.validate(pan: pan))
        
    }
    
    
    
     override func canValidate(pan: PAN) -> Bool {
        
    return cuckoo_manager.call("canValidate(pan: PAN) -> Bool",
            parameters: (pan),
            escapingParameters: (pan),
            superclassCall:
                
                super.canValidate(pan: pan)
                ,
            defaultCall: __defaultImplStub!.canValidate(pan: pan))
        
    }
    

	 struct __StubbingProxy_PanValidator: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func validate<M1: Cuckoo.Matchable>(pan: M1) -> Cuckoo.ClassStubFunction<(PAN), PanValidationResult> where M1.MatchedType == PAN {
	        let matchers: [Cuckoo.ParameterMatcher<(PAN)>] = [wrap(matchable: pan) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockPanValidator.self, method: "validate(pan: PAN) -> PanValidationResult", parameterMatchers: matchers))
	    }
	    
	    func canValidate<M1: Cuckoo.Matchable>(pan: M1) -> Cuckoo.ClassStubFunction<(PAN), Bool> where M1.MatchedType == PAN {
	        let matchers: [Cuckoo.ParameterMatcher<(PAN)>] = [wrap(matchable: pan) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockPanValidator.self, method: "canValidate(pan: PAN) -> Bool", parameterMatchers: matchers))
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
	    func validate<M1: Cuckoo.Matchable>(pan: M1) -> Cuckoo.__DoNotUse<(PAN), PanValidationResult> where M1.MatchedType == PAN {
	        let matchers: [Cuckoo.ParameterMatcher<(PAN)>] = [wrap(matchable: pan) { $0 }]
	        return cuckoo_manager.verify("validate(pan: PAN) -> PanValidationResult", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func canValidate<M1: Cuckoo.Matchable>(pan: M1) -> Cuckoo.__DoNotUse<(PAN), Bool> where M1.MatchedType == PAN {
	        let matchers: [Cuckoo.ParameterMatcher<(PAN)>] = [wrap(matchable: pan) { $0 }]
	        return cuckoo_manager.verify("canValidate(pan: PAN) -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class PanValidatorStub: PanValidator {
    

    

    
     override func validate(pan: PAN) -> PanValidationResult  {
        return DefaultValueRegistry.defaultValue(for: (PanValidationResult).self)
    }
    
     override func canValidate(pan: PAN) -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
}

