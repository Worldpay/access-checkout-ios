class PanTextChangeHandler {
    let panFormatter: PanFormatter
    
    init(panFormattingEnabled: Bool) {
        self.panFormatter = PanFormatter(cardSpacingEnabled: panFormattingEnabled)
    }
    
    func change(originalText: String, textChange: String, usingSelection selection: NSRange, brand: CardBrandModel?) -> String {
        guard let selection = Range(selection, in: originalText) else {
            return originalText
        }
        
        let resultingText = originalText.replacingCharacters(in: selection, with: textChange)
        return panFormatter.format(pan: resultingText, brand: brand)
    }
}
