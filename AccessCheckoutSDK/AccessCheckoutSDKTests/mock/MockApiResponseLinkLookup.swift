import Cuckoo
@testable import AccessCheckoutSDK






 class MockApiResponseLinkLookup: ApiResponseLinkLookup, Cuckoo.ClassMock {
    
     typealias MocksType = ApiResponseLinkLookup
    
     typealias Stubbing = __StubbingProxy_ApiResponseLinkLookup
     typealias Verification = __VerificationProxy_ApiResponseLinkLookup

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: ApiResponseLinkLookup?

     func enableDefaultImplementation(_ stub: ApiResponseLinkLookup) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func lookup(link: String, in apiResponse: ApiResponse) -> String? {
        
    return cuckoo_manager.call(
    """
    lookup(link: String, in: ApiResponse) -> String?
    """,
            parameters: (link, apiResponse),
            escapingParameters: (link, apiResponse),
            superclassCall:
                
                super.lookup(link: link, in: apiResponse)
                ,
            defaultCall: __defaultImplStub!.lookup(link: link, in: apiResponse))
        
    }
    
    

     struct __StubbingProxy_ApiResponseLinkLookup: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func lookup<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(link: M1, in apiResponse: M2) -> Cuckoo.ClassStubFunction<(String, ApiResponse), String?> where M1.MatchedType == String, M2.MatchedType == ApiResponse {
            let matchers: [Cuckoo.ParameterMatcher<(String, ApiResponse)>] = [wrap(matchable: link) { $0.0 }, wrap(matchable: apiResponse) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockApiResponseLinkLookup.self, method:
    """
    lookup(link: String, in: ApiResponse) -> String?
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_ApiResponseLinkLookup: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func lookup<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(link: M1, in apiResponse: M2) -> Cuckoo.__DoNotUse<(String, ApiResponse), String?> where M1.MatchedType == String, M2.MatchedType == ApiResponse {
            let matchers: [Cuckoo.ParameterMatcher<(String, ApiResponse)>] = [wrap(matchable: link) { $0.0 }, wrap(matchable: apiResponse) { $0.1 }]
            return cuckoo_manager.verify(
    """
    lookup(link: String, in: ApiResponse) -> String?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class ApiResponseLinkLookupStub: ApiResponseLinkLookup {
    

    

    
    
    
    
     override func lookup(link: String, in apiResponse: ApiResponse) -> String?  {
        return DefaultValueRegistry.defaultValue(for: (String?).self)
    }
    
    
}
