@testable import AccessCheckoutSDK
import XCTest

class PanTextChangeHandlerTests : XCTestCase {
        
    private let textChangeHandler = PanTextChangeHandler(disableFormatting: false)
        
    func testSupportsAppendingText() {
        let originalText = "abc"
        let textChange = "de"
        let selection:NSRange = NSRange(location: 3, length: 0)
    
        let result = textChangeHandler.change(originalText: originalText, textChange: textChange, usingSelection: selection, brand: nil)
        
        XCTAssertEqual("abcd e", result)
    }
    
    func testSupportsDeletingACharacter() {
        let originalText = "1234 5"
        let textChange = ""
        let selection:NSRange = NSRange(location: 3, length: 1)
    
        let result = textChangeHandler.change(originalText: originalText, textChange: textChange, usingSelection: selection, brand: nil)
        
        XCTAssertEqual("1235", result)
    }

    func testSupportsReplacingText() {
        let originalText = "abcd"
        let textChange = "123"
        let selection:NSRange = NSRange(location: 2, length: 2)
    
        let result = textChangeHandler.change(originalText: originalText, textChange: textChange, usingSelection: selection, brand: nil)
        
        XCTAssertEqual("ab12 3", result)
    }
    
    func testSupportsDeletingASelection() {
        let originalText = "abcd"
        let textChange = ""
        let selection:NSRange = NSRange(location: 2, length: 2)
    
        let result = textChangeHandler.change(originalText: originalText, textChange: textChange, usingSelection: selection, brand: nil)
        
        XCTAssertEqual("ab", result)
    }
    
    func testSupportsDeletingEntireText() {
        let originalText = "abcd"
        let textChange = ""
        let selection:NSRange = NSRange(location: 0, length: originalText.count)
    
        let result = textChangeHandler.change(originalText: originalText, textChange: textChange, usingSelection: selection, brand: nil)
        
        XCTAssertEqual("", result)
    }
    
    func testReturnsOriginalTextWhenSelectionIsInvalid() {
        let originalText = "abcd"
        let textChange = "efg"
        let selection:NSRange = NSRange(location: 0, length: 10)
    
        let result = textChangeHandler.change(originalText: originalText, textChange: textChange, usingSelection: selection, brand: nil)
        
        XCTAssertEqual("abcd", result)
    }
    
    func testReturnsTextChangeWhenNoOriginalText() {
        let originalText:String? = nil
        let textChange = "123"
        let selection:NSRange = NSRange(location: 0, length: 0)
    
        let result = textChangeHandler.change(originalText: originalText, textChange: textChange, usingSelection: selection, brand: nil)
        
        XCTAssertEqual("123", result)
    }
    
    func testReturnsTextWithSpacesWhenFormattingEnabled() {
        let originalText = "44444444"
        let textChange = "4"
        let selection:NSRange = NSRange(location: 8, length: 0)
        
        let result = textChangeHandler.change(originalText: originalText, textChange: textChange, usingSelection: selection, brand: nil)
        
        XCTAssertEqual(result, "4444 4444 4")
    }
    
    func testReturnsTextWithSpacesWhenFormattingEnabledAndAmexPan() {
        let originalText = "3717 444444"
        let textChange = "1"
        let selection:NSRange = NSRange(location: 11, length: 0)
        
        let result = textChangeHandler.change(originalText: originalText, textChange: textChange, usingSelection: selection, brand: TestFixtures.amexBrand())
        
        XCTAssertEqual(result, "3717 444444 1")
    }
    
    func testReturnsTextWithSpacesWhenFormattingEnabledAndInsertingInAmexPan() {
        let originalText = "3717 444444"
        let textChange = "1"
        let selection:NSRange = NSRange(location: 8, length: 0)
        
        let result = textChangeHandler.change(originalText: originalText, textChange: textChange, usingSelection: selection, brand: TestFixtures.amexBrand())
        
        XCTAssertEqual(result, "3717 444144 4")
    }
}
