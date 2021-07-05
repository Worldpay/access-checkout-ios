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
        
        let resultingText = originalText.replacingCharacters(in: selection, with: textChange)
        let validationResult = panValidator.validate(pan: resultingText)
        
        return panFormatter.format(pan: resultingText, brand: validationResult.cardBrand)
    }
}
