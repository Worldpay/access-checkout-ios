public protocol AccessCheckoutCvcOnlyValidationDelegate {
    func cvcValidChanged(isValid: Bool)

    func validationSuccess()
}
