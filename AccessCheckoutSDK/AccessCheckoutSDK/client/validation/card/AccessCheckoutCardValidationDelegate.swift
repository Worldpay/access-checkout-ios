/**
 Protocol that should be adopted to be notified of Pan, Expiry Date, Cvc validation state changes as well as CardBrand changes as per detected by the SDK using the PAN entered by the user
 */
public protocol AccessCheckoutCardValidationDelegate {
    /**
     Called whenever the SDK detects that the PAN entered by the user corresponds to a different card brand than the one it is already aware of
     
     - Parameter cardBrand: the card brand which has been identified by the SDK using the PAN entered by the user, or nil if no card brand has been identified
     
     - SeeAlso: CardBrand
     */
    func cardBrandChanged(cardBrand: CardBrand?)
    
    /**
     Called whenever the PAN entered by the user becomes valid or invalid
     
     - Parameter isValid: `Boolean` indicating the validity state
     */
    func panValidChanged(isValid: Bool)
    
    /**
     Called whenever the Expiry Date entered by the user becomes valid or invalid
     
     - Parameter isValid: `Boolean` indicating the validity state
     */
    func expiryDateValidChanged(isValid: Bool)
    
    /**
     Called whenever the Cvc entered by the user becomes valid or invalid
     
     - Parameter isValid: `Boolean` indicating the validity state
     */
    func cvcValidChanged(isValid: Bool)
    
    /**
     Called whenever the PAN, Expiry Date and Cvc are all valid
     */
    func validationSuccess()
}
