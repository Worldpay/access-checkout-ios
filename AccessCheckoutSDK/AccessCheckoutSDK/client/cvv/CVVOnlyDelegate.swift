public protocol CVVOnlyDelegate : class {
    func handleValidationResult(cvvView: AccessCheckoutView, isValid: Bool)
}
