import Cuckoo
@testable import AccessCheckoutSDK

import Foundation






 class MockCardBinCacheManager: CardBinCacheManager, Cuckoo.ClassMock {
    
     typealias MocksType = CardBinCacheManager
    
     typealias Stubbing = __StubbingProxy_CardBinCacheManager
     typealias Verification = __VerificationProxy_CardBinCacheManager

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: CardBinCacheManager?

     func enableDefaultImplementation(_ stub: CardBinCacheManager) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func getCacheKey(from cardNumber: String) -> String {
        
    return cuckoo_manager.call(
    """
    getCacheKey(from: String) -> String
    """,
            parameters: (cardNumber),
            escapingParameters: (cardNumber),
            superclassCall:
                
                super.getCacheKey(from: cardNumber)
                ,
            defaultCall: __defaultImplStub!.getCacheKey(from: cardNumber))
        
    }
    
    
    
    
    
     override func getCachedResponse(for key: String) -> CardBinResponse? {
        
    return cuckoo_manager.call(
    """
    getCachedResponse(for: String) -> CardBinResponse?
    """,
            parameters: (key),
            escapingParameters: (key),
            superclassCall:
                
                super.getCachedResponse(for: key)
                ,
            defaultCall: __defaultImplStub!.getCachedResponse(for: key))
        
    }
    
    
    
    
    
     override func putInCache(key: String, response: CardBinResponse)  {
        
    return cuckoo_manager.call(
    """
    putInCache(key: String, response: CardBinResponse)
    """,
            parameters: (key, response),
            escapingParameters: (key, response),
            superclassCall:
                
                super.putInCache(key: key, response: response)
                ,
            defaultCall: __defaultImplStub!.putInCache(key: key, response: response))
        
    }
    
    

     struct __StubbingProxy_CardBinCacheManager: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func getCacheKey<M1: Cuckoo.Matchable>(from cardNumber: M1) -> Cuckoo.ClassStubFunction<(String), String> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: cardNumber) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockCardBinCacheManager.self, method:
    """
    getCacheKey(from: String) -> String
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getCachedResponse<M1: Cuckoo.Matchable>(for key: M1) -> Cuckoo.ClassStubFunction<(String), CardBinResponse?> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: key) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockCardBinCacheManager.self, method:
    """
    getCachedResponse(for: String) -> CardBinResponse?
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func putInCache<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(key: M1, response: M2) -> Cuckoo.ClassStubNoReturnFunction<(String, CardBinResponse)> where M1.MatchedType == String, M2.MatchedType == CardBinResponse {
            let matchers: [Cuckoo.ParameterMatcher<(String, CardBinResponse)>] = [wrap(matchable: key) { $0.0 }, wrap(matchable: response) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockCardBinCacheManager.self, method:
    """
    putInCache(key: String, response: CardBinResponse)
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_CardBinCacheManager: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func getCacheKey<M1: Cuckoo.Matchable>(from cardNumber: M1) -> Cuckoo.__DoNotUse<(String), String> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: cardNumber) { $0 }]
            return cuckoo_manager.verify(
    """
    getCacheKey(from: String) -> String
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getCachedResponse<M1: Cuckoo.Matchable>(for key: M1) -> Cuckoo.__DoNotUse<(String), CardBinResponse?> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: key) { $0 }]
            return cuckoo_manager.verify(
    """
    getCachedResponse(for: String) -> CardBinResponse?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func putInCache<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(key: M1, response: M2) -> Cuckoo.__DoNotUse<(String, CardBinResponse), Void> where M1.MatchedType == String, M2.MatchedType == CardBinResponse {
            let matchers: [Cuckoo.ParameterMatcher<(String, CardBinResponse)>] = [wrap(matchable: key) { $0.0 }, wrap(matchable: response) { $0.1 }]
            return cuckoo_manager.verify(
    """
    putInCache(key: String, response: CardBinResponse)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class CardBinCacheManagerStub: CardBinCacheManager {
    

    

    
    
    
    
     override func getCacheKey(from cardNumber: String) -> String  {
        return DefaultValueRegistry.defaultValue(for: (String).self)
    }
    
    
    
    
    
     override func getCachedResponse(for key: String) -> CardBinResponse?  {
        return DefaultValueRegistry.defaultValue(for: (CardBinResponse?).self)
    }
    
    
    
    
    
     override func putInCache(key: String, response: CardBinResponse)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}




