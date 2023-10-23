@testable import AccessCheckoutSDK
import XCTest

class PanTextChangeHandlerTests: XCTestCase {
    func testSupportsAppendingText() {
        let originalText = "abc"
        let textChange = "de"
        let selection: NSRange = NSRange(location: 3, length: 0)
        
        let result = panTextChangeHandler().change(originalText: originalText, textChange: textChange, usingSelection: selection)
        
        XCTAssertEqual("abcd e", result)
    }
    
    func testSupportsDeletingACharacter() {
        let originalText = "1234 5"
        let textChange = ""
        let selection: NSRange = NSRange(location: 3, length: 1)
        
        let result = panTextChangeHandler().change(originalText: originalText, textChange: textChange, usingSelection: selection)
        
        XCTAssertEqual("1235", result)
    }
    
    func testReturnsSameStringWhenDeletingASpace() {
        let originalText = "1234 5"
        let textChange = ""
        let selection: NSRange = NSRange(location: 4, length: 1)
        
        let result = panTextChangeHandler().change(originalText: originalText, textChange: textChange, usingSelection: selection)
        
        XCTAssertEqual("1234 5", result)
    }
    
    func testSupportsDeletingASpaceAndText() {
        let originalText = "1234 5"
        let textChange = ""
        let selection: NSRange = NSRange(location: 3, length: 3)
        
        let result = panTextChangeHandler().change(originalText: originalText, textChange: textChange, usingSelection: selection)
        
        XCTAssertEqual("123", result)
    }
    
    func testSupportsReplacingText() {
        let originalText = "abcd"
        let textChange = "123"
        let selection: NSRange = NSRange(location: 2, length: 2)
        
        let result = panTextChangeHandler().change(originalText: originalText, textChange: textChange, usingSelection: selection)
        
        XCTAssertEqual("ab12 3", result)
    }
    
    func testSupportsDeletingASelection() {
        let originalText = "abcd"
        let textChange = ""
        let selection: NSRange = NSRange(location: 2, length: 2)
        
        let result = panTextChangeHandler().change(originalText: originalText, textChange: textChange, usingSelection: selection)
        
        XCTAssertEqual("ab", result)
    }
    
    func testSupportsDeletingEntireText() {
        let originalText = "abcd"
        let textChange = ""
        let selection: NSRange = NSRange(location: 0, length: originalText.count)
        
        let result = panTextChangeHandler().change(originalText: originalText, textChange: textChange, usingSelection: selection)
        
        XCTAssertEqual("", result)
    }
    
    func testReturnsOriginalTextWhenSelectionIsInvalid() {
        let originalText = "abcd"
        let textChange = "efg"
        let selection: NSRange = NSRange(location: 0, length: 10)
        
        let result = panTextChangeHandler().change(originalText: originalText, textChange: textChange, usingSelection: selection)
        
        XCTAssertEqual("abcd", result)
    }
    
    func testReturnsTextWithSpacesWhenFormattingEnabled() {
        let originalText = "44444444"
        let textChange = "4"
        let selection: NSRange = NSRange(location: 8, length: 0)
        
        let result = panTextChangeHandler().change(originalText: originalText, textChange: textChange, usingSelection: selection)
        
        XCTAssertEqual(result, "4444 4444 4")
    }
    
    func testReturnsTextWithSpacesWhenFormattingEnabledAndAmexPan() {
        let originalText = "3717 444444"
        let textChange = "1"
        let selection: NSRange = NSRange(location: 11, length: 0)
        
        let result = panTextChangeHandler().change(originalText: originalText, textChange: textChange, usingSelection: selection)
        
        XCTAssertEqual(result, "3717 444444 1")
    }
    
    func testReturnsTextWithSpacesWhenFormattingEnabledAndInsertingInAmexPan() {
        let originalText = "3717 444444"
        let textChange = "1"
        let selection: NSRange = NSRange(location: 8, length: 0)
        
        let result = panTextChangeHandler().change(originalText: originalText, textChange: textChange, usingSelection: selection)
        
        XCTAssertEqual(result, "3717 444144 4")
    }
    
    func testReturnsTextCutToMaxLengthIfLongerThanMaxLengthForBrand() {
        let originalText = "4444 3333 2222"
        let textChange = "111100009999"
        let selection: NSRange = NSRange(location: 14, length: 0)
        
        let result = panTextChangeHandler().change(originalText: originalText, textChange: textChange, usingSelection: selection)
        
        XCTAssertEqual(result, "4444 3333 2222 1111 000")
    }
    
    private func panTextChangeHandler() -> PanTextChangeHandler {
        let cardBrandsInConfig = [TestFixtures.amexBrand(), TestFixtures.visaBrand()]
        
        let acceptedCardBrands: [String] = []
        let configuration = CardBrandsConfiguration(allCardBrands: cardBrandsInConfig, acceptedCardBrands: acceptedCardBrands)
        let configurationFactory = CardBrandsConfigurationFactoryMock()
        configurationFactory.willReturn(configuration)
        
        let configurationProvider = CardBrandsConfigurationProvider(configurationFactory)
        configurationProvider.retrieveRemoteConfiguration(baseUrl: "", acceptedCardBrands: acceptedCardBrands)
        
        return PanTextChangeHandler(PanValidator(configurationProvider), panFormattingEnabled: true)
    }
}
