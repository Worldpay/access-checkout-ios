import Foundation

class TextChangeHandler {
    func change(originalText:String?, textChange: String, usingSelection selection:NSRange ) -> String {
        guard let originalText = originalText else {
            return textChange
        }
        guard let selection = Range(selection, in: originalText) else {
            return originalText
        }
        
        return originalText.replacingCharacters(in: selection, with: textChange)
    }
}
