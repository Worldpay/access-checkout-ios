import Cuckoo
@testable import AccessCheckoutSDK


 class MockCvvValidator: CvvValidator, Cuckoo.ClassMock {
    
     typealias MocksType = CvvValidator
    
     typealias Stubbing = __StubbingProxy_CvvValidator
     typealias Verification = __VerificationProxy_CvvValidator

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: CvvValidator?

     func enableDefaultImplementation(_ stub: CvvValidator) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     override func validate(cvv: CVV?, cvvRule: ValidationRule) -> Bool {
        
    return cuckoo_manager.call("validate(cvv: CVV?, cvvRule: ValidationRule) -> Bool",
            parameters: (cvv, cvvRule),
            escapingParameters: (cvv, cvvRule),
            superclassCall:
                
                super.validate(cvv: cvv, cvvRule: cvvRule)
                ,
            defaultCall: __defaultImplStub!.validate(cvv: cvv, cvvRule: cvvRule))
        
    }
    

	 struct __StubbingProxy_CvvValidator: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func validate<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable>(cvv: M1, cvvRule: M2) -> Cuckoo.ClassStubFunction<(CVV?, ValidationRule), Bool> where M1.OptionalMatchedType == CVV, M2.MatchedType == ValidationRule {
	        let matchers: [Cuckoo.ParameterMatcher<(CVV?, ValidationRule)>] = [wrap(matchable: cvv) { $0.0 }, wrap(matchable: cvvRule) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCvvValidator.self, method: "validate(cvv: CVV?, cvvRule: ValidationRule) -> Bool", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_CvvValidator: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func validate<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable>(cvv: M1, cvvRule: M2) -> Cuckoo.__DoNotUse<(CVV?, ValidationRule), Bool> where M1.OptionalMatchedType == CVV, M2.MatchedType == ValidationRule {
	        let matchers: [Cuckoo.ParameterMatcher<(CVV?, ValidationRule)>] = [wrap(matchable: cvv) { $0.0 }, wrap(matchable: cvvRule) { $0.1 }]
	        return cuckoo_manager.verify("validate(cvv: CVV?, cvvRule: ValidationRule) -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class CvvValidatorStub: CvvValidator {
    

    

    
     override func validate(cvv: CVV?, cvvRule: ValidationRule) -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
}

