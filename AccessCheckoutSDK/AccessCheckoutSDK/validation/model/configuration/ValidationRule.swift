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
        
        if let matcher = matcher, matcher.regexMatches(text: text) == false {
            return false
        }
        
        if validLengths.isEmpty {
            return true
        }
        return validLengths.contains(text.count)
    }
    
    func textIsMatched(_ text: String) -> Bool {
        guard !text.isEmpty else {
            return false
        }
        
        if let matcher = matcher, !matcher.isEmpty {
            return matcher.regexMatches(text: text)
        } else {
            return false
        }
    }
    
    func textIsShorterOrAsLongAsMaxLength(_ text: String) -> Bool {
        guard let maxLength = validLengths.max() else {
            return true
        }
        
        return text.count <= maxLength
    }
}
