import Foundation

struct ExpiryDateValidationFlow {
    private var expiryDateValidator: ExpiryDateValidator
    private var expiryValidationStateHandler: ExpiryDateValidationStateHandler

    init(_ expiryDateValidator: ExpiryDateValidator, _ expiryValidationStateHandler: ExpiryDateValidationStateHandler) {
        self.expiryDateValidator = expiryDateValidator
        self.expiryValidationStateHandler = expiryValidationStateHandler
    }

    func validate(expiryMonth: ExpiryMonth?, expiryYear: ExpiryYear?) {
        let result = expiryDateValidator.validate(expiryMonth: expiryMonth, expiryYear: expiryYear)
        expiryValidationStateHandler.handleExpiryDateValidation(isValid: result)
    }
}
