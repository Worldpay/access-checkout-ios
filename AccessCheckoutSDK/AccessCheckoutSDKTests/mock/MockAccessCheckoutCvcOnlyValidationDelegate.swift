import Cuckoo
@testable import AccessCheckoutSDK


public class MockAccessCheckoutCvcOnlyValidationDelegate: AccessCheckoutCvcOnlyValidationDelegate, Cuckoo.ProtocolMock {
    
    public typealias MocksType = AccessCheckoutCvcOnlyValidationDelegate
    
    public typealias Stubbing = __StubbingProxy_AccessCheckoutCvcOnlyValidationDelegate
    public typealias Verification = __VerificationProxy_AccessCheckoutCvcOnlyValidationDelegate

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: AccessCheckoutCvcOnlyValidationDelegate?

    public func enableDefaultImplementation(_ stub: AccessCheckoutCvcOnlyValidationDelegate) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    public func cvcValidChanged(isValid: Bool)  {
        
    return cuckoo_manager.call("cvcValidChanged(isValid: Bool)",
            parameters: (isValid),
            escapingParameters: (isValid),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.cvcValidChanged(isValid: isValid))
        
    }
    
    
    
    public func validationSuccess()  {
        
    return cuckoo_manager.call("validationSuccess()",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.validationSuccess())
        
    }
    

	public struct __StubbingProxy_AccessCheckoutCvcOnlyValidationDelegate: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func cvcValidChanged<M1: Cuckoo.Matchable>(isValid: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: isValid) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockAccessCheckoutCvcOnlyValidationDelegate.self, method: "cvcValidChanged(isValid: Bool)", parameterMatchers: matchers))
	    }
	    
	    func validationSuccess() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockAccessCheckoutCvcOnlyValidationDelegate.self, method: "validationSuccess()", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_AccessCheckoutCvcOnlyValidationDelegate: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func cvcValidChanged<M1: Cuckoo.Matchable>(isValid: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: isValid) { $0 }]
	        return cuckoo_manager.verify("cvcValidChanged(isValid: Bool)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func validationSuccess() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("validationSuccess()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class AccessCheckoutCvcOnlyValidationDelegateStub: AccessCheckoutCvcOnlyValidationDelegate {
    

    

    
    public func cvcValidChanged(isValid: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func validationSuccess()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}

