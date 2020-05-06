
public struct CardDetails {
    let pan: String?
    let expiryMonth: UInt?
    let expiryYear: UInt?
    let cvv: String?
    
    private init(pan: String?, expiryMonth: UInt?, expiryYear: UInt?, cvv: String?) {
        self.pan = pan
        self.expiryMonth = expiryMonth
        self.expiryYear = expiryYear
        self.cvv = cvv
    }
    
    static func builder() -> CardDetailsBuilder {
        return CardDetailsBuilder()
    }
    
    public class CardDetailsBuilder {
        private var pan: String?
        private var expiryMonth: String?
        private var expiryYear: String?
        private var cvv: String?
        
        fileprivate init() {}
        
        func pan(_ pan: String) -> CardDetailsBuilder {
            self.pan = pan
            return self
        }
        
        func expiryMonth(_ expiryMonth: String) -> CardDetailsBuilder {
            self.expiryMonth = expiryMonth
            return self
        }
        
        func expiryYear(_ expiryYear: String) -> CardDetailsBuilder {
            self.expiryYear = expiryYear
            return self
        }
        
        func cvv(_ cvv: String) -> CardDetailsBuilder {
            self.cvv = cvv
            return self
        }
        
        func build() -> CardDetails {
            return CardDetails(pan: self.pan, expiryMonth: self.toUInt(self.expiryMonth), expiryYear: self.toUInt(self.expiryYear), cvv: self.cvv)
        }
        
        private func toUInt(_ string: String?) -> UInt? {
            guard let string = string else {
                return nil
            }
            
            return UInt(string)
        }
    }
}
