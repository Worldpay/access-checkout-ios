import Cuckoo
@testable import AccessCheckoutSDK

import Foundation


 class MockExpiryDateValidator: ExpiryDateValidator, Cuckoo.ClassMock {
    
     typealias MocksType = ExpiryDateValidator
    
     typealias Stubbing = __StubbingProxy_ExpiryDateValidator
     typealias Verification = __VerificationProxy_ExpiryDateValidator

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: ExpiryDateValidator?

     func enableDefaultImplementation(_ stub: ExpiryDateValidator) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     override func validate(_ expiryDate: String) -> Bool {
        
    return cuckoo_manager.call("validate(_: String) -> Bool",
            parameters: (expiryDate),
            escapingParameters: (expiryDate),
            superclassCall:
                
                super.validate(expiryDate)
                ,
            defaultCall: __defaultImplStub!.validate(expiryDate))
        
    }
    
    
    
     override func canValidate(_ text: String) -> Bool {
        
    return cuckoo_manager.call("canValidate(_: String) -> Bool",
            parameters: (text),
            escapingParameters: (text),
            superclassCall:
                
                super.canValidate(text)
                ,
            defaultCall: __defaultImplStub!.canValidate(text))
        
    }
    

	 struct __StubbingProxy_ExpiryDateValidator: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func validate<M1: Cuckoo.Matchable>(_ expiryDate: M1) -> Cuckoo.ClassStubFunction<(String), Bool> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: expiryDate) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockExpiryDateValidator.self, method: "validate(_: String) -> Bool", parameterMatchers: matchers))
	    }
	    
	    func canValidate<M1: Cuckoo.Matchable>(_ text: M1) -> Cuckoo.ClassStubFunction<(String), Bool> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: text) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockExpiryDateValidator.self, method: "canValidate(_: String) -> Bool", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_ExpiryDateValidator: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func validate<M1: Cuckoo.Matchable>(_ expiryDate: M1) -> Cuckoo.__DoNotUse<(String), Bool> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: expiryDate) { $0 }]
	        return cuckoo_manager.verify("validate(_: String) -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func canValidate<M1: Cuckoo.Matchable>(_ text: M1) -> Cuckoo.__DoNotUse<(String), Bool> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: text) { $0 }]
	        return cuckoo_manager.verify("canValidate(_: String) -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class ExpiryDateValidatorStub: ExpiryDateValidator {
    

    

    
     override func validate(_ expiryDate: String) -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
     override func canValidate(_ text: String) -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
}

