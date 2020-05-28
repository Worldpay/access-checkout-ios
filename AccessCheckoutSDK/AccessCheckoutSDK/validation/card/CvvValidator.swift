struct CvvValidator {
    let lengthValidator = LengthValidator()
    private var cardConfiguration: AccessCardConfiguration
    
    init(cardConfiguration: AccessCardConfiguration) {
        self.cardConfiguration = cardConfiguration
    }
      
    func validate(cvv: CVV?, pan: PAN?) -> Bool {
        guard let cvv = cvv else {
            return false
        }
        var cvvRule: AccessCardConfiguration.CardValidationRule?
        if let pan = pan {
            cvvRule = cardConfiguration.cardBrand(forPAN: pan)?.cvvRule()
        }
        
        let rule =  cvvRule ?? cardConfiguration.defaults.cvv
       
        return lengthValidator.validate(text: cvv, againstValidationRule: rule)
    }
}
