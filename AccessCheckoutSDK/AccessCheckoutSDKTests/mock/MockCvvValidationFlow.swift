import Cuckoo
@testable import AccessCheckoutSDK


 class MockCvvValidationFlow: CvvValidationFlow, Cuckoo.ClassMock {
    
     typealias MocksType = CvvValidationFlow
    
     typealias Stubbing = __StubbingProxy_CvvValidationFlow
     typealias Verification = __VerificationProxy_CvvValidationFlow

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: CvvValidationFlow?

     func enableDefaultImplementation(_ stub: CvvValidationFlow) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
     override var cvvRule: ValidationRule {
        get {
            return cuckoo_manager.getter("cvvRule",
                superclassCall:
                    
                    super.cvvRule
                    ,
                defaultCall: __defaultImplStub!.cvvRule)
        }
        
    }
    
    
    
     override var cvv: CVV? {
        get {
            return cuckoo_manager.getter("cvv",
                superclassCall:
                    
                    super.cvv
                    ,
                defaultCall: __defaultImplStub!.cvv)
        }
        
    }
    

    

    
    
    
     override func validate(cvv: CVV?, cvvRule: ValidationRule)  {
        
    return cuckoo_manager.call("validate(cvv: CVV?, cvvRule: ValidationRule)",
            parameters: (cvv, cvvRule),
            escapingParameters: (cvv, cvvRule),
            superclassCall:
                
                super.validate(cvv: cvv, cvvRule: cvvRule)
                ,
            defaultCall: __defaultImplStub!.validate(cvv: cvv, cvvRule: cvvRule))
        
    }
    
    
    
     override func reValidate(cvvRule: ValidationRule?)  {
        
    return cuckoo_manager.call("reValidate(cvvRule: ValidationRule?)",
            parameters: (cvvRule),
            escapingParameters: (cvvRule),
            superclassCall:
                
                super.reValidate(cvvRule: cvvRule)
                ,
            defaultCall: __defaultImplStub!.reValidate(cvvRule: cvvRule))
        
    }
    

	 struct __StubbingProxy_CvvValidationFlow: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var cvvRule: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockCvvValidationFlow, ValidationRule> {
	        return .init(manager: cuckoo_manager, name: "cvvRule")
	    }
	    
	    
	    var cvv: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockCvvValidationFlow, CVV?> {
	        return .init(manager: cuckoo_manager, name: "cvv")
	    }
	    
	    
	    func validate<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable>(cvv: M1, cvvRule: M2) -> Cuckoo.ClassStubNoReturnFunction<(CVV?, ValidationRule)> where M1.OptionalMatchedType == CVV, M2.MatchedType == ValidationRule {
	        let matchers: [Cuckoo.ParameterMatcher<(CVV?, ValidationRule)>] = [wrap(matchable: cvv) { $0.0 }, wrap(matchable: cvvRule) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCvvValidationFlow.self, method: "validate(cvv: CVV?, cvvRule: ValidationRule)", parameterMatchers: matchers))
	    }
	    
	    func reValidate<M1: Cuckoo.OptionalMatchable>(cvvRule: M1) -> Cuckoo.ClassStubNoReturnFunction<(ValidationRule?)> where M1.OptionalMatchedType == ValidationRule {
	        let matchers: [Cuckoo.ParameterMatcher<(ValidationRule?)>] = [wrap(matchable: cvvRule) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCvvValidationFlow.self, method: "reValidate(cvvRule: ValidationRule?)", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_CvvValidationFlow: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var cvvRule: Cuckoo.VerifyReadOnlyProperty<ValidationRule> {
	        return .init(manager: cuckoo_manager, name: "cvvRule", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var cvv: Cuckoo.VerifyReadOnlyProperty<CVV?> {
	        return .init(manager: cuckoo_manager, name: "cvv", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func validate<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable>(cvv: M1, cvvRule: M2) -> Cuckoo.__DoNotUse<(CVV?, ValidationRule), Void> where M1.OptionalMatchedType == CVV, M2.MatchedType == ValidationRule {
	        let matchers: [Cuckoo.ParameterMatcher<(CVV?, ValidationRule)>] = [wrap(matchable: cvv) { $0.0 }, wrap(matchable: cvvRule) { $0.1 }]
	        return cuckoo_manager.verify("validate(cvv: CVV?, cvvRule: ValidationRule)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func reValidate<M1: Cuckoo.OptionalMatchable>(cvvRule: M1) -> Cuckoo.__DoNotUse<(ValidationRule?), Void> where M1.OptionalMatchedType == ValidationRule {
	        let matchers: [Cuckoo.ParameterMatcher<(ValidationRule?)>] = [wrap(matchable: cvvRule) { $0 }]
	        return cuckoo_manager.verify("reValidate(cvvRule: ValidationRule?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class CvvValidationFlowStub: CvvValidationFlow {
    
    
     override var cvvRule: ValidationRule {
        get {
            return DefaultValueRegistry.defaultValue(for: (ValidationRule).self)
        }
        
    }
    
    
     override var cvv: CVV? {
        get {
            return DefaultValueRegistry.defaultValue(for: (CVV?).self)
        }
        
    }
    

    

    
     override func validate(cvv: CVV?, cvvRule: ValidationRule)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     override func reValidate(cvvRule: ValidationRule?)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}

