@testable import AccessCheckoutSDK
import XCTest

class UserAgentTests: XCTestCase {
    let expectedErrorMessage = "Unsupported version format. This functionality only supports access-checkout-react-native semantic versions or default access-checkout-ios version."
    
    func testAllowsToOverrideVersionWithAccessCheckoutReactNativeVersion() throws {
        let newVersion = "access-checkout-react-native/10.3.15"
        
        try UserAgent.overrideHeaderValue(with: newVersion)
        
        XCTAssertEqual(newVersion, UserAgent.headerValue)
    }
    
    func testThrowsErrorWhenSemanticVersionIsNotInXYZFormat() throws {
        let newVersion = "access-checkout-react-native/10.3"
        
        
        XCTAssertThrowsError(try UserAgent.overrideHeaderValue(with: newVersion)) { error in
            XCTAssertEqual(expectedErrorMessage, (error as! UserAgentError).message)
        }
    }
    
    func testThrowsErrorWhenAccessCheckoutReactNativeDoesNotHaveCorrectCase() throws {
        let newVersion = "Access-Checkout-REACT-native/10.3.15"
        
        XCTAssertThrowsError(try UserAgent.overrideHeaderValue(with: newVersion)) { error in
            XCTAssertEqual(expectedErrorMessage, (error as! UserAgentError).message)
        }
    }
    
    func testThrowsErrorWhenAttemptingToOverrideWithNonAccessCheckoutReactNativeVersion() throws {
        let newVersion = "something-else/10.3.15"
        
        XCTAssertThrowsError(try UserAgent.overrideHeaderValue(with: newVersion)) { error in
            XCTAssertEqual(expectedErrorMessage, (error as! UserAgentError).message)
        }
    }
    
    func testAllowsToOverrideVersionWithDefaultAccessCheckoutIosVersion() throws {
        try UserAgent.overrideHeaderValue(with: UserAgent.defaultHeaderValue)
        
        XCTAssertEqual(UserAgent.defaultHeaderValue, UserAgent.headerValue)
    }
    
    func testThrowsErrorWhenAttemptingToOverrideWithAccessCheckoutIosOfDifferentSemanticVersion() throws {
        let newVersion = "access-checkout-ios/1.2.3"
        
        XCTAssertThrowsError(try UserAgent.overrideHeaderValue(with: newVersion)) { error in
            XCTAssertEqual(expectedErrorMessage, (error as! UserAgentError).message)
        }
    }
    
    override class func tearDown() {
        try! UserAgent.overrideHeaderValue(with: UserAgent.defaultHeaderValue)
    }
}
