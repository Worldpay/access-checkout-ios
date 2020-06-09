import Cuckoo
@testable import AccessCheckoutSDK


public class MockAccessCheckoutCardValidationDelegate: AccessCheckoutCardValidationDelegate, Cuckoo.ProtocolMock {
    
    public typealias MocksType = AccessCheckoutCardValidationDelegate
    
    public typealias Stubbing = __StubbingProxy_AccessCheckoutCardValidationDelegate
    public typealias Verification = __VerificationProxy_AccessCheckoutCardValidationDelegate

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: AccessCheckoutCardValidationDelegate?

    public func enableDefaultImplementation(_ stub: AccessCheckoutCardValidationDelegate) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    public func handleCardBrandChange(cardBrand: CardBrandClient?)  {
        
    return cuckoo_manager.call("handleCardBrandChange(cardBrand: CardBrandClient?)",
            parameters: (cardBrand),
            escapingParameters: (cardBrand),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.handleCardBrandChange(cardBrand: cardBrand))
        
    }
    
    
    
    public func handlePanValidationChange(isValid: Bool)  {
        
    return cuckoo_manager.call("handlePanValidationChange(isValid: Bool)",
            parameters: (isValid),
            escapingParameters: (isValid),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.handlePanValidationChange(isValid: isValid))
        
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
    
    
    
    public func handleExpiryDateValidationChange(isValid: Bool)  {
        
    return cuckoo_manager.call("handleExpiryDateValidationChange(isValid: Bool)",
            parameters: (isValid),
            escapingParameters: (isValid),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.handleExpiryDateValidationChange(isValid: isValid))
        
    }
    

	public struct __StubbingProxy_AccessCheckoutCardValidationDelegate: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func handleCardBrandChange<M1: Cuckoo.OptionalMatchable>(cardBrand: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(CardBrandClient?)> where M1.OptionalMatchedType == CardBrandClient {
	        let matchers: [Cuckoo.ParameterMatcher<(CardBrandClient?)>] = [wrap(matchable: cardBrand) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockAccessCheckoutCardValidationDelegate.self, method: "handleCardBrandChange(cardBrand: CardBrandClient?)", parameterMatchers: matchers))
	    }
	    
	    func handlePanValidationChange<M1: Cuckoo.Matchable>(isValid: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: isValid) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockAccessCheckoutCardValidationDelegate.self, method: "handlePanValidationChange(isValid: Bool)", parameterMatchers: matchers))
	    }
	    
	    func handleCvvValidationChange<M1: Cuckoo.Matchable>(isValid: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: isValid) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockAccessCheckoutCardValidationDelegate.self, method: "handleCvvValidationChange(isValid: Bool)", parameterMatchers: matchers))
	    }
	    
	    func handleExpiryDateValidationChange<M1: Cuckoo.Matchable>(isValid: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: isValid) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockAccessCheckoutCardValidationDelegate.self, method: "handleExpiryDateValidationChange(isValid: Bool)", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_AccessCheckoutCardValidationDelegate: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func handleCardBrandChange<M1: Cuckoo.OptionalMatchable>(cardBrand: M1) -> Cuckoo.__DoNotUse<(CardBrandClient?), Void> where M1.OptionalMatchedType == CardBrandClient {
	        let matchers: [Cuckoo.ParameterMatcher<(CardBrandClient?)>] = [wrap(matchable: cardBrand) { $0 }]
	        return cuckoo_manager.verify("handleCardBrandChange(cardBrand: CardBrandClient?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func handlePanValidationChange<M1: Cuckoo.Matchable>(isValid: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: isValid) { $0 }]
	        return cuckoo_manager.verify("handlePanValidationChange(isValid: Bool)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func handleCvvValidationChange<M1: Cuckoo.Matchable>(isValid: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: isValid) { $0 }]
	        return cuckoo_manager.verify("handleCvvValidationChange(isValid: Bool)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func handleExpiryDateValidationChange<M1: Cuckoo.Matchable>(isValid: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: isValid) { $0 }]
	        return cuckoo_manager.verify("handleExpiryDateValidationChange(isValid: Bool)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class AccessCheckoutCardValidationDelegateStub: AccessCheckoutCardValidationDelegate {
    

    

    
    public func handleCardBrandChange(cardBrand: CardBrandClient?)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func handlePanValidationChange(isValid: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func handleCvvValidationChange(isValid: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func handleExpiryDateValidationChange(isValid: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}

