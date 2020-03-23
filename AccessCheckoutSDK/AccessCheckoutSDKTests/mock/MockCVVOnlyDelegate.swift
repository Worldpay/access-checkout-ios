import Cuckoo
@testable import AccessCheckoutSDK


public class MockCVVOnlyDelegate: CVVOnlyDelegate, Cuckoo.ProtocolMock {
    
    public typealias MocksType = CVVOnlyDelegate
    
    public typealias Stubbing = __StubbingProxy_CVVOnlyDelegate
    public typealias Verification = __VerificationProxy_CVVOnlyDelegate

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: CVVOnlyDelegate?

    public func enableDefaultImplementation(_ stub: CVVOnlyDelegate) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    public func handleValidationResult(cvvView: CardView, isValid: Bool)  {
        
    return cuckoo_manager.call("handleValidationResult(cvvView: CardView, isValid: Bool)",
            parameters: (cvvView, isValid),
            escapingParameters: (cvvView, isValid),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.handleValidationResult(cvvView: cvvView, isValid: isValid))
        
    }
    

	public struct __StubbingProxy_CVVOnlyDelegate: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func handleValidationResult<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(cvvView: M1, isValid: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(CardView, Bool)> where M1.MatchedType == CardView, M2.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(CardView, Bool)>] = [wrap(matchable: cvvView) { $0.0 }, wrap(matchable: isValid) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCVVOnlyDelegate.self, method: "handleValidationResult(cvvView: CardView, isValid: Bool)", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_CVVOnlyDelegate: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func handleValidationResult<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(cvvView: M1, isValid: M2) -> Cuckoo.__DoNotUse<(CardView, Bool), Void> where M1.MatchedType == CardView, M2.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(CardView, Bool)>] = [wrap(matchable: cvvView) { $0.0 }, wrap(matchable: isValid) { $0.1 }]
	        return cuckoo_manager.verify("handleValidationResult(cvvView: CardView, isValid: Bool)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class CVVOnlyDelegateStub: CVVOnlyDelegate {
    

    

    
    public func handleValidationResult(cvvView: CardView, isValid: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}

