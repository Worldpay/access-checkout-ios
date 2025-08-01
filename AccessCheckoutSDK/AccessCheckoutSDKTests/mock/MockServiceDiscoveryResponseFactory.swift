import Cuckoo
@testable import AccessCheckoutSDK

import Foundation






 class MockServiceDiscoveryResponseFactory: ServiceDiscoveryResponseFactory, Cuckoo.ClassMock {
    
     typealias MocksType = ServiceDiscoveryResponseFactory
    
     typealias Stubbing = __StubbingProxy_ServiceDiscoveryResponseFactory
     typealias Verification = __VerificationProxy_ServiceDiscoveryResponseFactory

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: ServiceDiscoveryResponseFactory?

     func enableDefaultImplementation(_ stub: ServiceDiscoveryResponseFactory) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func create(request: URLRequest, completionHandler: @escaping (ApiResponse?) -> Void)  {
        
    return cuckoo_manager.call(
    """
    create(request: URLRequest, completionHandler: @escaping (ApiResponse?) -> Void)
    """,
            parameters: (request, completionHandler),
            escapingParameters: (request, completionHandler),
            superclassCall:
                
                super.create(request: request, completionHandler: completionHandler)
                ,
            defaultCall: __defaultImplStub!.create(request: request, completionHandler: completionHandler))
        
    }
    
    

     struct __StubbingProxy_ServiceDiscoveryResponseFactory: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func create<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(request: M1, completionHandler: M2) -> Cuckoo.ClassStubNoReturnFunction<(URLRequest, (ApiResponse?) -> Void)> where M1.MatchedType == URLRequest, M2.MatchedType == (ApiResponse?) -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(URLRequest, (ApiResponse?) -> Void)>] = [wrap(matchable: request) { $0.0 }, wrap(matchable: completionHandler) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockServiceDiscoveryResponseFactory.self, method:
    """
    create(request: URLRequest, completionHandler: @escaping (ApiResponse?) -> Void)
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_ServiceDiscoveryResponseFactory: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func create<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(request: M1, completionHandler: M2) -> Cuckoo.__DoNotUse<(URLRequest, (ApiResponse?) -> Void), Void> where M1.MatchedType == URLRequest, M2.MatchedType == (ApiResponse?) -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(URLRequest, (ApiResponse?) -> Void)>] = [wrap(matchable: request) { $0.0 }, wrap(matchable: completionHandler) { $0.1 }]
            return cuckoo_manager.verify(
    """
    create(request: URLRequest, completionHandler: @escaping (ApiResponse?) -> Void)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class ServiceDiscoveryResponseFactoryStub: ServiceDiscoveryResponseFactory {
    

    

    
    
    
    
     override func create(request: URLRequest, completionHandler: @escaping (ApiResponse?) -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}




