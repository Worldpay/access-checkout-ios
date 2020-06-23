class CardDetailsForSessionTypeValidator {
    func validate(cardDetails: CardDetails, for sessionType: SessionType) throws {
        switch sessionType {
            case .verifiedTokens:
                try validateForVerifiedTokensSession(cardDetails)
            case .paymentsCvc:
                try validateForCvcSession(cardDetails)
        }
    }
    
    private func validateForVerifiedTokensSession(_ cardDetails: CardDetails) throws {
        guard cardDetails.pan != nil else {
            throw AccessCheckoutIllegalArgumentError.missingPan()
        }
        guard cardDetails.expiryMonth != nil else {
            throw AccessCheckoutIllegalArgumentError.missingExpiryDate()
        }
        guard cardDetails.expiryYear != nil else {
            throw AccessCheckoutIllegalArgumentError.missingExpiryDate()
        }
        guard cardDetails.cvc != nil else {
            throw AccessCheckoutIllegalArgumentError.missingCvc()
        }
    }
    
    private func validateForCvcSession(_ cardDetails: CardDetails) throws {
        guard cardDetails.cvc != nil else {
            throw AccessCheckoutIllegalArgumentError.missingCvc()
        }
    }
}
