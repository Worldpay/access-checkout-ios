import Cuckoo
@testable import AccessCheckoutSDK

import Foundation


 class MockSingleLinkDiscoveryFactory: SingleLinkDiscoveryFactory, Cuckoo.ClassMock {
    
     typealias MocksType = SingleLinkDiscoveryFactory
    
     typealias Stubbing = __StubbingProxy_SingleLinkDiscoveryFactory
     typealias Verification = __VerificationProxy_SingleLinkDiscoveryFactory

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: SingleLinkDiscoveryFactory?

     func enableDefaultImplementation(_ stub: SingleLinkDiscoveryFactory) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     override func create(toFindLink: String, usingRequest: URLRequest) -> SingleLinkDiscovery {
        
    return cuckoo_manager.call("create(toFindLink: String, usingRequest: URLRequest) -> SingleLinkDiscovery",
            parameters: (toFindLink, usingRequest),
            escapingParameters: (toFindLink, usingRequest),
            superclassCall:
                
                super.create(toFindLink: toFindLink, usingRequest: usingRequest)
                ,
            defaultCall: __defaultImplStub!.create(toFindLink: toFindLink, usingRequest: usingRequest))
        
    }
    

	 struct __StubbingProxy_SingleLinkDiscoveryFactory: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func create<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(toFindLink: M1, usingRequest: M2) -> Cuckoo.ClassStubFunction<(String, URLRequest), SingleLinkDiscovery> where M1.MatchedType == String, M2.MatchedType == URLRequest {
	        let matchers: [Cuckoo.ParameterMatcher<(String, URLRequest)>] = [wrap(matchable: toFindLink) { $0.0 }, wrap(matchable: usingRequest) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockSingleLinkDiscoveryFactory.self, method: "create(toFindLink: String, usingRequest: URLRequest) -> SingleLinkDiscovery", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_SingleLinkDiscoveryFactory: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func create<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(toFindLink: M1, usingRequest: M2) -> Cuckoo.__DoNotUse<(String, URLRequest), SingleLinkDiscovery> where M1.MatchedType == String, M2.MatchedType == URLRequest {
	        let matchers: [Cuckoo.ParameterMatcher<(String, URLRequest)>] = [wrap(matchable: toFindLink) { $0.0 }, wrap(matchable: usingRequest) { $0.1 }]
	        return cuckoo_manager.verify("create(toFindLink: String, usingRequest: URLRequest) -> SingleLinkDiscovery", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class SingleLinkDiscoveryFactoryStub: SingleLinkDiscoveryFactory {
    

    

    
     override func create(toFindLink: String, usingRequest: URLRequest) -> SingleLinkDiscovery  {
        return DefaultValueRegistry.defaultValue(for: (SingleLinkDiscovery).self)
    }
    
}

