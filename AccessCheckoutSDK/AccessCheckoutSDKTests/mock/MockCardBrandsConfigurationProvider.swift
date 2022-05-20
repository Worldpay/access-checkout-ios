import Cuckoo
@testable import AccessCheckoutSDK

import Dispatch


 class MockCardBrandsConfigurationProvider: CardBrandsConfigurationProvider, Cuckoo.ClassMock {
    
     typealias MocksType = CardBrandsConfigurationProvider
    
     typealias Stubbing = __StubbingProxy_CardBrandsConfigurationProvider
     typealias Verification = __VerificationProxy_CardBrandsConfigurationProvider

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: CardBrandsConfigurationProvider?

     func enableDefaultImplementation(_ stub: CardBrandsConfigurationProvider) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     override func retrieveRemoteConfiguration(baseUrl: String, acceptedCardBrands: [String])  {
        
    return cuckoo_manager.call("retrieveRemoteConfiguration(baseUrl: String, acceptedCardBrands: [String])",
            parameters: (baseUrl, acceptedCardBrands),
            escapingParameters: (baseUrl, acceptedCardBrands),
            superclassCall:
                
                super.retrieveRemoteConfiguration(baseUrl: baseUrl, acceptedCardBrands: acceptedCardBrands)
                ,
            defaultCall: __defaultImplStub!.retrieveRemoteConfiguration(baseUrl: baseUrl, acceptedCardBrands: acceptedCardBrands))
        
    }
    
    
    
     override func get() -> CardBrandsConfiguration {
        
    return cuckoo_manager.call("get() -> CardBrandsConfiguration",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.get()
                ,
            defaultCall: __defaultImplStub!.get())
        
    }
    

	 struct __StubbingProxy_CardBrandsConfigurationProvider: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func retrieveRemoteConfiguration<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(baseUrl: M1, acceptedCardBrands: M2) -> Cuckoo.ClassStubNoReturnFunction<(String, [String])> where M1.MatchedType == String, M2.MatchedType == [String] {
	        let matchers: [Cuckoo.ParameterMatcher<(String, [String])>] = [wrap(matchable: baseUrl) { $0.0 }, wrap(matchable: acceptedCardBrands) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCardBrandsConfigurationProvider.self, method: "retrieveRemoteConfiguration(baseUrl: String, acceptedCardBrands: [String])", parameterMatchers: matchers))
	    }
	    
	    func get() -> Cuckoo.ClassStubFunction<(), CardBrandsConfiguration> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockCardBrandsConfigurationProvider.self, method: "get() -> CardBrandsConfiguration", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_CardBrandsConfigurationProvider: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func retrieveRemoteConfiguration<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(baseUrl: M1, acceptedCardBrands: M2) -> Cuckoo.__DoNotUse<(String, [String]), Void> where M1.MatchedType == String, M2.MatchedType == [String] {
	        let matchers: [Cuckoo.ParameterMatcher<(String, [String])>] = [wrap(matchable: baseUrl) { $0.0 }, wrap(matchable: acceptedCardBrands) { $0.1 }]
	        return cuckoo_manager.verify("retrieveRemoteConfiguration(baseUrl: String, acceptedCardBrands: [String])", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func get() -> Cuckoo.__DoNotUse<(), CardBrandsConfiguration> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("get() -> CardBrandsConfiguration", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class CardBrandsConfigurationProviderStub: CardBrandsConfigurationProvider {
    

    

    
     override func retrieveRemoteConfiguration(baseUrl: String, acceptedCardBrands: [String])   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     override func get() -> CardBrandsConfiguration  {
        return DefaultValueRegistry.defaultValue(for: (CardBrandsConfiguration).self)
    }
    
}

