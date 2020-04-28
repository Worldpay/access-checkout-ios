import Cuckoo
@testable import AccessCheckoutSDK

import Foundation


public class MockCardView: CardView, Cuckoo.ProtocolMock {
    
    public typealias MocksType = CardView
    
    public typealias Stubbing = __StubbingProxy_CardView
    public typealias Verification = __VerificationProxy_CardView

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: CardView?

    public func enableDefaultImplementation(_ stub: CardView) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    public var isEnabled: Bool {
        get {
            return cuckoo_manager.getter("isEnabled",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.isEnabled)
        }
        
        set {
            cuckoo_manager.setter("isEnabled",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.isEnabled = newValue)
        }
        
    }
    
    
    
    public var cardViewDelegate: CardViewDelegate? {
        get {
            return cuckoo_manager.getter("cardViewDelegate",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.cardViewDelegate)
        }
        
        set {
            cuckoo_manager.setter("cardViewDelegate",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.cardViewDelegate = newValue)
        }
        
    }
    

    

    
    
    
    public func isValid(valid: Bool)  {
        
    return cuckoo_manager.call("isValid(valid: Bool)",
            parameters: (valid),
            escapingParameters: (valid),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isValid(valid: valid))
        
    }
    
    
    
    public func clear()  {
        
    return cuckoo_manager.call("clear()",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.clear())
        
    }
    

	public struct __StubbingProxy_CardView: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var isEnabled: Cuckoo.ProtocolToBeStubbedProperty<MockCardView, Bool> {
	        return .init(manager: cuckoo_manager, name: "isEnabled")
	    }
	    
	    
	    var cardViewDelegate: Cuckoo.ProtocolToBeStubbedOptionalProperty<MockCardView, CardViewDelegate> {
	        return .init(manager: cuckoo_manager, name: "cardViewDelegate")
	    }
	    
	    
	    func isValid<M1: Cuckoo.Matchable>(valid: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: valid) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCardView.self, method: "isValid(valid: Bool)", parameterMatchers: matchers))
	    }
	    
	    func clear() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockCardView.self, method: "clear()", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_CardView: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var isEnabled: Cuckoo.VerifyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "isEnabled", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var cardViewDelegate: Cuckoo.VerifyOptionalProperty<CardViewDelegate> {
	        return .init(manager: cuckoo_manager, name: "cardViewDelegate", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func isValid<M1: Cuckoo.Matchable>(valid: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: valid) { $0 }]
	        return cuckoo_manager.verify("isValid(valid: Bool)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func clear() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("clear()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class CardViewStub: CardView {
    
    
    public var isEnabled: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
        set { }
        
    }
    
    
    public var cardViewDelegate: CardViewDelegate? {
        get {
            return DefaultValueRegistry.defaultValue(for: (CardViewDelegate?).self)
        }
        
        set { }
        
    }
    

    

    
    public func isValid(valid: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func clear()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}

