import Cuckoo
@testable import AccessCheckoutSDK


 class MockApiClientFactory: ApiClientFactory, Cuckoo.ClassMock {
    
     typealias MocksType = ApiClientFactory
    
     typealias Stubbing = __StubbingProxy_ApiClientFactory
     typealias Verification = __VerificationProxy_ApiClientFactory

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: ApiClientFactory?

     func enableDefaultImplementation(_ stub: ApiClientFactory) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     override func createVerifiedTokensApiClient(baseUrl: String, merchantId: String) -> VerifiedTokensApiClient {
        
    return cuckoo_manager.call("createVerifiedTokensApiClient(baseUrl: String, merchantId: String) -> VerifiedTokensApiClient",
            parameters: (baseUrl, merchantId),
            escapingParameters: (baseUrl, merchantId),
            superclassCall:
                
                super.createVerifiedTokensApiClient(baseUrl: baseUrl, merchantId: merchantId)
                ,
            defaultCall: __defaultImplStub!.createVerifiedTokensApiClient(baseUrl: baseUrl, merchantId: merchantId))
        
    }
    
    
    
     override func createSessionsApiClient(baseUrl: String, merchantId: String) -> SessionsApiClient {
        
    return cuckoo_manager.call("createSessionsApiClient(baseUrl: String, merchantId: String) -> SessionsApiClient",
            parameters: (baseUrl, merchantId),
            escapingParameters: (baseUrl, merchantId),
            superclassCall:
                
                super.createSessionsApiClient(baseUrl: baseUrl, merchantId: merchantId)
                ,
            defaultCall: __defaultImplStub!.createSessionsApiClient(baseUrl: baseUrl, merchantId: merchantId))
        
    }
    

	 struct __StubbingProxy_ApiClientFactory: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func createVerifiedTokensApiClient<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(baseUrl: M1, merchantId: M2) -> Cuckoo.ClassStubFunction<(String, String), VerifiedTokensApiClient> where M1.MatchedType == String, M2.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: baseUrl) { $0.0 }, wrap(matchable: merchantId) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockApiClientFactory.self, method: "createVerifiedTokensApiClient(baseUrl: String, merchantId: String) -> VerifiedTokensApiClient", parameterMatchers: matchers))
	    }
	    
	    func createSessionsApiClient<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(baseUrl: M1, merchantId: M2) -> Cuckoo.ClassStubFunction<(String, String), SessionsApiClient> where M1.MatchedType == String, M2.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: baseUrl) { $0.0 }, wrap(matchable: merchantId) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockApiClientFactory.self, method: "createSessionsApiClient(baseUrl: String, merchantId: String) -> SessionsApiClient", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_ApiClientFactory: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func createVerifiedTokensApiClient<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(baseUrl: M1, merchantId: M2) -> Cuckoo.__DoNotUse<(String, String), VerifiedTokensApiClient> where M1.MatchedType == String, M2.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: baseUrl) { $0.0 }, wrap(matchable: merchantId) { $0.1 }]
	        return cuckoo_manager.verify("createVerifiedTokensApiClient(baseUrl: String, merchantId: String) -> VerifiedTokensApiClient", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func createSessionsApiClient<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(baseUrl: M1, merchantId: M2) -> Cuckoo.__DoNotUse<(String, String), SessionsApiClient> where M1.MatchedType == String, M2.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: baseUrl) { $0.0 }, wrap(matchable: merchantId) { $0.1 }]
	        return cuckoo_manager.verify("createSessionsApiClient(baseUrl: String, merchantId: String) -> SessionsApiClient", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class ApiClientFactoryStub: ApiClientFactory {
    

    

    
     override func createVerifiedTokensApiClient(baseUrl: String, merchantId: String) -> VerifiedTokensApiClient  {
        return DefaultValueRegistry.defaultValue(for: (VerifiedTokensApiClient).self)
    }
    
     override func createSessionsApiClient(baseUrl: String, merchantId: String) -> SessionsApiClient  {
        return DefaultValueRegistry.defaultValue(for: (SessionsApiClient).self)
    }
    
}

