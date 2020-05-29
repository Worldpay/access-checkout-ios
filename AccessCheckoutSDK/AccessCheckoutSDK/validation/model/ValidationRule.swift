class ValidationRule {
    let matcher:String?
    let validLengths:[Int]
    
    init(matcher:String?, validLengths:[Int]) {
        self.matcher = matcher
        self.validLengths = validLengths
    }
}
