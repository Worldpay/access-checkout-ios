/// The card expiry date year
public typealias ExpiryYear = String

public extension ExpiryYear {
    /**
     Convert to a 4 digit integer year format. E.g. if year is "19",
     converts to 2019.
     
     - Returns: A 4 digit integer representation upon successful conversion.
     */
    func toFourDigitFormat() -> UInt? {
        if let year = UInt(self) {
            return year < 100 ? year + 2000 : year
        }
        else {
            return nil
        }
    }
}
