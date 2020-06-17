import Cuckoo
@testable import AccessCheckoutSDK

import Foundation


 class MockPanValidationFlow: PanValidationFlow, Cuckoo.ClassMock {
    
     typealias MocksType = PanValidationFlow
    
     typealias Stubbing = __StubbingProxy_PanValidationFlow
     typealias Verification = __VerificationProxy_PanValidationFlow

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: PanValidationFlow?

     func enableDefaultImplementation(_ stub: PanValidationFlow) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     override func validate(pan: PAN)  {
        
    return cuckoo_manager.call("validate(pan: PAN)",
            parameters: (pan),
            escapingParameters: (pan),
            superclassCall:
                
                super.validate(pan: pan)
                ,
            defaultCall: __defaultImplStub!.validate(pan: pan))
        
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
    

	 struct __StubbingProxy_PanValidationFlow: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func validate<M1: Cuckoo.Matchable>(pan: M1) -> Cuckoo.ClassStubNoReturnFunction<(PAN)> where M1.MatchedType == PAN {
	        let matchers: [Cuckoo.ParameterMatcher<(PAN)>] = [wrap(matchable: pan) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockPanValidationFlow.self, method: "validate(pan: PAN)", parameterMatchers: matchers))
	    }
	    
	    func notifyMerchantIfNotAlreadyNotified() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockPanValidationFlow.self, method: "notifyMerchantIfNotAlreadyNotified()", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_PanValidationFlow: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func validate<M1: Cuckoo.Matchable>(pan: M1) -> Cuckoo.__DoNotUse<(PAN), Void> where M1.MatchedType == PAN {
	        let matchers: [Cuckoo.ParameterMatcher<(PAN)>] = [wrap(matchable: pan) { $0 }]
	        return cuckoo_manager.verify("validate(pan: PAN)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func notifyMerchantIfNotAlreadyNotified() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("notifyMerchantIfNotAlreadyNotified()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class PanValidationFlowStub: PanValidationFlow {
    

    

    
     override func validate(pan: PAN)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     override func notifyMerchantIfNotAlreadyNotified()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}

