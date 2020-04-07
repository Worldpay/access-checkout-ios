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



public class MockCardTextView: CardTextView, Cuckoo.ProtocolMock {
    
    public typealias MocksType = CardTextView
    
    public typealias Stubbing = __StubbingProxy_CardTextView
    public typealias Verification = __VerificationProxy_CardTextView

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: CardTextView?

    public func enableDefaultImplementation(_ stub: CardTextView) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    public var text: String? {
        get {
            return cuckoo_manager.getter("text",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.text)
        }
        
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
    

	public struct __StubbingProxy_CardTextView: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var text: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockCardTextView, String?> {
	        return .init(manager: cuckoo_manager, name: "text")
	    }
	    
	    
	    var isEnabled: Cuckoo.ProtocolToBeStubbedProperty<MockCardTextView, Bool> {
	        return .init(manager: cuckoo_manager, name: "isEnabled")
	    }
	    
	    
	    var cardViewDelegate: Cuckoo.ProtocolToBeStubbedOptionalProperty<MockCardTextView, CardViewDelegate> {
	        return .init(manager: cuckoo_manager, name: "cardViewDelegate")
	    }
	    
	    
	    func isValid<M1: Cuckoo.Matchable>(valid: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: valid) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCardTextView.self, method: "isValid(valid: Bool)", parameterMatchers: matchers))
	    }
	    
	    func clear() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockCardTextView.self, method: "clear()", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_CardTextView: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var text: Cuckoo.VerifyReadOnlyProperty<String?> {
	        return .init(manager: cuckoo_manager, name: "text", callMatcher: callMatcher, sourceLocation: sourceLocation)
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

public class CardTextViewStub: CardTextView {
    
    
    public var text: String? {
        get {
            return DefaultValueRegistry.defaultValue(for: (String?).self)
        }
        
    }
    
    
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



public class MockCardDateView: CardDateView, Cuckoo.ProtocolMock {
    
    public typealias MocksType = CardDateView
    
    public typealias Stubbing = __StubbingProxy_CardDateView
    public typealias Verification = __VerificationProxy_CardDateView

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: CardDateView?

    public func enableDefaultImplementation(_ stub: CardDateView) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    public var month: String? {
        get {
            return cuckoo_manager.getter("month",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.month)
        }
        
    }
    
    
    
    public var year: String? {
        get {
            return cuckoo_manager.getter("year",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.year)
        }
        
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
    

	public struct __StubbingProxy_CardDateView: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var month: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockCardDateView, String?> {
	        return .init(manager: cuckoo_manager, name: "month")
	    }
	    
	    
	    var year: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockCardDateView, String?> {
	        return .init(manager: cuckoo_manager, name: "year")
	    }
	    
	    
	    var isEnabled: Cuckoo.ProtocolToBeStubbedProperty<MockCardDateView, Bool> {
	        return .init(manager: cuckoo_manager, name: "isEnabled")
	    }
	    
	    
	    var cardViewDelegate: Cuckoo.ProtocolToBeStubbedOptionalProperty<MockCardDateView, CardViewDelegate> {
	        return .init(manager: cuckoo_manager, name: "cardViewDelegate")
	    }
	    
	    
	    func isValid<M1: Cuckoo.Matchable>(valid: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: valid) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCardDateView.self, method: "isValid(valid: Bool)", parameterMatchers: matchers))
	    }
	    
	    func clear() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockCardDateView.self, method: "clear()", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_CardDateView: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var month: Cuckoo.VerifyReadOnlyProperty<String?> {
	        return .init(manager: cuckoo_manager, name: "month", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var year: Cuckoo.VerifyReadOnlyProperty<String?> {
	        return .init(manager: cuckoo_manager, name: "year", callMatcher: callMatcher, sourceLocation: sourceLocation)
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

public class CardDateViewStub: CardDateView {
    
    
    public var month: String? {
        get {
            return DefaultValueRegistry.defaultValue(for: (String?).self)
        }
        
    }
    
    
    public var year: String? {
        get {
            return DefaultValueRegistry.defaultValue(for: (String?).self)
        }
        
    }
    
    
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



public class MockCardViewDelegate: CardViewDelegate, Cuckoo.ProtocolMock {
    
    public typealias MocksType = CardViewDelegate
    
    public typealias Stubbing = __StubbingProxy_CardViewDelegate
    public typealias Verification = __VerificationProxy_CardViewDelegate

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: CardViewDelegate?

    public func enableDefaultImplementation(_ stub: CardViewDelegate) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    public func didUpdate(pan: PAN)  {
        
    return cuckoo_manager.call("didUpdate(pan: PAN)",
            parameters: (pan),
            escapingParameters: (pan),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.didUpdate(pan: pan))
        
    }
    
    
    
    public func didEndUpdate(pan: PAN)  {
        
    return cuckoo_manager.call("didEndUpdate(pan: PAN)",
            parameters: (pan),
            escapingParameters: (pan),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.didEndUpdate(pan: pan))
        
    }
    
    
    
    public func canUpdate(pan: PAN?, withText text: String, inRange range: NSRange) -> Bool {
        
    return cuckoo_manager.call("canUpdate(pan: PAN?, withText: String, inRange: NSRange) -> Bool",
            parameters: (pan, text, range),
            escapingParameters: (pan, text, range),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.canUpdate(pan: pan, withText: text, inRange: range))
        
    }
    
    
    
    public func didUpdate(cvv: CVV)  {
        
    return cuckoo_manager.call("didUpdate(cvv: CVV)",
            parameters: (cvv),
            escapingParameters: (cvv),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.didUpdate(cvv: cvv))
        
    }
    
    
    
    public func didEndUpdate(cvv: CVV)  {
        
    return cuckoo_manager.call("didEndUpdate(cvv: CVV)",
            parameters: (cvv),
            escapingParameters: (cvv),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.didEndUpdate(cvv: cvv))
        
    }
    
    
    
    public func canUpdate(cvv: CVV?, withText text: String, inRange range: NSRange) -> Bool {
        
    return cuckoo_manager.call("canUpdate(cvv: CVV?, withText: String, inRange: NSRange) -> Bool",
            parameters: (cvv, text, range),
            escapingParameters: (cvv, text, range),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.canUpdate(cvv: cvv, withText: text, inRange: range))
        
    }
    
    
    
    public func didUpdate(expiryMonth: ExpiryMonth?, expiryYear: ExpiryYear?)  {
        
    return cuckoo_manager.call("didUpdate(expiryMonth: ExpiryMonth?, expiryYear: ExpiryYear?)",
            parameters: (expiryMonth, expiryYear),
            escapingParameters: (expiryMonth, expiryYear),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.didUpdate(expiryMonth: expiryMonth, expiryYear: expiryYear))
        
    }
    
    
    
    public func didEndUpdate(expiryMonth: ExpiryMonth?, expiryYear: ExpiryYear?)  {
        
    return cuckoo_manager.call("didEndUpdate(expiryMonth: ExpiryMonth?, expiryYear: ExpiryYear?)",
            parameters: (expiryMonth, expiryYear),
            escapingParameters: (expiryMonth, expiryYear),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.didEndUpdate(expiryMonth: expiryMonth, expiryYear: expiryYear))
        
    }
    
    
    
    public func canUpdate(expiryMonth: ExpiryMonth?, withText text: String, inRange range: NSRange) -> Bool {
        
    return cuckoo_manager.call("canUpdate(expiryMonth: ExpiryMonth?, withText: String, inRange: NSRange) -> Bool",
            parameters: (expiryMonth, text, range),
            escapingParameters: (expiryMonth, text, range),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.canUpdate(expiryMonth: expiryMonth, withText: text, inRange: range))
        
    }
    
    
    
    public func canUpdate(expiryYear: ExpiryYear?, withText text: String, inRange range: NSRange) -> Bool {
        
    return cuckoo_manager.call("canUpdate(expiryYear: ExpiryYear?, withText: String, inRange: NSRange) -> Bool",
            parameters: (expiryYear, text, range),
            escapingParameters: (expiryYear, text, range),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.canUpdate(expiryYear: expiryYear, withText: text, inRange: range))
        
    }
    

	public struct __StubbingProxy_CardViewDelegate: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func didUpdate<M1: Cuckoo.Matchable>(pan: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(PAN)> where M1.MatchedType == PAN {
	        let matchers: [Cuckoo.ParameterMatcher<(PAN)>] = [wrap(matchable: pan) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCardViewDelegate.self, method: "didUpdate(pan: PAN)", parameterMatchers: matchers))
	    }
	    
	    func didEndUpdate<M1: Cuckoo.Matchable>(pan: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(PAN)> where M1.MatchedType == PAN {
	        let matchers: [Cuckoo.ParameterMatcher<(PAN)>] = [wrap(matchable: pan) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCardViewDelegate.self, method: "didEndUpdate(pan: PAN)", parameterMatchers: matchers))
	    }
	    
	    func canUpdate<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(pan: M1, withText text: M2, inRange range: M3) -> Cuckoo.ProtocolStubFunction<(PAN?, String, NSRange), Bool> where M1.OptionalMatchedType == PAN, M2.MatchedType == String, M3.MatchedType == NSRange {
	        let matchers: [Cuckoo.ParameterMatcher<(PAN?, String, NSRange)>] = [wrap(matchable: pan) { $0.0 }, wrap(matchable: text) { $0.1 }, wrap(matchable: range) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCardViewDelegate.self, method: "canUpdate(pan: PAN?, withText: String, inRange: NSRange) -> Bool", parameterMatchers: matchers))
	    }
	    
	    func didUpdate<M1: Cuckoo.Matchable>(cvv: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(CVV)> where M1.MatchedType == CVV {
	        let matchers: [Cuckoo.ParameterMatcher<(CVV)>] = [wrap(matchable: cvv) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCardViewDelegate.self, method: "didUpdate(cvv: CVV)", parameterMatchers: matchers))
	    }
	    
	    func didEndUpdate<M1: Cuckoo.Matchable>(cvv: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(CVV)> where M1.MatchedType == CVV {
	        let matchers: [Cuckoo.ParameterMatcher<(CVV)>] = [wrap(matchable: cvv) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCardViewDelegate.self, method: "didEndUpdate(cvv: CVV)", parameterMatchers: matchers))
	    }
	    
	    func canUpdate<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(cvv: M1, withText text: M2, inRange range: M3) -> Cuckoo.ProtocolStubFunction<(CVV?, String, NSRange), Bool> where M1.OptionalMatchedType == CVV, M2.MatchedType == String, M3.MatchedType == NSRange {
	        let matchers: [Cuckoo.ParameterMatcher<(CVV?, String, NSRange)>] = [wrap(matchable: cvv) { $0.0 }, wrap(matchable: text) { $0.1 }, wrap(matchable: range) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCardViewDelegate.self, method: "canUpdate(cvv: CVV?, withText: String, inRange: NSRange) -> Bool", parameterMatchers: matchers))
	    }
	    
	    func didUpdate<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable>(expiryMonth: M1, expiryYear: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(ExpiryMonth?, ExpiryYear?)> where M1.OptionalMatchedType == ExpiryMonth, M2.OptionalMatchedType == ExpiryYear {
	        let matchers: [Cuckoo.ParameterMatcher<(ExpiryMonth?, ExpiryYear?)>] = [wrap(matchable: expiryMonth) { $0.0 }, wrap(matchable: expiryYear) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCardViewDelegate.self, method: "didUpdate(expiryMonth: ExpiryMonth?, expiryYear: ExpiryYear?)", parameterMatchers: matchers))
	    }
	    
	    func didEndUpdate<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable>(expiryMonth: M1, expiryYear: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(ExpiryMonth?, ExpiryYear?)> where M1.OptionalMatchedType == ExpiryMonth, M2.OptionalMatchedType == ExpiryYear {
	        let matchers: [Cuckoo.ParameterMatcher<(ExpiryMonth?, ExpiryYear?)>] = [wrap(matchable: expiryMonth) { $0.0 }, wrap(matchable: expiryYear) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCardViewDelegate.self, method: "didEndUpdate(expiryMonth: ExpiryMonth?, expiryYear: ExpiryYear?)", parameterMatchers: matchers))
	    }
	    
	    func canUpdate<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(expiryMonth: M1, withText text: M2, inRange range: M3) -> Cuckoo.ProtocolStubFunction<(ExpiryMonth?, String, NSRange), Bool> where M1.OptionalMatchedType == ExpiryMonth, M2.MatchedType == String, M3.MatchedType == NSRange {
	        let matchers: [Cuckoo.ParameterMatcher<(ExpiryMonth?, String, NSRange)>] = [wrap(matchable: expiryMonth) { $0.0 }, wrap(matchable: text) { $0.1 }, wrap(matchable: range) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCardViewDelegate.self, method: "canUpdate(expiryMonth: ExpiryMonth?, withText: String, inRange: NSRange) -> Bool", parameterMatchers: matchers))
	    }
	    
	    func canUpdate<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(expiryYear: M1, withText text: M2, inRange range: M3) -> Cuckoo.ProtocolStubFunction<(ExpiryYear?, String, NSRange), Bool> where M1.OptionalMatchedType == ExpiryYear, M2.MatchedType == String, M3.MatchedType == NSRange {
	        let matchers: [Cuckoo.ParameterMatcher<(ExpiryYear?, String, NSRange)>] = [wrap(matchable: expiryYear) { $0.0 }, wrap(matchable: text) { $0.1 }, wrap(matchable: range) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCardViewDelegate.self, method: "canUpdate(expiryYear: ExpiryYear?, withText: String, inRange: NSRange) -> Bool", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_CardViewDelegate: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func didUpdate<M1: Cuckoo.Matchable>(pan: M1) -> Cuckoo.__DoNotUse<(PAN), Void> where M1.MatchedType == PAN {
	        let matchers: [Cuckoo.ParameterMatcher<(PAN)>] = [wrap(matchable: pan) { $0 }]
	        return cuckoo_manager.verify("didUpdate(pan: PAN)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func didEndUpdate<M1: Cuckoo.Matchable>(pan: M1) -> Cuckoo.__DoNotUse<(PAN), Void> where M1.MatchedType == PAN {
	        let matchers: [Cuckoo.ParameterMatcher<(PAN)>] = [wrap(matchable: pan) { $0 }]
	        return cuckoo_manager.verify("didEndUpdate(pan: PAN)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func canUpdate<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(pan: M1, withText text: M2, inRange range: M3) -> Cuckoo.__DoNotUse<(PAN?, String, NSRange), Bool> where M1.OptionalMatchedType == PAN, M2.MatchedType == String, M3.MatchedType == NSRange {
	        let matchers: [Cuckoo.ParameterMatcher<(PAN?, String, NSRange)>] = [wrap(matchable: pan) { $0.0 }, wrap(matchable: text) { $0.1 }, wrap(matchable: range) { $0.2 }]
	        return cuckoo_manager.verify("canUpdate(pan: PAN?, withText: String, inRange: NSRange) -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func didUpdate<M1: Cuckoo.Matchable>(cvv: M1) -> Cuckoo.__DoNotUse<(CVV), Void> where M1.MatchedType == CVV {
	        let matchers: [Cuckoo.ParameterMatcher<(CVV)>] = [wrap(matchable: cvv) { $0 }]
	        return cuckoo_manager.verify("didUpdate(cvv: CVV)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func didEndUpdate<M1: Cuckoo.Matchable>(cvv: M1) -> Cuckoo.__DoNotUse<(CVV), Void> where M1.MatchedType == CVV {
	        let matchers: [Cuckoo.ParameterMatcher<(CVV)>] = [wrap(matchable: cvv) { $0 }]
	        return cuckoo_manager.verify("didEndUpdate(cvv: CVV)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func canUpdate<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(cvv: M1, withText text: M2, inRange range: M3) -> Cuckoo.__DoNotUse<(CVV?, String, NSRange), Bool> where M1.OptionalMatchedType == CVV, M2.MatchedType == String, M3.MatchedType == NSRange {
	        let matchers: [Cuckoo.ParameterMatcher<(CVV?, String, NSRange)>] = [wrap(matchable: cvv) { $0.0 }, wrap(matchable: text) { $0.1 }, wrap(matchable: range) { $0.2 }]
	        return cuckoo_manager.verify("canUpdate(cvv: CVV?, withText: String, inRange: NSRange) -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func didUpdate<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable>(expiryMonth: M1, expiryYear: M2) -> Cuckoo.__DoNotUse<(ExpiryMonth?, ExpiryYear?), Void> where M1.OptionalMatchedType == ExpiryMonth, M2.OptionalMatchedType == ExpiryYear {
	        let matchers: [Cuckoo.ParameterMatcher<(ExpiryMonth?, ExpiryYear?)>] = [wrap(matchable: expiryMonth) { $0.0 }, wrap(matchable: expiryYear) { $0.1 }]
	        return cuckoo_manager.verify("didUpdate(expiryMonth: ExpiryMonth?, expiryYear: ExpiryYear?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func didEndUpdate<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable>(expiryMonth: M1, expiryYear: M2) -> Cuckoo.__DoNotUse<(ExpiryMonth?, ExpiryYear?), Void> where M1.OptionalMatchedType == ExpiryMonth, M2.OptionalMatchedType == ExpiryYear {
	        let matchers: [Cuckoo.ParameterMatcher<(ExpiryMonth?, ExpiryYear?)>] = [wrap(matchable: expiryMonth) { $0.0 }, wrap(matchable: expiryYear) { $0.1 }]
	        return cuckoo_manager.verify("didEndUpdate(expiryMonth: ExpiryMonth?, expiryYear: ExpiryYear?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func canUpdate<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(expiryMonth: M1, withText text: M2, inRange range: M3) -> Cuckoo.__DoNotUse<(ExpiryMonth?, String, NSRange), Bool> where M1.OptionalMatchedType == ExpiryMonth, M2.MatchedType == String, M3.MatchedType == NSRange {
	        let matchers: [Cuckoo.ParameterMatcher<(ExpiryMonth?, String, NSRange)>] = [wrap(matchable: expiryMonth) { $0.0 }, wrap(matchable: text) { $0.1 }, wrap(matchable: range) { $0.2 }]
	        return cuckoo_manager.verify("canUpdate(expiryMonth: ExpiryMonth?, withText: String, inRange: NSRange) -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func canUpdate<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(expiryYear: M1, withText text: M2, inRange range: M3) -> Cuckoo.__DoNotUse<(ExpiryYear?, String, NSRange), Bool> where M1.OptionalMatchedType == ExpiryYear, M2.MatchedType == String, M3.MatchedType == NSRange {
	        let matchers: [Cuckoo.ParameterMatcher<(ExpiryYear?, String, NSRange)>] = [wrap(matchable: expiryYear) { $0.0 }, wrap(matchable: text) { $0.1 }, wrap(matchable: range) { $0.2 }]
	        return cuckoo_manager.verify("canUpdate(expiryYear: ExpiryYear?, withText: String, inRange: NSRange) -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class CardViewDelegateStub: CardViewDelegate {
    

    

    
    public func didUpdate(pan: PAN)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func didEndUpdate(pan: PAN)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func canUpdate(pan: PAN?, withText text: String, inRange range: NSRange) -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func didUpdate(cvv: CVV)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func didEndUpdate(cvv: CVV)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func canUpdate(cvv: CVV?, withText text: String, inRange range: NSRange) -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func didUpdate(expiryMonth: ExpiryMonth?, expiryYear: ExpiryYear?)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func didEndUpdate(expiryMonth: ExpiryMonth?, expiryYear: ExpiryYear?)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func canUpdate(expiryMonth: ExpiryMonth?, withText text: String, inRange range: NSRange) -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func canUpdate(expiryYear: ExpiryYear?, withText text: String, inRange range: NSRange) -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
}

