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
    
    

     struct __StubbingProxy_ServiceDiscoveryProvider: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func clearCache() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockServiceDiscoveryProvider.self, method:
    """
    clearCache()
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
        func clearCache() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    clearCache()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class ServiceDiscoveryProviderStub: ServiceDiscoveryProvider {
    

    

    
    
    
    
     override func clearCache()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}




