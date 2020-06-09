import Cuckoo
@testable import AccessCheckoutSDK


public class MockAccessCheckoutCvvOnlyValidationDelegate: AccessCheckoutCvvOnlyValidationDelegate, Cuckoo.ProtocolMock {
    
    public typealias MocksType = AccessCheckoutCvvOnlyValidationDelegate
    
    public typealias Stubbing = __StubbingProxy_AccessCheckoutCvvOnlyValidationDelegate
    public typealias Verification = __VerificationProxy_AccessCheckoutCvvOnlyValidationDelegate

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: AccessCheckoutCvvOnlyValidationDelegate?

    public func enableDefaultImplementation(_ stub: AccessCheckoutCvvOnlyValidationDelegate) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    public func handleCvvValidationChange(isValid: Bool)  {
        
    return cuckoo_manager.call("handleCvvValidationChange(isValid: Bool)",
            parameters: (isValid),
            escapingParameters: (isValid),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.handleCvvValidationChange(isValid: isValid))
        
    }
    

	public struct __StubbingProxy_AccessCheckoutCvvOnlyValidationDelegate: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func handleCvvValidationChange<M1: Cuckoo.Matchable>(isValid: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: isValid) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockAccessCheckoutCvvOnlyValidationDelegate.self, method: "handleCvvValidationChange(isValid: Bool)", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_AccessCheckoutCvvOnlyValidationDelegate: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func handleCvvValidationChange<M1: Cuckoo.Matchable>(isValid: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: isValid) { $0 }]
	        return cuckoo_manager.verify("handleCvvValidationChange(isValid: Bool)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class AccessCheckoutCvvOnlyValidationDelegateStub: AccessCheckoutCvvOnlyValidationDelegate {
    

    

    
    public func handleCvvValidationChange(isValid: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}

