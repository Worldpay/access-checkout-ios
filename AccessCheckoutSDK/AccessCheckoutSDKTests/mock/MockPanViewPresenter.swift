import Cuckoo
@testable import AccessCheckoutSDK


 class MockPanViewPresenter: PanViewPresenter, Cuckoo.ClassMock {
    
     typealias MocksType = PanViewPresenter
    
     typealias Stubbing = __StubbingProxy_PanViewPresenter
     typealias Verification = __VerificationProxy_PanViewPresenter

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: PanViewPresenter?

     func enableDefaultImplementation(_ stub: PanViewPresenter) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     override func onEditing(text: String?)  {
        
    return cuckoo_manager.call("onEditing(text: String?)",
            parameters: (text),
            escapingParameters: (text),
            superclassCall:
                
                super.onEditing(text: text)
                ,
            defaultCall: __defaultImplStub!.onEditing(text: text))
        
    }
    
    
    
     override func onEditEnd(text: String?)  {
        
    return cuckoo_manager.call("onEditEnd(text: String?)",
            parameters: (text),
            escapingParameters: (text),
            superclassCall:
                
                super.onEditEnd(text: text)
                ,
            defaultCall: __defaultImplStub!.onEditEnd(text: text))
        
    }
    
    
    
     override func canChangeText(with text: String) -> Bool {
        
    return cuckoo_manager.call("canChangeText(with: String) -> Bool",
            parameters: (text),
            escapingParameters: (text),
            superclassCall:
                
                super.canChangeText(with: text)
                ,
            defaultCall: __defaultImplStub!.canChangeText(with: text))
        
    }
    

	 struct __StubbingProxy_PanViewPresenter: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func onEditing<M1: Cuckoo.OptionalMatchable>(text: M1) -> Cuckoo.ClassStubNoReturnFunction<(String?)> where M1.OptionalMatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String?)>] = [wrap(matchable: text) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockPanViewPresenter.self, method: "onEditing(text: String?)", parameterMatchers: matchers))
	    }
	    
	    func onEditEnd<M1: Cuckoo.OptionalMatchable>(text: M1) -> Cuckoo.ClassStubNoReturnFunction<(String?)> where M1.OptionalMatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String?)>] = [wrap(matchable: text) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockPanViewPresenter.self, method: "onEditEnd(text: String?)", parameterMatchers: matchers))
	    }
	    
	    func canChangeText<M1: Cuckoo.Matchable>(with text: M1) -> Cuckoo.ClassStubFunction<(String), Bool> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: text) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockPanViewPresenter.self, method: "canChangeText(with: String) -> Bool", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_PanViewPresenter: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func onEditing<M1: Cuckoo.OptionalMatchable>(text: M1) -> Cuckoo.__DoNotUse<(String?), Void> where M1.OptionalMatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String?)>] = [wrap(matchable: text) { $0 }]
	        return cuckoo_manager.verify("onEditing(text: String?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func onEditEnd<M1: Cuckoo.OptionalMatchable>(text: M1) -> Cuckoo.__DoNotUse<(String?), Void> where M1.OptionalMatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String?)>] = [wrap(matchable: text) { $0 }]
	        return cuckoo_manager.verify("onEditEnd(text: String?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func canChangeText<M1: Cuckoo.Matchable>(with text: M1) -> Cuckoo.__DoNotUse<(String), Bool> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: text) { $0 }]
	        return cuckoo_manager.verify("canChangeText(with: String) -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class PanViewPresenterStub: PanViewPresenter {
    

    

    
     override func onEditing(text: String?)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     override func onEditEnd(text: String?)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     override func canChangeText(with text: String) -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
}

