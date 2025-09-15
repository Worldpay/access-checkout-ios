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
    

    

    

    
    
    
    
     func handlePanValidation(isValid: Bool, cardBrands: [CardBrandModel])  {
        
    return cuckoo_manager.call(
    """
    handlePanValidation(isValid: Bool, cardBrands: [CardBrandModel])
    """,
            parameters: (isValid, cardBrands),
            escapingParameters: (isValid, cardBrands),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.handlePanValidation(isValid: isValid, cardBrands: cardBrands))
        
    }
    
    
    
    
    
     func updateCardBrandsIfChanged(cardBrands: [CardBrandModel])  {
        
    return cuckoo_manager.call(
    """
    updateCardBrandsIfChanged(cardBrands: [CardBrandModel])
    """,
            parameters: (cardBrands),
            escapingParameters: (cardBrands),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.updateCardBrandsIfChanged(cardBrands: cardBrands))
        
    }
    
    
    
    
    
     func areCardBrandsDifferentFrom(cardBrands: [CardBrandModel]) -> Bool {
        
    return cuckoo_manager.call(
    """
    areCardBrandsDifferentFrom(cardBrands: [CardBrandModel]) -> Bool
    """,
            parameters: (cardBrands),
            escapingParameters: (cardBrands),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.areCardBrandsDifferentFrom(cardBrands: cardBrands))
        
    }
    
    
    
    
    
     func notifyMerchantOfPanValidationState()  {
        
    return cuckoo_manager.call(
    """
    notifyMerchantOfPanValidationState()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.notifyMerchantOfPanValidationState())
        
    }
    
    
    
    
    
     func getCardBrands() -> [CardBrandModel] {
        
    return cuckoo_manager.call(
    """
    getCardBrands() -> [CardBrandModel]
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getCardBrands())
        
    }
    
    

     struct __StubbingProxy_PanValidationStateHandler: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func handlePanValidation<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(isValid: M1, cardBrands: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool, [CardBrandModel])> where M1.MatchedType == Bool, M2.MatchedType == [CardBrandModel] {
            let matchers: [Cuckoo.ParameterMatcher<(Bool, [CardBrandModel])>] = [wrap(matchable: isValid) { $0.0 }, wrap(matchable: cardBrands) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPanValidationStateHandler.self, method:
    """
    handlePanValidation(isValid: Bool, cardBrands: [CardBrandModel])
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func updateCardBrandsIfChanged<M1: Cuckoo.Matchable>(cardBrands: M1) -> Cuckoo.ProtocolStubNoReturnFunction<([CardBrandModel])> where M1.MatchedType == [CardBrandModel] {
            let matchers: [Cuckoo.ParameterMatcher<([CardBrandModel])>] = [wrap(matchable: cardBrands) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPanValidationStateHandler.self, method:
    """
    updateCardBrandsIfChanged(cardBrands: [CardBrandModel])
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func areCardBrandsDifferentFrom<M1: Cuckoo.Matchable>(cardBrands: M1) -> Cuckoo.ProtocolStubFunction<([CardBrandModel]), Bool> where M1.MatchedType == [CardBrandModel] {
            let matchers: [Cuckoo.ParameterMatcher<([CardBrandModel])>] = [wrap(matchable: cardBrands) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPanValidationStateHandler.self, method:
    """
    areCardBrandsDifferentFrom(cardBrands: [CardBrandModel]) -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func notifyMerchantOfPanValidationState() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPanValidationStateHandler.self, method:
    """
    notifyMerchantOfPanValidationState()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getCardBrands() -> Cuckoo.ProtocolStubFunction<(), [CardBrandModel]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPanValidationStateHandler.self, method:
    """
    getCardBrands() -> [CardBrandModel]
    """, parameterMatchers: matchers))
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
    
        
    
        
        
        
        @discardableResult
        func handlePanValidation<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(isValid: M1, cardBrands: M2) -> Cuckoo.__DoNotUse<(Bool, [CardBrandModel]), Void> where M1.MatchedType == Bool, M2.MatchedType == [CardBrandModel] {
            let matchers: [Cuckoo.ParameterMatcher<(Bool, [CardBrandModel])>] = [wrap(matchable: isValid) { $0.0 }, wrap(matchable: cardBrands) { $0.1 }]
            return cuckoo_manager.verify(
    """
    handlePanValidation(isValid: Bool, cardBrands: [CardBrandModel])
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func updateCardBrandsIfChanged<M1: Cuckoo.Matchable>(cardBrands: M1) -> Cuckoo.__DoNotUse<([CardBrandModel]), Void> where M1.MatchedType == [CardBrandModel] {
            let matchers: [Cuckoo.ParameterMatcher<([CardBrandModel])>] = [wrap(matchable: cardBrands) { $0 }]
            return cuckoo_manager.verify(
    """
    updateCardBrandsIfChanged(cardBrands: [CardBrandModel])
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func areCardBrandsDifferentFrom<M1: Cuckoo.Matchable>(cardBrands: M1) -> Cuckoo.__DoNotUse<([CardBrandModel]), Bool> where M1.MatchedType == [CardBrandModel] {
            let matchers: [Cuckoo.ParameterMatcher<([CardBrandModel])>] = [wrap(matchable: cardBrands) { $0 }]
            return cuckoo_manager.verify(
    """
    areCardBrandsDifferentFrom(cardBrands: [CardBrandModel]) -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func notifyMerchantOfPanValidationState() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    notifyMerchantOfPanValidationState()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getCardBrands() -> Cuckoo.__DoNotUse<(), [CardBrandModel]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    getCardBrands() -> [CardBrandModel]
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class PanValidationStateHandlerStub: PanValidationStateHandler {
    

    

    
    
    
    
     func handlePanValidation(isValid: Bool, cardBrands: [CardBrandModel])   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     func updateCardBrandsIfChanged(cardBrands: [CardBrandModel])   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     func areCardBrandsDifferentFrom(cardBrands: [CardBrandModel]) -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
    
    
    
     func notifyMerchantOfPanValidationState()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     func getCardBrands() -> [CardBrandModel]  {
        return DefaultValueRegistry.defaultValue(for: ([CardBrandModel]).self)
    }
    
    
}




