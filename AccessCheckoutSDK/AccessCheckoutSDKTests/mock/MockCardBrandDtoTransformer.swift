import Cuckoo
@testable import AccessCheckoutSDK


 class MockCardBrandDtoTransformer: CardBrandDtoTransformer, Cuckoo.ClassMock {
    
     typealias MocksType = CardBrandDtoTransformer
    
     typealias Stubbing = __StubbingProxy_CardBrandDtoTransformer
     typealias Verification = __VerificationProxy_CardBrandDtoTransformer

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: CardBrandDtoTransformer?

     func enableDefaultImplementation(_ stub: CardBrandDtoTransformer) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     override func transform(_ dto: CardBrandDto) -> CardBrandModel {
        
    return cuckoo_manager.call("transform(_: CardBrandDto) -> CardBrandModel",
            parameters: (dto),
            escapingParameters: (dto),
            superclassCall:
                
                super.transform(dto)
                ,
            defaultCall: __defaultImplStub!.transform(dto))
        
    }
    

	 struct __StubbingProxy_CardBrandDtoTransformer: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func transform<M1: Cuckoo.Matchable>(_ dto: M1) -> Cuckoo.ClassStubFunction<(CardBrandDto), CardBrandModel> where M1.MatchedType == CardBrandDto {
	        let matchers: [Cuckoo.ParameterMatcher<(CardBrandDto)>] = [wrap(matchable: dto) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCardBrandDtoTransformer.self, method: "transform(_: CardBrandDto) -> CardBrandModel", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_CardBrandDtoTransformer: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func transform<M1: Cuckoo.Matchable>(_ dto: M1) -> Cuckoo.__DoNotUse<(CardBrandDto), CardBrandModel> where M1.MatchedType == CardBrandDto {
	        let matchers: [Cuckoo.ParameterMatcher<(CardBrandDto)>] = [wrap(matchable: dto) { $0 }]
	        return cuckoo_manager.verify("transform(_: CardBrandDto) -> CardBrandModel", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class CardBrandDtoTransformerStub: CardBrandDtoTransformer {
    

    

    
     override func transform(_ dto: CardBrandDto) -> CardBrandModel  {
        return DefaultValueRegistry.defaultValue(for: (CardBrandModel).self)
    }
    
}

