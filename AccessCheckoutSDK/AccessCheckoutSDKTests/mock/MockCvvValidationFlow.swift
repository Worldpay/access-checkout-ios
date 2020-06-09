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
    

    
    
    
     override var validationRule: ValidationRule {
        get {
            return cuckoo_manager.getter("validationRule",
                superclassCall:
                    
                    super.validationRule
                    ,
                defaultCall: __defaultImplStub!.validationRule)
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
    

    

    
    
    
     override func validate(cvv: CVV?)  {
        
    return cuckoo_manager.call("validate(cvv: CVV?)",
            parameters: (cvv),
            escapingParameters: (cvv),
            superclassCall:
                
                super.validate(cvv: cvv)
                ,
            defaultCall: __defaultImplStub!.validate(cvv: cvv))
        
    }
    
    
    
     override func resetValidationRule()  {
        
    return cuckoo_manager.call("resetValidationRule()",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.resetValidationRule()
                ,
            defaultCall: __defaultImplStub!.resetValidationRule())
        
    }
    
    
    
     override func revalidate()  {
        
    return cuckoo_manager.call("revalidate()",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.revalidate()
                ,
            defaultCall: __defaultImplStub!.revalidate())
        
    }
    
    
    
     override func updateValidationRule(with rule: ValidationRule)  {
        
    return cuckoo_manager.call("updateValidationRule(with: ValidationRule)",
            parameters: (rule),
            escapingParameters: (rule),
            superclassCall:
                
                super.updateValidationRule(with: rule)
                ,
            defaultCall: __defaultImplStub!.updateValidationRule(with: rule))
        
    }
    

	 struct __StubbingProxy_CvvValidationFlow: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var validationRule: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockCvvValidationFlow, ValidationRule> {
	        return .init(manager: cuckoo_manager, name: "validationRule")
	    }
	    
	    
	    var cvv: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockCvvValidationFlow, CVV?> {
	        return .init(manager: cuckoo_manager, name: "cvv")
	    }
	    
	    
	    func validate<M1: Cuckoo.OptionalMatchable>(cvv: M1) -> Cuckoo.ClassStubNoReturnFunction<(CVV?)> where M1.OptionalMatchedType == CVV {
	        let matchers: [Cuckoo.ParameterMatcher<(CVV?)>] = [wrap(matchable: cvv) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCvvValidationFlow.self, method: "validate(cvv: CVV?)", parameterMatchers: matchers))
	    }
	    
	    func resetValidationRule() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockCvvValidationFlow.self, method: "resetValidationRule()", parameterMatchers: matchers))
	    }
	    
	    func revalidate() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockCvvValidationFlow.self, method: "revalidate()", parameterMatchers: matchers))
	    }
	    
	    func updateValidationRule<M1: Cuckoo.Matchable>(with rule: M1) -> Cuckoo.ClassStubNoReturnFunction<(ValidationRule)> where M1.MatchedType == ValidationRule {
	        let matchers: [Cuckoo.ParameterMatcher<(ValidationRule)>] = [wrap(matchable: rule) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCvvValidationFlow.self, method: "updateValidationRule(with: ValidationRule)", parameterMatchers: matchers))
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
	
	    
	    
	    var validationRule: Cuckoo.VerifyReadOnlyProperty<ValidationRule> {
	        return .init(manager: cuckoo_manager, name: "validationRule", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var cvv: Cuckoo.VerifyReadOnlyProperty<CVV?> {
	        return .init(manager: cuckoo_manager, name: "cvv", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func validate<M1: Cuckoo.OptionalMatchable>(cvv: M1) -> Cuckoo.__DoNotUse<(CVV?), Void> where M1.OptionalMatchedType == CVV {
	        let matchers: [Cuckoo.ParameterMatcher<(CVV?)>] = [wrap(matchable: cvv) { $0 }]
	        return cuckoo_manager.verify("validate(cvv: CVV?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func resetValidationRule() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("resetValidationRule()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func revalidate() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("revalidate()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func updateValidationRule<M1: Cuckoo.Matchable>(with rule: M1) -> Cuckoo.__DoNotUse<(ValidationRule), Void> where M1.MatchedType == ValidationRule {
	        let matchers: [Cuckoo.ParameterMatcher<(ValidationRule)>] = [wrap(matchable: rule) { $0 }]
	        return cuckoo_manager.verify("updateValidationRule(with: ValidationRule)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class CvvValidationFlowStub: CvvValidationFlow {
    
    
     override var validationRule: ValidationRule {
        get {
            return DefaultValueRegistry.defaultValue(for: (ValidationRule).self)
        }
        
    }
    
    
     override var cvv: CVV? {
        get {
            return DefaultValueRegistry.defaultValue(for: (CVV?).self)
        }
        
    }
    

    

    
     override func validate(cvv: CVV?)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     override func resetValidationRule()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     override func revalidate()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     override func updateValidationRule(with rule: ValidationRule)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}

