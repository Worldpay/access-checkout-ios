import Foundation

struct ValidationRule {
    let matcher: String?
    let validLengths: [Int]
    
    init(matcher: String?, validLengths: [Int]) {
        self.matcher = matcher
        self.validLengths = validLengths
    }
    
    func validate(text: String) -> Bool {
        guard !text.isEmpty else {
            return false
        }
        
        if let matcher = matcher, regexMatches(regExPattern: matcher, text: text) == false {
            return false
        }
        
        if validLengths.isEmpty {
            return true
        }
        
        return validLengths.contains(text.count)
    }
    
    func textIsMatched(_ text: String) -> Bool {
        guard let matcher = matcher else {
            return true
        }
        
        return regexMatches(regExPattern: matcher, text: text)
    }
    
    func textIsShorterOrAsLongAsMaxLength(_ text: String) -> Bool {
        guard let maxLength = validLengths.max() else {
            return true
        }
        
        return text.count <= maxLength
    }
    
    private func regexMatches(regExPattern: String, text: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: regExPattern) else {
            return false
        }
        return regex.firstMatch(in: text, range: NSRange(location: 0, length: text.count)) != nil
    }
}
