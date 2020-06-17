import Cuckoo
@testable import AccessCheckoutSDK


 class MockCvvValidationStateHandler: CvvValidationStateHandler, Cuckoo.ProtocolMock {
    
     typealias MocksType = CvvValidationStateHandler
    
     typealias Stubbing = __StubbingProxy_CvvValidationStateHandler
     typealias Verification = __VerificationProxy_CvvValidationStateHandler

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: CvvValidationStateHandler?

     func enableDefaultImplementation(_ stub: CvvValidationStateHandler) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
     var alreadyNotifiedMerchantOfCvvValidationState: Bool {
        get {
            return cuckoo_manager.getter("alreadyNotifiedMerchantOfCvvValidationState",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.alreadyNotifiedMerchantOfCvvValidationState)
        }
        
    }
    

    

    
    
    
     func handleCvvValidation(isValid: Bool)  {
        
    return cuckoo_manager.call("handleCvvValidation(isValid: Bool)",
            parameters: (isValid),
            escapingParameters: (isValid),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.handleCvvValidation(isValid: isValid))
        
    }
    
    
    
     func notifyMerchantOfCvvValidationState()  {
        
    return cuckoo_manager.call("notifyMerchantOfCvvValidationState()",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.notifyMerchantOfCvvValidationState())
        
    }
    

	 struct __StubbingProxy_CvvValidationStateHandler: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var alreadyNotifiedMerchantOfCvvValidationState: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockCvvValidationStateHandler, Bool> {
	        return .init(manager: cuckoo_manager, name: "alreadyNotifiedMerchantOfCvvValidationState")
	    }
	    
	    
	    func handleCvvValidation<M1: Cuckoo.Matchable>(isValid: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: isValid) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCvvValidationStateHandler.self, method: "handleCvvValidation(isValid: Bool)", parameterMatchers: matchers))
	    }
	    
	    func notifyMerchantOfCvvValidationState() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockCvvValidationStateHandler.self, method: "notifyMerchantOfCvvValidationState()", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_CvvValidationStateHandler: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var alreadyNotifiedMerchantOfCvvValidationState: Cuckoo.VerifyReadOnlyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "alreadyNotifiedMerchantOfCvvValidationState", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func handleCvvValidation<M1: Cuckoo.Matchable>(isValid: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: isValid) { $0 }]
	        return cuckoo_manager.verify("handleCvvValidation(isValid: Bool)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func notifyMerchantOfCvvValidationState() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("notifyMerchantOfCvvValidationState()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class CvvValidationStateHandlerStub: CvvValidationStateHandler {
    
    
     var alreadyNotifiedMerchantOfCvvValidationState: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    

    

    
     func handleCvvValidation(isValid: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func notifyMerchantOfCvvValidationState()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}

