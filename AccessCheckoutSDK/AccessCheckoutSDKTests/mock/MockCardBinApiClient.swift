import Cuckoo
@testable import AccessCheckoutSDK

import Foundation






 class MockCardBinApiClient: CardBinApiClient, Cuckoo.ClassMock {
    
     typealias MocksType = CardBinApiClient
    
     typealias Stubbing = __StubbingProxy_CardBinApiClient
     typealias Verification = __VerificationProxy_CardBinApiClient

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: CardBinApiClient?

     func enableDefaultImplementation(_ stub: CardBinApiClient) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func retrieveBinInfo(cardNumber: String, checkoutId: String, completionHandler: @escaping (Result<CardBinResponse, AccessCheckoutError>) -> Void)  {
        
    return cuckoo_manager.call(
    """
    retrieveBinInfo(cardNumber: String, checkoutId: String, completionHandler: @escaping (Result<CardBinResponse, AccessCheckoutError>) -> Void)
    """,
            parameters: (cardNumber, checkoutId, completionHandler),
            escapingParameters: (cardNumber, checkoutId, completionHandler),
            superclassCall:
                
                super.retrieveBinInfo(cardNumber: cardNumber, checkoutId: checkoutId, completionHandler: completionHandler)
                ,
            defaultCall: __defaultImplStub!.retrieveBinInfo(cardNumber: cardNumber, checkoutId: checkoutId, completionHandler: completionHandler))
        
    }
    
    
    
    
    
     override func abort()  {
        
    return cuckoo_manager.call(
    """
    abort()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.abort()
                ,
            defaultCall: __defaultImplStub!.abort())
        
    }
    
    

     struct __StubbingProxy_CardBinApiClient: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func retrieveBinInfo<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(cardNumber: M1, checkoutId: M2, completionHandler: M3) -> Cuckoo.ClassStubNoReturnFunction<(String, String, (Result<CardBinResponse, AccessCheckoutError>) -> Void)> where M1.MatchedType == String, M2.MatchedType == String, M3.MatchedType == (Result<CardBinResponse, AccessCheckoutError>) -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(String, String, (Result<CardBinResponse, AccessCheckoutError>) -> Void)>] = [wrap(matchable: cardNumber) { $0.0 }, wrap(matchable: checkoutId) { $0.1 }, wrap(matchable: completionHandler) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockCardBinApiClient.self, method:
    """
    retrieveBinInfo(cardNumber: String, checkoutId: String, completionHandler: @escaping (Result<CardBinResponse, AccessCheckoutError>) -> Void)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func abort() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockCardBinApiClient.self, method:
    """
    abort()
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_CardBinApiClient: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func retrieveBinInfo<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(cardNumber: M1, checkoutId: M2, completionHandler: M3) -> Cuckoo.__DoNotUse<(String, String, (Result<CardBinResponse, AccessCheckoutError>) -> Void), Void> where M1.MatchedType == String, M2.MatchedType == String, M3.MatchedType == (Result<CardBinResponse, AccessCheckoutError>) -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(String, String, (Result<CardBinResponse, AccessCheckoutError>) -> Void)>] = [wrap(matchable: cardNumber) { $0.0 }, wrap(matchable: checkoutId) { $0.1 }, wrap(matchable: completionHandler) { $0.2 }]
            return cuckoo_manager.verify(
    """
    retrieveBinInfo(cardNumber: String, checkoutId: String, completionHandler: @escaping (Result<CardBinResponse, AccessCheckoutError>) -> Void)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func abort() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    abort()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class CardBinApiClientStub: CardBinApiClient {
    

    

    
    
    
    
     override func retrieveBinInfo(cardNumber: String, checkoutId: String, completionHandler: @escaping (Result<CardBinResponse, AccessCheckoutError>) -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func abort()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}




