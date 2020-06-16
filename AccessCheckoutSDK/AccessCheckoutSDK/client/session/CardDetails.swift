
public struct CardDetails {
    let pan: String?
    let expiryMonth: UInt?
    let expiryYear: UInt?
    let cvv: String?
    
    fileprivate init(pan: String?, expiryMonth: UInt?, expiryYear: UInt?, cvv: String?) {
        self.pan = pan
        self.expiryMonth = expiryMonth
        self.expiryYear = expiryYear
        self.cvv = cvv
    }
}

public final class CardDetailsBuilder {
    private let expiryDateValidationPattern = "^((0[1-9])|(1[0-2]))\\/?(\\d{2})$"
    
    private var pan: String?
    private var cvv: String?
    private var expiryDate: String?
    
    public init() {}
    
    public func pan(_ pan: String) -> CardDetailsBuilder {
        self.pan = pan
        return self
    }
    
    public func expiryDate(_ expiryDate: String) -> CardDetailsBuilder {
        self.expiryDate = expiryDate
        return self
    }
    
    public func cvv(_ cvv: String) -> CardDetailsBuilder {
        self.cvv = cvv
        return self
    }
    
    public func build() throws -> CardDetails {
        if let expiryDateForTest = expiryDate, !expiryDateForTest.isEmpty, !isValidExpiryDate(expiryDateForTest) {
            throw AccessCheckoutClientInitialisationError.invalidExpiryDateFormat_message
        }
        
        return CardDetails(pan: pan,
                           expiryMonth: expiryMonth(of: expiryDate),
                           expiryYear: expiryYearOn4Digits(of: expiryDate),
                           cvv: cvv)
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
