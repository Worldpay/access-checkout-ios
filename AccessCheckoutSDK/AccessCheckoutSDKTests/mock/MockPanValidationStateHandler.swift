import Cuckoo
@testable import AccessCheckoutSDK


 class MockPanValidationStateHandler: PanValidationStateHandler, Cuckoo.ProtocolMock {
    
     typealias MocksType = PanValidationStateHandler
    
     typealias Stubbing = __StubbingProxy_PanValidationStateHandler
     typealias Verification = __VerificationProxy_PanValidationStateHandler

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: PanValidationStateHandler?

     func enableDefaultImplementation(_ stub: PanValidationStateHandler) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
     var alreadyNotifiedMerchantOfPanValidationState: Bool {
        get {
            return cuckoo_manager.getter("alreadyNotifiedMerchantOfPanValidationState",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.alreadyNotifiedMerchantOfPanValidationState)
        }
        
    }
    

    

    
    
    
     func handlePanValidation(isValid: Bool, cardBrand: CardBrandModel?)  {
        
    return cuckoo_manager.call("handlePanValidation(isValid: Bool, cardBrand: CardBrandModel?)",
            parameters: (isValid, cardBrand),
            escapingParameters: (isValid, cardBrand),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.handlePanValidation(isValid: isValid, cardBrand: cardBrand))
        
    }
    
    
    
     func isCardBrandDifferentFrom(cardBrand: CardBrandModel?) -> Bool {
        
    return cuckoo_manager.call("isCardBrandDifferentFrom(cardBrand: CardBrandModel?) -> Bool",
            parameters: (cardBrand),
            escapingParameters: (cardBrand),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isCardBrandDifferentFrom(cardBrand: cardBrand))
        
    }
    
    
    
     func notifyMerchantOfPanValidationState()  {
        
    return cuckoo_manager.call("notifyMerchantOfPanValidationState()",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.notifyMerchantOfPanValidationState())
        
    }
    
    
    
     func getCardBrand() -> CardBrandModel? {
        
    return cuckoo_manager.call("getCardBrand() -> CardBrandModel?",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getCardBrand())
        
    }
    

	 struct __StubbingProxy_PanValidationStateHandler: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var alreadyNotifiedMerchantOfPanValidationState: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockPanValidationStateHandler, Bool> {
	        return .init(manager: cuckoo_manager, name: "alreadyNotifiedMerchantOfPanValidationState")
	    }
	    
	    
	    func handlePanValidation<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(isValid: M1, cardBrand: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool, CardBrandModel?)> where M1.MatchedType == Bool, M2.OptionalMatchedType == CardBrandModel {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool, CardBrandModel?)>] = [wrap(matchable: isValid) { $0.0 }, wrap(matchable: cardBrand) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockPanValidationStateHandler.self, method: "handlePanValidation(isValid: Bool, cardBrand: CardBrandModel?)", parameterMatchers: matchers))
	    }
	    
	    func isCardBrandDifferentFrom<M1: Cuckoo.OptionalMatchable>(cardBrand: M1) -> Cuckoo.ProtocolStubFunction<(CardBrandModel?), Bool> where M1.OptionalMatchedType == CardBrandModel {
	        let matchers: [Cuckoo.ParameterMatcher<(CardBrandModel?)>] = [wrap(matchable: cardBrand) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockPanValidationStateHandler.self, method: "isCardBrandDifferentFrom(cardBrand: CardBrandModel?) -> Bool", parameterMatchers: matchers))
	    }
	    
	    func notifyMerchantOfPanValidationState() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockPanValidationStateHandler.self, method: "notifyMerchantOfPanValidationState()", parameterMatchers: matchers))
	    }
	    
	    func getCardBrand() -> Cuckoo.ProtocolStubFunction<(), CardBrandModel?> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockPanValidationStateHandler.self, method: "getCardBrand() -> CardBrandModel?", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_PanValidationStateHandler: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var alreadyNotifiedMerchantOfPanValidationState: Cuckoo.VerifyReadOnlyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "alreadyNotifiedMerchantOfPanValidationState", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func handlePanValidation<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(isValid: M1, cardBrand: M2) -> Cuckoo.__DoNotUse<(Bool, CardBrandModel?), Void> where M1.MatchedType == Bool, M2.OptionalMatchedType == CardBrandModel {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool, CardBrandModel?)>] = [wrap(matchable: isValid) { $0.0 }, wrap(matchable: cardBrand) { $0.1 }]
	        return cuckoo_manager.verify("handlePanValidation(isValid: Bool, cardBrand: CardBrandModel?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func isCardBrandDifferentFrom<M1: Cuckoo.OptionalMatchable>(cardBrand: M1) -> Cuckoo.__DoNotUse<(CardBrandModel?), Bool> where M1.OptionalMatchedType == CardBrandModel {
	        let matchers: [Cuckoo.ParameterMatcher<(CardBrandModel?)>] = [wrap(matchable: cardBrand) { $0 }]
	        return cuckoo_manager.verify("isCardBrandDifferentFrom(cardBrand: CardBrandModel?) -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func notifyMerchantOfPanValidationState() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("notifyMerchantOfPanValidationState()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func getCardBrand() -> Cuckoo.__DoNotUse<(), CardBrandModel?> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("getCardBrand() -> CardBrandModel?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class PanValidationStateHandlerStub: PanValidationStateHandler {
    
    
     var alreadyNotifiedMerchantOfPanValidationState: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    

    

    
     func handlePanValidation(isValid: Bool, cardBrand: CardBrandModel?)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func isCardBrandDifferentFrom(cardBrand: CardBrandModel?) -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
     func notifyMerchantOfPanValidationState()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func getCardBrand() -> CardBrandModel?  {
        return DefaultValueRegistry.defaultValue(for: (CardBrandModel?).self)
    }
    
}

