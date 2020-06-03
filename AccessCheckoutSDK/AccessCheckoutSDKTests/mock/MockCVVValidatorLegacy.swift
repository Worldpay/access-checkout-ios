import Cuckoo
@testable import AccessCheckoutSDK


 class MockCVVValidatorLegacy: CVVValidatorLegacy, Cuckoo.ClassMock {
    
     typealias MocksType = CVVValidatorLegacy
    
     typealias Stubbing = __StubbingProxy_CVVValidatorLegacy
     typealias Verification = __VerificationProxy_CVVValidatorLegacy

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: CVVValidatorLegacy?

     func enableDefaultImplementation(_ stub: CVVValidatorLegacy) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     override func validate(cvv: CVV?) -> ValidationResult {
        
    return cuckoo_manager.call("validate(cvv: CVV?) -> ValidationResult",
            parameters: (cvv),
            escapingParameters: (cvv),
            superclassCall:
                
                super.validate(cvv: cvv)
                ,
            defaultCall: __defaultImplStub!.validate(cvv: cvv))
        
    }
    
    
    
     override func validate(cvv: CVV, againstValidationRule validationRule: CardConfiguration.CardValidationRule) -> ValidationResult {
        
    return cuckoo_manager.call("validate(cvv: CVV, againstValidationRule: CardConfiguration.CardValidationRule) -> ValidationResult",
            parameters: (cvv, validationRule),
            escapingParameters: (cvv, validationRule),
            superclassCall:
                
                super.validate(cvv: cvv, againstValidationRule: validationRule)
                ,
            defaultCall: __defaultImplStub!.validate(cvv: cvv, againstValidationRule: validationRule))
        
    }
    

	 struct __StubbingProxy_CVVValidatorLegacy: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func validate<M1: Cuckoo.OptionalMatchable>(cvv: M1) -> Cuckoo.ClassStubFunction<(CVV?), ValidationResult> where M1.OptionalMatchedType == CVV {
	        let matchers: [Cuckoo.ParameterMatcher<(CVV?)>] = [wrap(matchable: cvv) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCVVValidatorLegacy.self, method: "validate(cvv: CVV?) -> ValidationResult", parameterMatchers: matchers))
	    }
	    
	    func validate<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(cvv: M1, againstValidationRule validationRule: M2) -> Cuckoo.ClassStubFunction<(CVV, CardConfiguration.CardValidationRule), ValidationResult> where M1.MatchedType == CVV, M2.MatchedType == CardConfiguration.CardValidationRule {
	        let matchers: [Cuckoo.ParameterMatcher<(CVV, CardConfiguration.CardValidationRule)>] = [wrap(matchable: cvv) { $0.0 }, wrap(matchable: validationRule) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCVVValidatorLegacy.self, method: "validate(cvv: CVV, againstValidationRule: CardConfiguration.CardValidationRule) -> ValidationResult", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_CVVValidatorLegacy: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func validate<M1: Cuckoo.OptionalMatchable>(cvv: M1) -> Cuckoo.__DoNotUse<(CVV?), ValidationResult> where M1.OptionalMatchedType == CVV {
	        let matchers: [Cuckoo.ParameterMatcher<(CVV?)>] = [wrap(matchable: cvv) { $0 }]
	        return cuckoo_manager.verify("validate(cvv: CVV?) -> ValidationResult", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func validate<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(cvv: M1, againstValidationRule validationRule: M2) -> Cuckoo.__DoNotUse<(CVV, CardConfiguration.CardValidationRule), ValidationResult> where M1.MatchedType == CVV, M2.MatchedType == CardConfiguration.CardValidationRule {
	        let matchers: [Cuckoo.ParameterMatcher<(CVV, CardConfiguration.CardValidationRule)>] = [wrap(matchable: cvv) { $0.0 }, wrap(matchable: validationRule) { $0.1 }]
	        return cuckoo_manager.verify("validate(cvv: CVV, againstValidationRule: CardConfiguration.CardValidationRule) -> ValidationResult", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class CVVValidatorLegacyStub: CVVValidatorLegacy {
    

    

    
     override func validate(cvv: CVV?) -> ValidationResult  {
        return DefaultValueRegistry.defaultValue(for: (ValidationResult).self)
    }
    
     override func validate(cvv: CVV, againstValidationRule validationRule: CardConfiguration.CardValidationRule) -> ValidationResult  {
        return DefaultValueRegistry.defaultValue(for: (ValidationResult).self)
    }
    
}

