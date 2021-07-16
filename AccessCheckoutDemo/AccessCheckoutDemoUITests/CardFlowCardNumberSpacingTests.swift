@testable import AccessCheckoutSDK
import Foundation
import XCTest

class CardFlowCardNumberSpacingTests: XCTestCase {
    private let backspace = String(XCUIKeyboardKey.delete.rawValue)
    
    let app = XCUIApplication()
    var view: CardFlowViewPageObject?
    
    override func setUp() {
        continueAfterFailure = false
        
        app.launch()
        view = CardFlowViewPageObject(app)
    }
    
    // MARK: Card numbers spacing per brand
    
    func testFormatsAmexPan() {
        view!.typeTextIntoPan("37178")
        XCTAssertTrue(view!.imageIs("amex"))
        
        XCTAssertEqual(view!.panText!, "3717 8")
        
        view!.typeTextIntoPan("1111")
        
        XCTAssertEqual(view!.panText!, "3717 81111")
        
        view!.typeTextIntoPan("1111")
        
        XCTAssertEqual(view!.panText!, "3717 811111 111")
        
        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)
        
        XCTAssertEqual(view!.panText!, "3717 81111")
    }
    
    func testFormatsVisaPan() {
        view!.typeTextIntoPan("41111")
        XCTAssertTrue(view!.imageIs("visa"))
        
        XCTAssertEqual(view!.panText!, "4111 1")
        
        view!.typeTextIntoPan("1111")
        
        XCTAssertEqual(view!.panText!, "4111 1111 1")
        
        view!.typeTextIntoPan("3333")
        
        XCTAssertEqual(view!.panText!, "4111 1111 1333 3")
        
        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)
        
        XCTAssertEqual(view!.panText!, "4111 1111 133")
    }
    
    func testFormatsMastercardPan() {
        view!.typeTextIntoPan("54545")
        XCTAssertTrue(view!.imageIs("mastercard"))
        
        XCTAssertEqual(view!.panText!, "5454 5")
        
        view!.typeTextIntoPan("4545")
        
        XCTAssertEqual(view!.panText!, "5454 5454 5")
        
        view!.typeTextIntoPan("4545")
        
        XCTAssertEqual(view!.panText!, "5454 5454 5454 5")
        
        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)
        
        XCTAssertEqual(view!.panText!, "5454 5454 545")
    }
    
    func testFormatsJcbPan() {
        view!.typeTextIntoPan("35280")
        XCTAssertTrue(view!.imageIs("jcb"))
        
        XCTAssertEqual(view!.panText!, "3528 0")
        
        view!.typeTextIntoPan("0070")
        
        XCTAssertEqual(view!.panText!, "3528 0007 0")
        
        view!.typeTextIntoPan("0000")
        
        XCTAssertEqual(view!.panText!, "3528 0007 0000 0")
        
        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)
        
        XCTAssertEqual(view!.panText!, "3528 0007 000")
    }
    
    func testFormatsDiscoverPan() {
        view!.typeTextIntoPan("60110")
        XCTAssertTrue(view!.imageIs("discover"))
        
        XCTAssertEqual(view!.panText!, "6011 0")
        
        view!.typeTextIntoPan("0040")
        
        XCTAssertEqual(view!.panText!, "6011 0004 0")
        
        view!.typeTextIntoPan("0000")
        
        XCTAssertEqual(view!.panText!, "6011 0004 0000 0")
        
        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)
        
        XCTAssertEqual(view!.panText!, "6011 0004 000")
    }
    
    func testFormatsDinersPan() {
        view!.typeTextIntoPan("36700")
        XCTAssertTrue(view!.imageIs("diners"))
        
        XCTAssertEqual(view!.panText!, "3670 0")
        
        view!.typeTextIntoPan("1020")
        
        XCTAssertEqual(view!.panText!, "3670 0102 0")
        
        view!.typeTextIntoPan("0000")
        
        XCTAssertEqual(view!.panText!, "3670 0102 0000 0")
        
        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)
        
        XCTAssertEqual(view!.panText!, "3670 0102 000")
    }
    
    func testFormatsMaestroPan() {
        view!.typeTextIntoPan("67596")
        XCTAssertTrue(view!.imageIs("maestro"))
        
        XCTAssertEqual(view!.panText!, "6759 6")
        
        view!.typeTextIntoPan("4982")
        
        XCTAssertEqual(view!.panText!, "6759 6498 2")
        
        view!.typeTextIntoPan("6438")
        
        XCTAssertEqual(view!.panText!, "6759 6498 2643 8")
        
        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)
        
        XCTAssertEqual(view!.panText!, "6759 6498 264")
    }
    
    func testFormatsUnknownBrandPan() {
        view!.typeTextIntoPan("12200")
        XCTAssertTrue(view!.imageIs("unknown_card_brand"))
        
        XCTAssertEqual(view!.panText!, "1220 0")
        
        view!.typeTextIntoPan("0000")
        
        XCTAssertEqual(view!.panText!, "1220 0000 0")
        
        view!.typeTextIntoPan("0000")
        
        XCTAssertEqual(view!.panText!, "1220 0000 0000 0")
        
        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)
        
        XCTAssertEqual(view!.panText!, "1220 0000 000")
    }
    
    // MARK: Tests by inserting deleting text
    
    func testCorrectlyFormatsWhenTypingInMiddleOfPan() {
        view!.typeTextIntoPan("4111")
        view!.setPanCaretAtAndTypeIn(position: 3, text: ["4"])
        
        XCTAssertEqual(view!.panText!, "4114 1")
    }
    
    func testCorrectlyFormatsWhenPastingAndTypingInMiddleOfPan() {
        view!.typeTextIntoPan("4111")
        view!.setPanCaretAtAndTypeIn(position: 3, text: ["123", "5"])
        
        XCTAssertEqual(view!.panText!, "4111 2351")
    }
    
    func testCorrectlyFormatsWhenDeletingInMiddleOfPan() {
        view!.typeTextIntoPan("4321 4321")
        view!.setPanCaretAtAndTypeIn(position: 3, text: [backspace])
        
        XCTAssertEqual(view!.panText!, "4314 321")
    }
    
    func testCorrectlyFormatsWhenDeletingAndThenTypingInMiddleOfPan() {
        view!.typeTextIntoPan("4321 4321")
        view!.setPanCaretAtAndTypeIn(position: 3, text: [backspace, backspace, "3", "1234", backspace])
        
        XCTAssertEqual(view!.panText!, "4312 3143 21")
    }
    
    func testCanDeleteSingleDigitAfterSpace() {
        view!.typeTextIntoPan("43214")
        XCTAssertEqual(view!.panText!, "4321 4")
        
        view!.typeTextIntoPan(backspace)
        XCTAssertEqual(view!.panText!, "4321")
        XCTAssertEqual(4, view!.panCaretPosition())
    }
    
    func testCanDeleteFirstDigit() {
        view!.typeTextIntoPan("432145")
        XCTAssertEqual(view!.panText!, "4321 45")
        
        view!.setPanCaretAtAndTypeIn(position: 1, text: [backspace])
        
        XCTAssertEqual(view!.panText!, "3214 5")
        XCTAssertEqual(0, view!.panCaretPosition())
    }
    
    func testReformatsCardWhenBrandChanges() {
        view!.typeTextIntoPan("34567890123")
        XCTAssertEqual(view!.panText!, "3456 789012 3")
        
        view!.setPanCaretAtAndTypeIn(position: 0, text: ["4"])
        XCTAssertEqual(view!.panText!, "4345 6789 0123")
        
        view!.setPanCaretAtAndTypeIn(position: 0, text: ["3"])
        XCTAssertEqual(view!.panText!, "3434 567890 123")
    }
    
    // MARK: Tests with text that contains digits and letters and spaces
    
    func testExtractsDigitsOnlyFromAlphanumericEntry() {
        view!.typeTextIntoPan("123abc456defghi789zzzzzzzzzzz       zzzzzzzzz000")
        
        XCTAssertEqual(view!.panText!, "1234 5678 9000")
    }
    
    // MARK: Tests specific to spaces and caret position
    
    func testDeletesSpaceAndPreviousDigitWhenDeletingSpace() {
        view!.typeTextIntoPan("123456")
        XCTAssertEqual(view!.panText!, "1234 56")
        
        view!.setPanCaretAtAndTypeIn(position: 5, text: [backspace])
        
        XCTAssertEqual(view!.panText!, "1235 6")
        XCTAssertEqual(3, view!.panCaretPosition())
    }
    
    func testDeletesSpaceAndPreviousDigitWhenDeletingSelectedSpace() {
        view!.typeTextIntoPan("123456")
        XCTAssertEqual(view!.panText!, "1234 56")
        
        view!.selectPanAndTypeIn(position: 4, selectionLength: 1, text: [backspace])
        
        XCTAssertEqual(view!.panText!, "1235 6")
        XCTAssertEqual(3, view!.panCaretPosition())
    }
    
    func testMovesCaretAfterSpaceWhenInsertingDigitAtEndOfDigitsGroup() {
        view!.typeTextIntoPan("12345")
        XCTAssertEqual(view!.panText!, "1234 5")
        
        view!.setPanCaretAtAndTypeIn(position: 3, text: ["6"])
        
        XCTAssertEqual(view!.panText!, "1236 45")
        XCTAssertEqual(5, view!.panCaretPosition())
    }
    
    func testLeavesCaretAfterSpaceWhenDeletingDigitWhichIsJustAfterSpace() {
        view!.typeTextIntoPan("123456")
        XCTAssertEqual(view!.panText!, "1234 56")
        
        view!.setPanCaretAtAndTypeIn(position: 6, text: [backspace])
        
        XCTAssertEqual(view!.panText!, "1234 6")
        XCTAssertEqual(5, view!.panCaretPosition())
    }
    
    func testLeavesCaretAtSamePositionWhenSelectingTextThatStartsWithSpaceAndDeletingIt() {
        view!.typeTextIntoPan("123456789012")
        XCTAssertEqual(view!.panText!, "1234 5678 9012")
        
        view!.selectPanAndTypeIn(position: 4, selectionLength: 3, text: [backspace])
        
        XCTAssertEqual(view!.panText!, "1234 7890 12")
        XCTAssertEqual(4, view!.panCaretPosition())
    }
    
    private func waitFor(timeoutInSeconds: Double) {
        let exp = expectation(description: "Waiting for \(timeoutInSeconds)")
        _ = XCTWaiter.wait(for: [exp], timeout: timeoutInSeconds)
    }
}
