import Cuckoo
@testable import AccessCheckoutSDK


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
    

    

    

    
    
    
     override func retrieveRemoteConfiguration(baseUrl: String)  {
        
    return cuckoo_manager.call("retrieveRemoteConfiguration(baseUrl: String)",
            parameters: (baseUrl),
            escapingParameters: (baseUrl),
            superclassCall:
                
                super.retrieveRemoteConfiguration(baseUrl: baseUrl)
                ,
            defaultCall: __defaultImplStub!.retrieveRemoteConfiguration(baseUrl: baseUrl))
        
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
	    
	    
	    func retrieveRemoteConfiguration<M1: Cuckoo.Matchable>(baseUrl: M1) -> Cuckoo.ClassStubNoReturnFunction<(String)> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: baseUrl) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCardBrandsConfigurationProvider.self, method: "retrieveRemoteConfiguration(baseUrl: String)", parameterMatchers: matchers))
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
	    func retrieveRemoteConfiguration<M1: Cuckoo.Matchable>(baseUrl: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: baseUrl) { $0 }]
	        return cuckoo_manager.verify("retrieveRemoteConfiguration(baseUrl: String)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func get() -> Cuckoo.__DoNotUse<(), CardBrandsConfiguration> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("get() -> CardBrandsConfiguration", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class CardBrandsConfigurationProviderStub: CardBrandsConfigurationProvider {
    

    

    
     override func retrieveRemoteConfiguration(baseUrl: String)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     override func get() -> CardBrandsConfiguration  {
        return DefaultValueRegistry.defaultValue(for: (CardBrandsConfiguration).self)
    }
    
}

