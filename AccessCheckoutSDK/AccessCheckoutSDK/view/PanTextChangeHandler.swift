import Foundation

class PanTextChangeHandler {
    private let panFormatter: PanFormatter
    private let panValidator: PanValidator
    
    init(_ panValidator: PanValidator, panFormattingEnabled: Bool) {
        self.panFormatter = PanFormatter(cardSpacingEnabled: panFormattingEnabled)
        self.panValidator = panValidator
    }
    
    func change(originalText: String, textChange: String, usingSelection selection: NSRange) -> String {
        guard let selection = Range(selection, in: originalText) else {
            return originalText
        }
        
        let resultingText = stripWhiteSpaces(from: originalText.replacingCharacters(in: selection, with: textChange))
        let validationResult = panValidator.validate(pan: resultingText)
        let maxLengthAllowed = (validationResult.cardBrand?.panValidationRule.validLengths.max() ?? ValidationRulesDefaults.instance().pan.validLengths.max())!
        
        let textCutToMaxLength = resultingText.count <= maxLengthAllowed ? resultingText : left(nCharacters: maxLengthAllowed, of: resultingText)
        
        return panFormatter.format(pan: textCutToMaxLength, brand: validationResult.cardBrand)
    }
    
    private func left(nCharacters: Int, of text: String) -> String {
        let start = text.index(text.startIndex, offsetBy: 0)
        let end = text.index(text.startIndex, offsetBy: nCharacters)
        return String(text[start..<end])
    }
    
    private func stripWhiteSpaces(from pan: String) -> String {
        return pan.replacingOccurrences(of: " ", with: "")
    }
}
