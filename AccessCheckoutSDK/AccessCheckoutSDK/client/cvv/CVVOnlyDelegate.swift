public protocol CVVOnlyDelegate : class {
    func handleValidationResult(cvvView: CardView, isValid: Bool)
}
