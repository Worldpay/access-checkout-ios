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
            throw AccessCheckoutClientInitialisationError.incompleteCardDetails_VTSession_PanIsMandatory
        }
        guard cardDetails.expiryMonth != nil else {
            throw AccessCheckoutClientInitialisationError.incompleteCardDetails_VTSession_ExpiryDateIsMandatory
        }
        guard cardDetails.expiryYear != nil else {
            throw AccessCheckoutClientInitialisationError.incompleteCardDetails_VTSession_ExpiryDateIsMandatory
        }
        guard cardDetails.cvc != nil else {
            throw AccessCheckoutClientInitialisationError.incompleteCardDetails_VTSession_CvcIsMandatory
        }
    }
    
    private func validateForCvcSession(_ cardDetails: CardDetails) throws {
        guard cardDetails.cvc != nil else {
            throw AccessCheckoutClientInitialisationError.incompleteCardDetails_CvcSession_CvcIsMandatory
        }
    }
}
