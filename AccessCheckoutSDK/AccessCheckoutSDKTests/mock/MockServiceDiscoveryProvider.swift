import Cuckoo
@testable import AccessCheckoutSDK

import Dispatch
import Foundation
import os






 class MockServiceDiscoveryProvider: ServiceDiscoveryProvider, Cuckoo.ClassMock {
    
     typealias MocksType = ServiceDiscoveryProvider
    
     typealias Stubbing = __StubbingProxy_ServiceDiscoveryProvider
     typealias Verification = __VerificationProxy_ServiceDiscoveryProvider

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: ServiceDiscoveryProvider?

     func enableDefaultImplementation(_ stub: ServiceDiscoveryProvider) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func getSessionsCardEndpoint() -> String? {
        
    return cuckoo_manager.call(
    """
    getSessionsCardEndpoint() -> String?
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.getSessionsCardEndpoint()
                ,
            defaultCall: __defaultImplStub!.getSessionsCardEndpoint())
        
    }
    
    
    
    
    
     override func getSessionsCvcEndpoint() -> String? {
        
    return cuckoo_manager.call(
    """
    getSessionsCvcEndpoint() -> String?
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.getSessionsCvcEndpoint()
                ,
            defaultCall: __defaultImplStub!.getSessionsCvcEndpoint())
        
    }
    
    
    
    
    
     override func clearCache()  {
        
    return cuckoo_manager.call(
    """
    clearCache()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.clearCache()
                ,
            defaultCall: __defaultImplStub!.clearCache())
        
    }
    
    
    
    
    
     override func discover(completionHandler: @escaping (Result<Void, AccessCheckoutError>) -> Void)  {
        
    return cuckoo_manager.call(
    """
    discover(completionHandler: @escaping (Result<Void, AccessCheckoutError>) -> Void)
    """,
            parameters: (completionHandler),
            escapingParameters: (completionHandler),
            superclassCall:
                
                super.discover(completionHandler: completionHandler)
                ,
            defaultCall: __defaultImplStub!.discover(completionHandler: completionHandler))
        
    }
    
    

     struct __StubbingProxy_ServiceDiscoveryProvider: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func getSessionsCardEndpoint() -> Cuckoo.ClassStubFunction<(), String?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockServiceDiscoveryProvider.self, method:
    """
    getSessionsCardEndpoint() -> String?
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getSessionsCvcEndpoint() -> Cuckoo.ClassStubFunction<(), String?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockServiceDiscoveryProvider.self, method:
    """
    getSessionsCvcEndpoint() -> String?
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func clearCache() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockServiceDiscoveryProvider.self, method:
    """
    clearCache()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func discover<M1: Cuckoo.Matchable>(completionHandler: M1) -> Cuckoo.ClassStubNoReturnFunction<((Result<Void, AccessCheckoutError>) -> Void)> where M1.MatchedType == (Result<Void, AccessCheckoutError>) -> Void {
            let matchers: [Cuckoo.ParameterMatcher<((Result<Void, AccessCheckoutError>) -> Void)>] = [wrap(matchable: completionHandler) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockServiceDiscoveryProvider.self, method:
    """
    discover(completionHandler: @escaping (Result<Void, AccessCheckoutError>) -> Void)
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_ServiceDiscoveryProvider: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func getSessionsCardEndpoint() -> Cuckoo.__DoNotUse<(), String?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    getSessionsCardEndpoint() -> String?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getSessionsCvcEndpoint() -> Cuckoo.__DoNotUse<(), String?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    getSessionsCvcEndpoint() -> String?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func clearCache() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    clearCache()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func discover<M1: Cuckoo.Matchable>(completionHandler: M1) -> Cuckoo.__DoNotUse<((Result<Void, AccessCheckoutError>) -> Void), Void> where M1.MatchedType == (Result<Void, AccessCheckoutError>) -> Void {
            let matchers: [Cuckoo.ParameterMatcher<((Result<Void, AccessCheckoutError>) -> Void)>] = [wrap(matchable: completionHandler) { $0 }]
            return cuckoo_manager.verify(
    """
    discover(completionHandler: @escaping (Result<Void, AccessCheckoutError>) -> Void)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class ServiceDiscoveryProviderStub: ServiceDiscoveryProvider {
    

    

    
    
    
    
     override func getSessionsCardEndpoint() -> String?  {
        return DefaultValueRegistry.defaultValue(for: (String?).self)
    }
    
    
    
    
    
     override func getSessionsCvcEndpoint() -> String?  {
        return DefaultValueRegistry.defaultValue(for: (String?).self)
    }
    
    
    
    
    
     override func clearCache()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func discover(completionHandler: @escaping (Result<Void, AccessCheckoutError>) -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}




