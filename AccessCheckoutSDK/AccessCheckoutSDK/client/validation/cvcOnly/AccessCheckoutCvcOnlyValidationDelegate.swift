/// Protocol that should be adopted to be notified of Cvc validation state changes
public protocol AccessCheckoutCvcOnlyValidationDelegate {
    /**
     Called whenever the Cvc entered by the user becomes valid or invalid
    
     - Parameter isValid: `Boolean` indicating the validity state
     */
    func cvcValidChanged(isValid: Bool)

    /**
    Called whenever the Cvc becomes valid
    */
    func validationSuccess()
}
