import XCTest
@testable import AccessCheckoutSDK

class CvvOnlyFlowCvvValidationTests: XCTestCase {
    let app = XCUIApplication()
    var view:CvvOnlyFlowViewPageObject?
    
    override func setUp() {
        continueAfterFailure = false
        
        app.launch()
        
        view = NavigationViewPageObject(app).navigateToCvvFlow()
    }
    
    func testCvvFieldIsDisplayed() {
        XCTAssertTrue(view!.cvvField.exists)
    }
    
    func testCannotTypeAlphabeticalCharactersInCvv(){
        view!.typeTextIntoCvv("A")
        
        XCTAssertEqual(view!.cvvField.placeholderValue, view!.cvvText)
    }
    
    func testCanEnterNumericalCharactersInCvv(){
        view!.typeTextIntoCvv("1")
        
        XCTAssertEqual("1", view!.cvvText)
    }
    
    func testCanEnterValidCvvOf3Characters(){
        view!.typeTextIntoCvv("123")
        
        XCTAssertEqual("123", view!.cvvText)
    }
    
    func testCanEnterValidCvvOf4Characters(){
        view!.typeTextIntoCvv("1234")
        
        XCTAssertEqual("1234", view!.cvvText)
    }
    
    func testCanEnterUpTo4NumericalCharactersInCvv(){
        view!.typeTextIntoCvv("123456")
        
        XCTAssertEqual("1234", view!.cvvText)
    }
    
    func testSubmitButtonIsDisplayed() {
        XCTAssertTrue(view!.submitButton.exists)
    }
    
    func testSubmitButtonIsDisabledByDefault() {
        XCTAssertFalse(view!.submitButton.isEnabled)
    }
    
    func testSubmitButtonRemainsDisabledWhenIncompleteCvvIsEntered() {
        view!.typeTextIntoCvv("12")
        
        XCTAssertFalse(view!.submitButton.isEnabled)
    }
    
    func testSubmitButtonIsEnabledWhenValidCvvIsEntered() {
        view!.typeTextIntoCvv("123")
        
        XCTAssertTrue(view!.submitButton.isEnabled)
    }
}
