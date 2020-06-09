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
}
