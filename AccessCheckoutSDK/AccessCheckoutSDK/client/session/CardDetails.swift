/**
 This struct is a representation of card information that can be constructed with a `CardDetailsBuilder`
 
 - `pan`: an optional `String` containing the PAN
 - `expiryMonth`: an optional `UInt` containing the month part of an expiry date
 - `expiryYear`: an optional `UInt` containing the year part of an expiry date in a 4 digits format
 - `cvc`: an optional `String` containing the cvc
 */
public struct CardDetails {
    let pan: String?
    let expiryMonth: UInt?
    let expiryYear: UInt?
    let cvc: String?
    
    fileprivate init(pan: String?, expiryMonth: UInt?, expiryYear: UInt?, cvc: String?) {
        self.pan = pan
        self.expiryMonth = expiryMonth
        self.expiryYear = expiryYear
        self.cvc = cvc
    }
}

/// This build helps building the `CardDetails` instance
public final class CardDetailsBuilder {
    private let expiryDateValidationPattern = "^((0[1-9])|(1[0-2]))\\/?(\\d{2})$"
    
    private var pan: String?
    private var cvc: String?
    private var expiryDate: String?
    
    public init() {}
    
    /**
     Sets the pan number for the card
     
     - Parameter pan: `String` that represents the pan number
     
     - Returns: the `CardDetailsBuilder` instance in order to chain further operations
     */
    public func pan(_ pan: String) -> CardDetailsBuilder {
        self.pan = pan
        return self
    }
    
    /**
     Sets the expiry month and year for the card
     
     - Parameter expiryDate: `String` that represents the expiry date
     
     - Returns: the `CardDetailsBuilder` instance in order to chain further operations
     */
    public func expiryDate(_ expiryDate: String) -> CardDetailsBuilder {
        self.expiryDate = expiryDate
        return self
    }
    
    /**
     Sets the cvc for the card
     
     - Parameter cvc: `String` that represents the cvc
     
     - Returns: the `CardDetailsBuilder` instance in order to chain further operations
     */
    public func cvc(_ cvc: String) -> CardDetailsBuilder {
        self.cvc = cvc
        return self
    }
    
    /**
     Builds the `CardDetails` instance
     
     - Returns: `CardDetails` instance with the given details
     
     - Throws: `AccessCheckoutIllegalArgumentError` in case where the expiry date is provided in an invalid format
     */
    public func build() throws -> CardDetails {
        if let expiryDateForTest = expiryDate, !expiryDateForTest.isEmpty, !isValidExpiryDate(expiryDateForTest) {
            throw AccessCheckoutIllegalArgumentError.invalidExpiryDateFormat(expiryDate: expiryDateForTest)
        }
        
        return CardDetails(pan: pan,
                           expiryMonth: expiryMonth(of: expiryDate),
                           expiryYear: expiryYearOn4Digits(of: expiryDate),
                           cvc: cvc)
    }
    
    private func expiryMonth(of expiryDate: String?) -> UInt? {
        guard let expiryDate = expiryDate else {
            return nil
        }
        
        return UInt(expiryDate.prefix(2))
    }
    
    private func expiryYearOn4Digits(of expiryDate: String?) -> UInt? {
        guard let expiryDate = expiryDate else {
            return nil
        }
        
        return toFourDigitFormat(UInt(expiryDate.suffix(2)))
    }
    
    private func isValidExpiryDate(_ text: String) -> Bool {
        return text.range(of: expiryDateValidationPattern, options: .regularExpression) != nil
    }
    
    private func toFourDigitFormat(_ number: UInt?) -> UInt? {
        guard let number = number else {
            return nil
        }
        return number < 100 ? number + 2000 : number
    }
}
