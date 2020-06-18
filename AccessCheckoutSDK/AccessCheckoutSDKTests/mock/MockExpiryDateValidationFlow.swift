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
    

    

    

    
    
    
     override func validate(expiryDate: String)  {
        
    return cuckoo_manager.call("validate(expiryDate: String)",
            parameters: (expiryDate),
            escapingParameters: (expiryDate),
            superclassCall:
                
                super.validate(expiryDate: expiryDate)
                ,
            defaultCall: __defaultImplStub!.validate(expiryDate: expiryDate))
        
    }
    
    
    
     override func notifyMerchantIfNotAlreadyNotified()  {
        
    return cuckoo_manager.call("notifyMerchantIfNotAlreadyNotified()",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.notifyMerchantIfNotAlreadyNotified()
                ,
            defaultCall: __defaultImplStub!.notifyMerchantIfNotAlreadyNotified())
        
    }
    

	 struct __StubbingProxy_ExpiryDateValidationFlow: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func validate<M1: Cuckoo.Matchable>(expiryDate: M1) -> Cuckoo.ClassStubNoReturnFunction<(String)> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: expiryDate) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockExpiryDateValidationFlow.self, method: "validate(expiryDate: String)", parameterMatchers: matchers))
	    }
	    
	    func notifyMerchantIfNotAlreadyNotified() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockExpiryDateValidationFlow.self, method: "notifyMerchantIfNotAlreadyNotified()", parameterMatchers: matchers))
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
	    func validate<M1: Cuckoo.Matchable>(expiryDate: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: expiryDate) { $0 }]
	        return cuckoo_manager.verify("validate(expiryDate: String)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func notifyMerchantIfNotAlreadyNotified() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("notifyMerchantIfNotAlreadyNotified()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class ExpiryDateValidationFlowStub: ExpiryDateValidationFlow {
    

    

    
     override func validate(expiryDate: String)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     override func notifyMerchantIfNotAlreadyNotified()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}

