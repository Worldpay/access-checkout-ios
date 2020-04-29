
public struct CardDetails {
    let pan: String?
    let expiryMonth: String?
    let expiryYear: String?
    let cvv: String?
    
    private init(pan: String?, expiryMonth: String?, expiryYear: String?, cvv: String?) {
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
        
        fileprivate init() {
            
        }
        
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
            return CardDetails(pan: self.pan, expiryMonth: self.expiryMonth, expiryYear: self.expiryYear, cvv: self.cvv)
        }
    }
}
