import Cuckoo
@testable import AccessCheckoutSDK

import Foundation


 class MockCvvWithPanValidationFlow: CvvWithPanValidationFlow, Cuckoo.ClassMock {
    
     typealias MocksType = CvvWithPanValidationFlow
    
     typealias Stubbing = __StubbingProxy_CvvWithPanValidationFlow
     typealias Verification = __VerificationProxy_CvvWithPanValidationFlow

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: CvvWithPanValidationFlow?

     func enableDefaultImplementation(_ stub: CvvWithPanValidationFlow) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     override func validate(cardBrand: AccessCardConfiguration.CardBrand?)  {
        
    return cuckoo_manager.call("validate(cardBrand: AccessCardConfiguration.CardBrand?)",
            parameters: (cardBrand),
            escapingParameters: (cardBrand),
            superclassCall:
                
                super.validate(cardBrand: cardBrand)
                ,
            defaultCall: __defaultImplStub!.validate(cardBrand: cardBrand))
        
    }
    

	 struct __StubbingProxy_CvvWithPanValidationFlow: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func validate<M1: Cuckoo.OptionalMatchable>(cardBrand: M1) -> Cuckoo.ClassStubNoReturnFunction<(AccessCardConfiguration.CardBrand?)> where M1.OptionalMatchedType == AccessCardConfiguration.CardBrand {
	        let matchers: [Cuckoo.ParameterMatcher<(AccessCardConfiguration.CardBrand?)>] = [wrap(matchable: cardBrand) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCvvWithPanValidationFlow.self, method: "validate(cardBrand: AccessCardConfiguration.CardBrand?)", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_CvvWithPanValidationFlow: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func validate<M1: Cuckoo.OptionalMatchable>(cardBrand: M1) -> Cuckoo.__DoNotUse<(AccessCardConfiguration.CardBrand?), Void> where M1.OptionalMatchedType == AccessCardConfiguration.CardBrand {
	        let matchers: [Cuckoo.ParameterMatcher<(AccessCardConfiguration.CardBrand?)>] = [wrap(matchable: cardBrand) { $0 }]
	        return cuckoo_manager.verify("validate(cardBrand: AccessCardConfiguration.CardBrand?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class CvvWithPanValidationFlowStub: CvvWithPanValidationFlow {
    

    

    
     override func validate(cardBrand: AccessCardConfiguration.CardBrand?)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}

