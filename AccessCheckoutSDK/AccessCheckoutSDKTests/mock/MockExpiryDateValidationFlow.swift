import Cuckoo
@testable import AccessCheckoutSDK


 class MockExpiryDateValidationFlow: ExpiryDateValidationFlow, Cuckoo.ClassMock {
    
     typealias MocksType = ExpiryDateValidationFlow
    
     typealias Stubbing = __StubbingProxy_ExpiryDateValidationFlow
     typealias Verification = __VerificationProxy_ExpiryDateValidationFlow

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: ExpiryDateValidationFlow?

     func enableDefaultImplementation(_ stub: ExpiryDateValidationFlow) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     override func validate(expiryMonth: ExpiryMonth?, expiryYear: ExpiryYear?)  {
        
    return cuckoo_manager.call("validate(expiryMonth: ExpiryMonth?, expiryYear: ExpiryYear?)",
            parameters: (expiryMonth, expiryYear),
            escapingParameters: (expiryMonth, expiryYear),
            superclassCall:
                
                super.validate(expiryMonth: expiryMonth, expiryYear: expiryYear)
                ,
            defaultCall: __defaultImplStub!.validate(expiryMonth: expiryMonth, expiryYear: expiryYear))
        
    }
    

	 struct __StubbingProxy_ExpiryDateValidationFlow: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func validate<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable>(expiryMonth: M1, expiryYear: M2) -> Cuckoo.ClassStubNoReturnFunction<(ExpiryMonth?, ExpiryYear?)> where M1.OptionalMatchedType == ExpiryMonth, M2.OptionalMatchedType == ExpiryYear {
	        let matchers: [Cuckoo.ParameterMatcher<(ExpiryMonth?, ExpiryYear?)>] = [wrap(matchable: expiryMonth) { $0.0 }, wrap(matchable: expiryYear) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockExpiryDateValidationFlow.self, method: "validate(expiryMonth: ExpiryMonth?, expiryYear: ExpiryYear?)", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_ExpiryDateValidationFlow: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func validate<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable>(expiryMonth: M1, expiryYear: M2) -> Cuckoo.__DoNotUse<(ExpiryMonth?, ExpiryYear?), Void> where M1.OptionalMatchedType == ExpiryMonth, M2.OptionalMatchedType == ExpiryYear {
	        let matchers: [Cuckoo.ParameterMatcher<(ExpiryMonth?, ExpiryYear?)>] = [wrap(matchable: expiryMonth) { $0.0 }, wrap(matchable: expiryYear) { $0.1 }]
	        return cuckoo_manager.verify("validate(expiryMonth: ExpiryMonth?, expiryYear: ExpiryYear?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class ExpiryDateValidationFlowStub: ExpiryDateValidationFlow {
    

    

    
     override func validate(expiryMonth: ExpiryMonth?, expiryYear: ExpiryYear?)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}

