class PanTextChangeHandler {
    
    let panFormatter: PanFormatter
    
    init(disableFormatting: Bool) {
        self.panFormatter = PanFormatter(disableFormatting: disableFormatting)
    }
    
    func change(originalText:String?, textChange: String, usingSelection selection:NSRange, brand: CardBrandModel?) -> String {
        guard let originalText = originalText else {
            return textChange
        }
        guard let selection = Range(selection, in: originalText) else {
            return originalText
        }
        
        let resultingText = originalText.replacingCharacters(in: selection, with: textChange)
        return panFormatter.format(pan: resultingText, brand: brand)
    }
}
