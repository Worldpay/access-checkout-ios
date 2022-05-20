import Cuckoo
@testable import AccessCheckoutSDK

import Foundation


 class MockTextChangeHandler: TextChangeHandler, Cuckoo.ClassMock {
    
     typealias MocksType = TextChangeHandler
    
     typealias Stubbing = __StubbingProxy_TextChangeHandler
     typealias Verification = __VerificationProxy_TextChangeHandler

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: TextChangeHandler?

     func enableDefaultImplementation(_ stub: TextChangeHandler) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     override func change(originalText: String?, textChange: String, usingSelection selection: NSRange) -> String {
        
    return cuckoo_manager.call("change(originalText: String?, textChange: String, usingSelection: NSRange) -> String",
            parameters: (originalText, textChange, selection),
            escapingParameters: (originalText, textChange, selection),
            superclassCall:
                
                super.change(originalText: originalText, textChange: textChange, usingSelection: selection)
                ,
            defaultCall: __defaultImplStub!.change(originalText: originalText, textChange: textChange, usingSelection: selection))
        
    }
    

	 struct __StubbingProxy_TextChangeHandler: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func change<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(originalText: M1, textChange: M2, usingSelection selection: M3) -> Cuckoo.ClassStubFunction<(String?, String, NSRange), String> where M1.OptionalMatchedType == String, M2.MatchedType == String, M3.MatchedType == NSRange {
	        let matchers: [Cuckoo.ParameterMatcher<(String?, String, NSRange)>] = [wrap(matchable: originalText) { $0.0 }, wrap(matchable: textChange) { $0.1 }, wrap(matchable: selection) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockTextChangeHandler.self, method: "change(originalText: String?, textChange: String, usingSelection: NSRange) -> String", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_TextChangeHandler: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func change<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(originalText: M1, textChange: M2, usingSelection selection: M3) -> Cuckoo.__DoNotUse<(String?, String, NSRange), String> where M1.OptionalMatchedType == String, M2.MatchedType == String, M3.MatchedType == NSRange {
	        let matchers: [Cuckoo.ParameterMatcher<(String?, String, NSRange)>] = [wrap(matchable: originalText) { $0.0 }, wrap(matchable: textChange) { $0.1 }, wrap(matchable: selection) { $0.2 }]
	        return cuckoo_manager.verify("change(originalText: String?, textChange: String, usingSelection: NSRange) -> String", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class TextChangeHandlerStub: TextChangeHandler {
    

    

    
     override func change(originalText: String?, textChange: String, usingSelection selection: NSRange) -> String  {
        return DefaultValueRegistry.defaultValue(for: (String).self)
    }
    
}

