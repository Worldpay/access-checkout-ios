import XCTest
@testable import AccessCheckoutSDK

class CvcFlowCvcValidationTests: XCTestCase {
    let app = XCUIApplication()
    var view:CvcFlowViewPageObject?
    
    override func setUp() {
        continueAfterFailure = false
        
        app.launch()
        
        view = NavigationViewPageObject(app).navigateToCvcFlow()
    }
    
    func testCvcFieldIsDisplayed() {
        XCTAssertTrue(view!.cvcField.exists)
    }
    
    func testCannotTypeAlphabeticalCharactersInCvc(){
        view!.typeTextIntoCvc("A")
        
        XCTAssertEqual(view!.cvcField.placeholderValue, view!.cvcText)
    }
    
    func testCanEnterNumericalCharactersInCvc(){
        view!.typeTextIntoCvc("1")
        
        XCTAssertEqual("1", view!.cvcText)
    }
    
    func testCanEnterValidCvcOf3Characters(){
        view!.typeTextIntoCvc("123")
        
        XCTAssertEqual("123", view!.cvcText)
    }
    
    func testCanEnterValidCvcOf4Characters(){
        view!.typeTextIntoCvc("1234")
        
        XCTAssertEqual("1234", view!.cvcText)
    }
    
    func testCanEnterUpTo4NumericalCharactersInCvc(){
        view!.typeTextIntoCvc("123456")
        
        XCTAssertEqual("1234", view!.cvcText)
    }
    
    func testSubmitButtonIsDisplayed() {
        XCTAssertTrue(view!.submitButton.exists)
    }
    
    func testSubmitButtonIsDisabledByDefault() {
        XCTAssertFalse(view!.submitButton.isEnabled)
    }
    
    func testSubmitButtonRemainsDisabledWhenIncompleteCvcIsEntered() {
        view!.typeTextIntoCvc("12")
        
        XCTAssertFalse(view!.submitButton.isEnabled)
    }
    
    func testSubmitButtonIsEnabledWhenValidCvcIsEntered() {
        view!.typeTextIntoCvc("123")
        
        XCTAssertTrue(view!.submitButton.isEnabled)
    }
}
