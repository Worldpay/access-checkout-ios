public protocol AccessCheckoutCvvOnlyValidationDelegate {
    func cvvValidChanged(isValid: Bool)

    func validationSuccess()
}
