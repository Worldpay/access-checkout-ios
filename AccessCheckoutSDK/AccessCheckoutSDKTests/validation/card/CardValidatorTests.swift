import XCTest
@testable import AccessCheckoutSDK

class CardValidatorTests: XCTestCase {
    
    private let yearDateFormatter = DateFormatter()
    private let monthDateFormatter = DateFormatter()
    private let emptyCardValidationRule = CardConfiguration.CardValidationRule(matcher: nil,
                                                                               validLengths: [])
    
    
    override func setUp() {
    }
    
    func testCardDefaults_base() {
        let panRule = CardConfiguration.CardValidationRule(
            matcher: nil,
            validLengths: [4,5, 10]
        )
        let baseDefaults = CardConfiguration.CardDefaults(pan: panRule,
                                                          cvv: nil,
                                                          month: nil,
                                                          year: nil)
        let cardValidator = AccessCheckoutCardValidator(cardDefaults: baseDefaults)
        let result1 = cardValidator.validate(pan: "411")
        XCTAssertTrue(result1.valid.partial)
        XCTAssertFalse(result1.valid.complete)
        
        let result2 = cardValidator.validate(pan: "41111") // Valid luhn
        XCTAssertTrue(result2.valid.partial)
        XCTAssertTrue(result2.valid.complete)
    }
    
    func testCardDefaults_overrideBase() {
        // Set base defaults
        let panRule1 = CardConfiguration.CardValidationRule(matcher: nil,
                                                           validLengths: [4,6])
        let baseDefaults = CardConfiguration.CardDefaults(pan: panRule1,
                                                          cvv: nil,
                                                          month: nil,
                                                          year: nil)
        let cardValidator = AccessCheckoutCardValidator(cardDefaults: baseDefaults)
        
        // Set a cardConfiguration to override base defaults
        let panRule2 = CardConfiguration.CardValidationRule(matcher: nil,
                                                           validLengths: [8, 10])
        let cardDefaults = CardConfiguration.CardDefaults(pan: panRule2, cvv: nil, month: nil, year: nil)
        cardValidator.cardConfiguration = CardConfiguration(defaults: cardDefaults, brands: nil)
        
        let result1 = cardValidator.validate(pan: "41111") // Valid luhn
        XCTAssertTrue(result1.valid.partial)
        XCTAssertFalse(result1.valid.complete)
        
        let result2 = cardValidator.validate(pan: "41111113") // Valid luhn
        XCTAssertTrue(result2.valid.partial)
        XCTAssertTrue(result2.valid.complete)
    }
    
    func testValidatePAN_empty_noConfiguration() {
        let cardValidator = AccessCheckoutCardValidator()
        let valid = cardValidator.validate(pan: "").valid
        XCTAssertTrue(valid.partial)
        XCTAssertFalse(valid.complete)
    }
    
    func testValidatePAN_noConfiguration_alpha() {
        let cardValidator = AccessCheckoutCardValidator()
        let valid = cardValidator.validate(pan: "ABC").valid
        XCTAssertFalse(valid.partial)
        XCTAssertFalse(valid.complete)
    }
    
    func testCanUpdatePAN_noConfiguration_alpha() {
        let text = "ABCD"
        let cardValidator = AccessCheckoutCardValidator()
        XCTAssertFalse(cardValidator.canUpdate(pan: "",
                                               withText: text,
                                               inRange: NSRange(location: 0, length: text.count)))
    }
    
    func testCanUpdatePAN_success() {
        let text = "1"
        let panRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,19}$",
                                                         validLengths: [16])
        let defaults = CardConfiguration.CardDefaults(pan: panRule,
                                                      cvv: nil,
                                                      month: nil,
                                                      year: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        XCTAssertTrue(cardValidator.canUpdate(pan: "4000",
                                              withText: text,
                                              inRange: NSRange(location: 1, length: text.count)))
    }
    
    func testCanUpdatePAN_nil() {
        let panRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,19}$",
                                                          validLengths: [16])
        let defaults = CardConfiguration.CardDefaults(pan: panRule,
                                                      cvv: nil,
                                                      month: nil,
                                                      year: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        XCTAssertTrue(cardValidator.canUpdate(pan: nil,
                                              withText: "1",
                                              inRange: NSRange(location: 0, length: 0)))
    }
    
    func testCanUpdatePAN_alpha() {
        let text = "ABC"
        let panRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,19}$",
                                                          validLengths: [16])
        let defaults = CardConfiguration.CardDefaults(pan: panRule,
                                                      cvv: nil,
                                                      month: nil,
                                                      year: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let canUpdate = cardValidator.canUpdate(pan: "",
                                                withText: text,
                                                inRange: NSRange(location: 0, length: text.count))
        XCTAssertFalse(canUpdate)
    }
    
    func testCanUpdatePAN_delete() {
        let text = ""
        let panRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,19}$",
                                                          validLengths: [16])
        let defaults = CardConfiguration.CardDefaults(pan: panRule,
                                                      cvv: nil,
                                                      month: nil,
                                                      year: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let canUpdate = cardValidator.canUpdate(pan: "4",
                                                withText: text,
                                                inRange: NSRange(location: 1, length: 1))
        XCTAssertTrue(canUpdate)
    }
    
    func testValidatePAN_badMatcher() {
        let panRule = CardConfiguration.CardValidationRule(matcher: "", validLengths: [])
        let defaults = CardConfiguration.CardDefaults(pan: panRule,
                                                      cvv: nil,
                                                      month: nil,
                                                      year: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let valid = cardValidator.validate(pan: "1234").valid
        XCTAssertFalse(valid.partial)
        XCTAssertFalse(valid.complete)
    }
    
    func testValidatePAN_invalidLength() {
        let panRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,19}$",
                                                           validLengths: [16])
        let defaults = CardConfiguration.CardDefaults(pan: panRule,
                                                      cvv: nil,
                                                      month: nil,
                                                      year: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let valid = cardValidator.validate(pan: "1234").valid
        XCTAssertTrue(valid.partial)
        XCTAssertFalse(valid.complete)
    }
    
    func testValidatePAN_validLength() {
        let invalidPan = "4111111111111112"
        let panRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,19}$",
                                                           validLengths: [16])
        let defaults = CardConfiguration.CardDefaults(pan: panRule,
                                                      cvv: nil,
                                                      month: nil,
                                                      year: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let valid = cardValidator.validate(pan: invalidPan).valid
        XCTAssertFalse(valid.partial)
        XCTAssertFalse(valid.complete)
    }
    
    func testValidatePAN_matcher_alpha() {
        let panRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,19}$",
                                                           validLengths: [])
        let defaults = CardConfiguration.CardDefaults(pan: panRule,
                                                      cvv: nil,
                                                      month: nil,
                                                      year: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let valid = cardValidator.validate(pan: "ABC").valid
        XCTAssertFalse(valid.partial)
        XCTAssertFalse(valid.complete)
    }
    
    func testValidatePANBrand_single(){
        let cardBrand = CardConfiguration.CardBrand(name: "test", images: nil, matcher: "^\\d{0,4}$", cvv: nil, pans: [4])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: nil,
                                                      year: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = CardConfiguration(defaults: defaults, brands: [cardBrand])
        XCTAssertNotNil(cardValidator.validate(pan: "123").brand)
        XCTAssertNil(cardValidator.validate(pan: "12345678").brand)
    }
    
    func testValidatePANBrand_multiple(){

        let cardBrand1 = CardConfiguration.CardBrand(name: "brand1", images: nil, matcher: "^4\\d{0,15}", cvv: nil, pans: [16])
        let cardBrand2 = CardConfiguration.CardBrand(name: "brand2", images: nil, matcher: "^5\\d{0,15}", cvv: nil, pans: [16])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: nil,
                                                      year: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = CardConfiguration(defaults: defaults,
                                                            brands: [cardBrand1, cardBrand2])
        XCTAssertEqual(cardValidator.validate(pan: "4").brand, cardBrand1)
        XCTAssertEqual(cardValidator.validate(pan: "5").brand, cardBrand2)
    }
    
    func testValidatePANBrand_multiple_unknown(){

        let cardBrand1 = CardConfiguration.CardBrand(name: "brand1", images: nil, matcher: "^4\\d{0,15}", cvv: nil, pans: [16])
        let cardBrand2 = CardConfiguration.CardBrand(name: "brand2", images: nil, matcher: "^5\\d{0,15}", cvv: nil, pans: [16])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: nil,
                                                      year: nil)
        let cardConfiguration = CardConfiguration(defaults: defaults,
                                                  brands: [cardBrand1, cardBrand2])
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        XCTAssertNil(cardValidator.validate(pan: "6").brand)
    }

    func testValidatePANBrand_matcherAmex() {
        let validPan = "340000000000009"
        let cardBrand = CardConfiguration.CardBrand(name: "amex", images: nil, matcher: "^3[47]\\d{0,13}$", cvv: nil, pans: [15])
        let cardConfiguration = CardConfiguration(defaults: nil,
                                                  brands: [cardBrand])
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        let result = cardValidator.validate(pan: validPan)
        XCTAssertEqual(result.brand, cardBrand)
        XCTAssertTrue(result.valid.partial)
        XCTAssertTrue(result.valid.complete)
    }

    func testValidatePANBrand_matcherAmex_tooLong() {
        let validPan = "3400000000000091"

        let cardBrand = CardConfiguration.CardBrand(name: "amex", images: nil, matcher: "^3[47]\\d{0,13}$", cvv: nil, pans: [15])
        let cardConfiguration = CardConfiguration(defaults: nil,
                                                  brands: [cardBrand])
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        let result = cardValidator.validate(pan: validPan)
        XCTAssertNil(result.brand)
        XCTAssertTrue(result.valid.partial)
        XCTAssertTrue(result.valid.complete)
    }

    func testValidatePAN_goodLuhn() {
        let pans = ["4111111111111111", // Visa
            "5000111122223336", // Mastercard
            "340011112222332", // Amex
            "370011112222335", // Amex
            "0000000000000000",
            "0000000000000000000"]
        let cardValidator = AccessCheckoutCardValidator()
        pans.map { cardValidator.validate(pan: $0).valid }.forEach { valid in
            XCTAssertTrue(valid.partial)
            XCTAssertTrue(valid.complete)
        }
    }

    func testValidatePAN_badLuhn() {
        let invalidPan = "456756789654"
        let cardValidator = AccessCheckoutCardValidator()
        let valid = cardValidator.validate(pan: invalidPan).valid
        XCTAssertTrue(valid.partial)
        XCTAssertFalse(valid.complete)
    }


 //   CVV defaults

    func testCanUpdateCVV_noConfiguration_alpha() {
        let text = "A"
        let cardValidator = AccessCheckoutCardValidator()
        XCTAssertFalse(cardValidator.canUpdate(cvv: "",
                                               withPAN: nil,
                                               withText: text,
                                               inRange: NSRange(location: 0, length: text.count)))
    }

    func testCanUpdateCVV_success() {
        let text = "123"
        let cvvRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,4}$",
                                                           validLengths: [4])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: cvvRule,
                                                      month: nil,
                                                      year: nil)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        XCTAssertTrue(cardValidator.canUpdate(cvv: "",
                                              withPAN: nil,
                                              withText: text,
                                              inRange: NSRange(location: 0, length: text.count)))
    }

    func testCanUpdateCVV_alpha() {
        let text = "ABC"
        let cvvRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,4}$",
                                                          validLengths: [4])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: cvvRule,
                                                      month: nil,
                                                      year: nil)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        let canUpdate = cardValidator.canUpdate(cvv: "",
                                                withPAN: nil,
                                                withText: text,
                                                inRange: NSRange(location: 0, length: text.count))
        XCTAssertFalse(canUpdate)
    }

    func testCanUpdateCVV_delete() {
        let text = ""
        let cvvRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,4}$",
                                                           validLengths: [4])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: cvvRule,
                                                      month: nil,
                                                      year: nil)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        let canUpdate = cardValidator.canUpdate(cvv: "123",
                                                withPAN: nil,
                                                withText: text,
                                                inRange: NSRange(location: 2, length: 1))
        XCTAssertTrue(canUpdate)
    }

    func testCanUpdateCVV_withPAN_defaultSuccess() {
        let text = "1"
        let cvvRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,4}$",
                                                           validLengths: [4])
        let panRule = CardConfiguration.CardValidationRule(matcher: "^4\\d{0,15}",
                                                           validLengths: [16])
        let defaults = CardConfiguration.CardDefaults(pan: panRule,
                                                      cvv: cvvRule,
                                                      month: nil,
                                                      year: nil)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        let canUpdate = cardValidator.canUpdate(cvv: "12",
                                                withPAN: "4000",
                                                withText: text,
                                                inRange: NSRange(location: 2, length: text.count))
        XCTAssertTrue(canUpdate)
    }

    func testCanUpdateCVV_withPAN_brandSuccess() {
        let text = "1"
        let cardBrand = CardConfiguration.CardBrand(name: "", images: nil, matcher: "^4\\d{0,15}", cvv: 4, pans: [16])
        let cardConfiguration = CardConfiguration(defaults: nil, brands: [cardBrand])
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        let canUpdate = cardValidator.canUpdate(cvv: "12",
                                                withPAN: "4000",
                                                withText: text,
                                                inRange: NSRange(location: 2, length: text.count))
        XCTAssertTrue(canUpdate)
    }

    func testCanUpdateCVV_withPAN_fail() {
        let text = "1"
        let cardBrand = CardConfiguration.CardBrand(name: "", images: nil, matcher: "^4\\d{0,15}", cvv: 4, pans: [16])
        let cardConfiguration = CardConfiguration(defaults: nil, brands: [cardBrand])
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        let canUpdate = cardValidator.canUpdate(cvv: "1234",
                                                withPAN: "4000",
                                                withText: text,
                                                inRange: NSRange(location: 4, length: 0))
        XCTAssertFalse(canUpdate)
    }

    func testValidateCVVDefaults_minLength(){
        let cvv = "12345"
        let cvvRule = CardConfiguration.CardValidationRule(matcher: nil,
                                                           validLengths: [5,6])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: cvvRule,
                                                      month: nil,
                                                      year: nil)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        XCTAssertTrue(cardValidator.validate(cvv: cvv, withPAN: nil).partial)
        XCTAssertTrue(cardValidator.validate(cvv: cvv, withPAN: nil).complete)
    }

    func testValidateCVVDefaults_maxLength(){
        let cvv = "1"
        let cvvRule = CardConfiguration.CardValidationRule(matcher: nil,
                                                           validLengths: [3,4])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: cvvRule,
                                                      month: nil,
                                                      year: nil)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        XCTAssertTrue(cardValidator.validate(cvv: cvv, withPAN: nil).partial)
        XCTAssertFalse(cardValidator.validate(cvv: cvv, withPAN: nil).complete)
    }

    func testValidateCVVDefaults_minLength_tooLow(){
        let cvv = "1"
        let cvvRule = CardConfiguration.CardValidationRule(matcher: nil,
                                                          validLengths: [3])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: cvvRule,
                                                      month: nil,
                                                      year: nil)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        XCTAssertTrue(cardValidator.validate(cvv: cvv, withPAN: nil).partial)
        XCTAssertFalse(cardValidator.validate(cvv: cvv, withPAN: nil).complete)
    }

    func testValidateCVVDefaults_minLength_lowerBound(){
        let cvv = "12345"
        let cvvRule = CardConfiguration.CardValidationRule(matcher: nil,
                                                           validLengths: [5,6])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: cvvRule,
                                                      month: nil,
                                                      year: nil)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        XCTAssertTrue(cardValidator.validate(cvv: cvv, withPAN: nil).partial)
        XCTAssertTrue(cardValidator.validate(cvv: cvv, withPAN: nil).complete)
    }

    func testValidateCVVDefaults_tooHigh(){
        let cvv = "12345"
        let cvvRule = CardConfiguration.CardValidationRule(matcher: nil,
                                                           validLengths: [2, 4])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: cvvRule,
                                                      month: nil,
                                                      year: nil)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        XCTAssertFalse(cardValidator.validate(cvv: cvv, withPAN: nil).partial)
        XCTAssertFalse(cardValidator.validate(cvv: cvv, withPAN: nil).complete)
    }

    func testValidateCVVDefaults_upperBound(){
        let cvv = "12"
        let cvvRule = CardConfiguration.CardValidationRule(matcher: nil,
                                                           validLengths: [2,5])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: cvvRule,
                                                      month: nil,
                                                      year: nil)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        XCTAssertTrue(cardValidator.validate(cvv: cvv, withPAN: nil).partial)
        XCTAssertTrue(cardValidator.validate(cvv: cvv, withPAN: nil).complete)
    }

    func testValidateCVV_noConfiguration() {
        let cvv = "123"
        let cardValidator = AccessCheckoutCardValidator()
        XCTAssertTrue(cardValidator.validate(cvv: cvv, withPAN: nil).partial)
        XCTAssertTrue(cardValidator.validate(cvv: cvv, withPAN: nil).complete)
    }


    func testValidateCVV_noConfiguration_alpha() {
        let cvv = "A"
        let cardValidator = AccessCheckoutCardValidator()
        XCTAssertFalse(cardValidator.validate(cvv: cvv, withPAN: nil).partial)
        XCTAssertFalse(cardValidator.validate(cvv: cvv, withPAN: nil).complete)
    }

    func testValidateCVVDefaults_empty() {
        let cvv = ""
        let cardValidator = AccessCheckoutCardValidator()
        XCTAssertTrue(cardValidator.validate(cvv: cvv, withPAN: nil).partial)
        XCTAssertFalse(cardValidator.validate(cvv: cvv, withPAN: nil).complete)
    }

    func testValidateCVVBrand_validLength() {
        let cvv = "1234"
        let pan = "43214321"
        let cvvRule = CardConfiguration.CardValidationRule(matcher: nil,
                                                           validLengths: [cvv.count])

        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: cvvRule,
                                                      month: nil,
                                                      year: nil)
        let cardBrand = CardConfiguration.CardBrand(name: "", images: nil, matcher: "^\\d{0,19}$", cvv: cvv.count, pans: [3, pan.count, 16])
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: [cardBrand])
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        XCTAssertTrue(cardValidator.validate(cvv: cvv, withPAN: pan).partial)
        XCTAssertTrue(cardValidator.validate(cvv: cvv, withPAN: pan).complete)
    }

    func testValidateCVVBrand_invalidLength() {
        let cvv = "1234"
        let pan = "43214321"

        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: nil,
                                                      year: nil)
        let cardBrand = CardConfiguration.CardBrand(name: "", images: nil, matcher: "^\\d{0,19}$", cvv: cvv.count - 1, pans: [pan.count])
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: [cardBrand])
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        XCTAssertFalse(cardValidator.validate(cvv: cvv, withPAN: pan).partial)
        XCTAssertFalse(cardValidator.validate(cvv: cvv, withPAN: pan).complete)
    }

    // MARK: Expiry month

    func testCanUpdateExpiryMonth_nil() {
        let cardValidator = AccessCheckoutCardValidator()
        XCTAssertTrue(cardValidator.canUpdate(expiryMonth: nil,
                                              withText: "1",
                                              inRange: NSRange(location: 0, length: 0)))
    }

    func testCanUpdateExpiryMonth_noConfiguration_alpha() {
        let text = "A"
        let cardValidator = AccessCheckoutCardValidator()
        XCTAssertFalse(cardValidator.canUpdate(expiryMonth: "",
                                               withText: text,
                                               inRange: NSRange(location: 0, length: text.count)))
    }

    func testCanUpdateExpiryMonth_success() {
        let text = "1"
        let monthRule = CardConfiguration.CardValidationRule(matcher: "^0[1-9]{0,1}$|^1[0-2]{0,1}$",
                                                            validLengths: [1,2])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: monthRule,
                                                      year: nil)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        XCTAssertTrue(cardValidator.canUpdate(expiryMonth: "12",
                                              withText: text,
                                              inRange: NSRange(location: 1, length: text.count)))
    }

    func testCanUpdateExpiryMonth_maxDigits() {
        let text = "123"
        let monthRule = CardConfiguration.CardValidationRule(matcher: "^0[1-9]{0,1}$|^1[0-2]{0,1}$",
                                                             validLengths: [1,2])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: monthRule,
                                                      year: nil)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        XCTAssertFalse(cardValidator.canUpdate(expiryMonth: "",
                                               withText: text,
                                               inRange: NSRange(location: 0, length: text.count)))
    }

    func testCanUpdateExpiryMonth_alpha() {
        let text = "ABC"
        let monthRule = CardConfiguration.CardValidationRule(matcher: "^0[1-9]{0,1}$|^1[0-2]{0,1}$",
                                                             validLengths: [1,2])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: monthRule,
                                                      year: nil)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        XCTAssertFalse(cardValidator.canUpdate(expiryMonth: "",
                                               withText: text,
                                               inRange: NSRange(location: 0, length: text.count)))
    }

    func testCanUpdateExpiryMonth_delete() {
        let monthRule = CardConfiguration.CardValidationRule(matcher: "^0[1-9]{0,1}$|^1[0-2]{0,1}$",
                                                             validLengths: [1,2])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: monthRule,
                                                      year: nil)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        XCTAssertTrue(cardValidator.canUpdate(expiryMonth: "1",
                                              withText: "",
                                              inRange: NSRange(location: 0, length: 1)))
    }

    func testValidateExpiryMonth_noConfiguration() {
        let cardValidator = AccessCheckoutCardValidator()
        let valid = cardValidator.validate(month: "01", year: nil, target: Date())
        XCTAssertTrue(valid.partial)
        XCTAssertTrue(valid.complete)
    }

    func testValidateExpiryMonth_noConfiguration_alpha() {
        let cardValidator = AccessCheckoutCardValidator()
        let valid = cardValidator.validate(month: "A", year: nil, target: Date())
        XCTAssertFalse(valid.partial)
        XCTAssertFalse(valid.complete)
    }

    func testValidateExpiryMonth_empty() {
        let monthRule = CardConfiguration.CardValidationRule(matcher: "^0[1-9]{0,1}$|^1[0-2]{0,1}$", validLengths: [2])

        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: monthRule,
                                                      year: nil)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        let valid = cardValidator.validate(month: "", year: nil, target: Date())
        XCTAssertTrue(valid.partial)
        XCTAssertFalse(valid.complete)
    }

    func testValidateExpiryMonth_alpha() {
        let monthRule = CardConfiguration.CardValidationRule(matcher: "^0[1-9]{0,1}$|^1[0-2]{0,1}$", validLengths: [2])

        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: monthRule,
                                                      year: nil)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        let valid = cardValidator.validate(month: "A", year: nil, target: Date())
        XCTAssertFalse(valid.partial)
        XCTAssertFalse(valid.complete)
    }

    func testValidateExpiryMonth_matcherValid() {
        let monthRule = CardConfiguration.CardValidationRule(matcher: "^0[1-9]{0,1}$|^1[0-2]{0,1}$",
                                                             validLengths: [])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: monthRule,
                                                      year: nil)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        let valid = cardValidator.validate(month: "01", year: nil, target: Date())
        XCTAssertTrue(valid.partial)
        XCTAssertTrue(valid.complete)
    }

    func testValidateExpiryMonth_matcherInvalid() {
        let monthRule = CardConfiguration.CardValidationRule(matcher: "^0[1-9]{0,1}$|^1[0-2]{0,1}$", validLengths: [])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: monthRule,
                                                      year: nil)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        let valid = cardValidator.validate(month: "21", year: nil, target: Date())
        XCTAssertFalse(valid.partial)
        XCTAssertFalse(valid.complete)
    }

    func testValidateExpiryMonth_singleDigit() {
        let monthRule = CardConfiguration.CardValidationRule(matcher: "^0[1-9]{0,1}$|^1[0-2]{0,1}$", validLengths: [])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: monthRule,
                                                      year: nil)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        let valid = cardValidator.validate(month: "1", year: nil, target: Date())
        XCTAssertTrue(valid.partial)
        XCTAssertTrue(valid.complete)
    }

    func testValidateExpiryMonth_zero() {
        let monthRule = CardConfiguration.CardValidationRule(matcher: "^0[1-9]{0,1}$|^1[0-2]{0,1}$", validLengths: [2])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: monthRule,
                                                      year: nil)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        let valid = cardValidator.validate(month: "0", year: nil, target: Date())
        XCTAssertTrue(valid.partial)
        XCTAssertFalse(valid.complete)
    }

    func testValidateExpiry_monthZero_validYear() {
        let monthRule = CardConfiguration.CardValidationRule(matcher: "^0[1-9]{0,1}$|^1[0-2]{0,1}$", validLengths: [2])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: monthRule,
                                                      year: nil)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        let valid = cardValidator.validate(month: "0", year: "99", target: Date())
        XCTAssertTrue(valid.partial)
        XCTAssertFalse(valid.complete)
    }

    func testValidateExpiryMonth_tooLong() {
        let monthRule = CardConfiguration.CardValidationRule(matcher: "^0[1-9]{0,1}$|^1[0-2]{0,1}$", validLengths: [2])

        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: monthRule,
                                                      year: nil)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        let valid = cardValidator.validate(month: "123", year: nil, target: Date())
        XCTAssertFalse(valid.partial)
        XCTAssertFalse(valid.complete)
    }

    func testValidateExpiryMonth_zeroZero() {
        let monthRule = CardConfiguration.CardValidationRule(matcher: "^0[1-9]{0,1}$|^1[0-2]{0,1}$",
                                                            validLengths: [])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: monthRule,
                                                      year: nil)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        let valid = cardValidator.validate(month: "00", year: nil, target: Date())
        XCTAssertFalse(valid.partial)
        XCTAssertFalse(valid.complete)
    }

    // MARK: Expiry year

    func testCanUpdateExpiryYear_nil() {
        let cardValidator = AccessCheckoutCardValidator()
        XCTAssertTrue(cardValidator.canUpdate(expiryYear: nil,
                                              withText: "1",
                                              inRange: NSRange(location: 0, length: 0)))
    }

    func testCanUpdateExpiryYear_noConfiguration_alpha() {
        let text = "A"
        let cardValidator = AccessCheckoutCardValidator()
        XCTAssertFalse(cardValidator.canUpdate(expiryMonth: "",
                                               withText: text,
                                               inRange: NSRange(location: 0, length: text.count)))
    }

    func testCanUpdateExpiryYear_success() {
        let text = "1"
        let yearRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,2}$",
                                                            validLengths: [2])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: nil,
                                                      year: yearRule)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        XCTAssertTrue(cardValidator.canUpdate(expiryYear: "12",
                                              withText: text,
                                              inRange: NSRange(location: 1, length: text.count)))
    }

    func testCanUpdateExpiryYear_maxDigits() {
        let text = "123"
        let yearRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,2}$",
                                                            validLengths: [2])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: nil,
                                                      year: yearRule)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        XCTAssertFalse(cardValidator.canUpdate(expiryYear: "",
                                               withText: text,
                                               inRange: NSRange(location: 0, length: text.count)))
    }

    func testCanUpdateExpiryYear_alpha() {
        let text = "ABC"
        let yearRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,2}$",
                                                            validLengths: [2])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: nil,
                                                      year: yearRule)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        XCTAssertFalse(cardValidator.canUpdate(expiryYear: "",
                                               withText: text,
                                               inRange: NSRange(location: 0, length: text.count)))
    }

    func testCanUpdateExpiryYear_delete() {
        let yearRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,2}$",
                                                            validLengths: [2])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: nil,
                                                      year: yearRule)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        XCTAssertTrue(cardValidator.canUpdate(expiryYear: "1",
                                              withText: "",
                                              inRange: NSRange(location: 0, length: 1)))
    }

    func testValidateExpiryYear_noConfiguration() {
        let cardValidator = AccessCheckoutCardValidator()
        let valid = cardValidator.validate(month: nil, year: "99", target: Date())
        XCTAssertTrue(valid.partial)
        XCTAssertFalse(valid.complete)
    }

    func testValidateExpiryYear_alpha_noConfiguration() {
        let cardValidator = AccessCheckoutCardValidator()
        let valid = cardValidator.validate(month: nil, year: "A", target: Date())
        XCTAssertFalse(valid.partial)
        XCTAssertFalse(valid.complete)
    }

    func testValidateExpiryYear_empty() {
        let yearRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,2}$",
                                                            validLengths: [2])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: nil,
                                                      year: yearRule)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        let valid = cardValidator.validate(month: nil, year: "", target: Date())
        XCTAssertTrue(valid.partial)
        XCTAssertFalse(valid.complete)
    }

    func testValidateExpiryYear_alpha() {
        let yearRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,2}$",
                                                           validLengths: [2])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: nil,
                                                      year: yearRule)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        let valid = cardValidator.validate(month: nil, year: "A", target: Date())
        XCTAssertFalse(valid.partial)
        XCTAssertFalse(valid.complete)
    }

    func testValidateExpiryYear_1digit() {
        let yearRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,2}$",
                                                            validLengths: [2])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: nil,
                                                      year: yearRule)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        let valid = cardValidator.validate(month: nil, year: "2", target: Date())
        XCTAssertTrue(valid.partial)
        XCTAssertFalse(valid.complete)
    }

    func testValidateExpiryYear_tooManyDigits() {
        let yearRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,2}$",
                                                            validLengths: [2])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: nil,
                                                      year: yearRule)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        let valid = cardValidator.validate(month: nil, year: "2525", target: Date())
        XCTAssertFalse(valid.partial)
        XCTAssertFalse(valid.complete)
    }

    func testValidateExpiryYear_future() {
        let yearRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,2}$",
                                                           validLengths: [2])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: nil,
                                                      year: yearRule)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)

        let targetDate = Date()
        guard let futureDate = Calendar.current.date(byAdding: .year, value: 1, to: targetDate) else {
            XCTFail()
            return
        }
        yearDateFormatter.dateFormat = "yy"
        let futureYear = yearDateFormatter.string(from: futureDate)

        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        let valid = cardValidator.validate(month: nil, year: futureYear, target: targetDate)
        XCTAssertTrue(valid.partial)
        XCTAssertFalse(valid.complete)
    }

    func testValidateExpiryYear_sameYear() {
        let yearRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,2}$",
                                                           validLengths: [2])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: nil,
                                                      year: yearRule)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)

        let targetDate = Date()
        yearDateFormatter.dateFormat = "yy"
        let sameYear = yearDateFormatter.string(from: targetDate)

        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        let valid = cardValidator.validate(month: nil, year: sameYear, target: targetDate)
        XCTAssertTrue(valid.partial)
        XCTAssertFalse(valid.complete)
    }

    func testValidateExpiryYear_past() {
        let yearRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,2}$",
                                                            validLengths: [2])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: nil,
                                                      year: yearRule)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)

        let targetDate = Date()
        guard let pastDate = Calendar.current.date(byAdding: .year, value: -1, to: targetDate) else {
            XCTFail()
            return
        }
        yearDateFormatter.dateFormat = "yy"
        let pastYear = yearDateFormatter.string(from: pastDate)

        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        let valid = cardValidator.validate(month: nil, year: pastYear, target: targetDate)
        XCTAssertFalse(valid.partial)
        XCTAssertFalse(valid.complete)
    }

    // MARK: Expiry month and year

    func testValidateExpiryMonthAndYear_bothNil() {

        let cardValidator = AccessCheckoutCardValidator()
        let valid = cardValidator.validate(month: nil, year: nil, target: Date())
        XCTAssertTrue(valid.partial)
        XCTAssertFalse(valid.complete)
    }

    func testValidateExpiryMonthAndYear_zeroMonth() {

        let targetDate = Date()
        guard let futureDate = Calendar.current.date(byAdding: .year, value: 1, to: targetDate) else {
            XCTFail()
            return
        }
        yearDateFormatter.dateFormat = "yy"
        let futureYear = yearDateFormatter.string(from: futureDate)

        let cardValidator = AccessCheckoutCardValidator()
        let valid = cardValidator.validate(month: "0", year: futureYear, target: Date())
        XCTAssertTrue(valid.partial)
        XCTAssertFalse(valid.complete)
    }

    func testValidateExpiryMonthAndYear_past_sameYear() {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let targetDate = dateFormatter.date(from: "01/10/2019")!

        let cardValidator = AccessCheckoutCardValidator()
        let valid = cardValidator.validate(month: "09", year: "19", target: targetDate)
        XCTAssertFalse(valid.partial)
        XCTAssertFalse(valid.complete)
    }

    func testValidateExpiryMonthAndYear_future_noConfiguration() {

        let cardValidator = AccessCheckoutCardValidator()

        let targetDate = Date()
        guard let futureDate = Calendar.current.date(byAdding: .year, value: 1, to: targetDate) else {
            XCTFail()
            return
        }
        monthDateFormatter.dateFormat = "MM"
        yearDateFormatter.dateFormat = "yy"
        let futureMonth = monthDateFormatter.string(from: futureDate)
        let futureYear = yearDateFormatter.string(from: futureDate)

        let valid = cardValidator.validate(month: futureMonth, year: futureYear, target: targetDate)
        XCTAssertTrue(valid.partial)
        XCTAssertTrue(valid.complete)
    }

    func testValidateExpiryMonthAndYear_current_noConfiguration() {

        let cardValidator = AccessCheckoutCardValidator()

        let targetDate = Date()
        monthDateFormatter.dateFormat = "MM"
        yearDateFormatter.dateFormat = "yy"
        let sameMonth = monthDateFormatter.string(from: targetDate)
        let sameYear = yearDateFormatter.string(from: targetDate)

        let valid = cardValidator.validate(month: sameMonth, year: sameYear, target: targetDate)
        XCTAssertTrue(valid.partial)
        XCTAssertTrue(valid.complete)
    }

    func testValidateExpiryMonthAndYear_past_noConfiguration() {

        let cardValidator = AccessCheckoutCardValidator()

        let targetDate = Date()
        guard let pastDate = Calendar.current.date(byAdding: .year, value: -1, to: targetDate) else {
            XCTFail()
            return
        }
        monthDateFormatter.dateFormat = "MM"
        yearDateFormatter.dateFormat = "yy"
        let pastMonth = monthDateFormatter.string(from: pastDate)
        let pastYear = yearDateFormatter.string(from: pastDate)
        let valid = cardValidator.validate(month: pastMonth, year: pastYear, target: targetDate)
        XCTAssertFalse(valid.partial)
        XCTAssertFalse(valid.complete)
    }

    func testValidateExpiryMonthAndYear_empty() {
        let monthRule = CardConfiguration.CardValidationRule(matcher: "^0[1-9]{0,1}$|^1[0-2]{0,1}$",
                                                             validLengths: [])
        let yearRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,2}$",
                                                            validLengths: [])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: monthRule,
                                                      year: yearRule)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        let valid = cardValidator.validate(month: "", year: "", target: Date())
        XCTAssertTrue(valid.partial)
        XCTAssertFalse(valid.complete)
    }

    func testValidateExpiryMonthAndYear_alphaMonth() {
        let monthRule = CardConfiguration.CardValidationRule(matcher: "^0[1-9]{0,1}$|^1[0-2]{0,1}$",
                                                             validLengths: [])
        let yearRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,2}$",
                                                            validLengths: [2])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: monthRule,
                                                      year: yearRule)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        let valid = cardValidator.validate(month: "A", year: "", target: Date())
        XCTAssertFalse(valid.partial)
        XCTAssertFalse(valid.complete)
    }

    func testValidateExpiryMonthAndYear_alphaYear() {
        let monthRule = CardConfiguration.CardValidationRule(matcher: "^0[1-9]{0,1}$|^1[0-2]{0,1}$",
                                                             validLengths: [])
        let yearRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,2}$",
                                                            validLengths: [2])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: monthRule,
                                                      year: yearRule)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        let valid = cardValidator.validate(month: "", year: "A", target: Date())
        XCTAssertFalse(valid.partial)
        XCTAssertFalse(valid.complete)
    }

    func testValidateExpiryMonthAndYear_future() {
        let monthRule = CardConfiguration.CardValidationRule(matcher: "^0[1-9]{0,1}$|^1[0-2]{0,1}$",
                                                             validLengths: [1,2])
        let yearRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,2}$",
                                                            validLengths: [2])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: monthRule,
                                                      year: yearRule)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration

        let targetDate = Date()
        guard let futureDate = Calendar.current.date(byAdding: .year, value: 1, to: targetDate) else {
            XCTFail()
            return
        }

        yearDateFormatter.dateFormat = "yy"
        monthDateFormatter.dateFormat = "MM"
        let month = monthDateFormatter.string(from: futureDate)
        let year = yearDateFormatter.string(from: futureDate)

        let valid = cardValidator.validate(month: month, year: year, target: targetDate)
        XCTAssertTrue(valid.partial)
        XCTAssertTrue(valid.complete)
    }

    func testValidateExpiryMonthAndYearValid_sameMonthYear() {
        let month = "01"
        let year = "19"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        let date = dateFormatter.date(from: "\(month)/\(year)")!

        let monthRule = CardConfiguration.CardValidationRule(matcher: "^0[1-9]{0,1}$|^1[0-2]{0,1}$",
                                                             validLengths: [1,2])
        let yearRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,2}$",
                                                            validLengths: [2])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: monthRule,
                                                      year: yearRule)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        let valid = cardValidator.validate(month: month, year: year, target: date)
        XCTAssertTrue(valid.partial)
        XCTAssertTrue(valid.complete)
    }

    func testValidateExpiryDateValid_past() {

        let monthRule = CardConfiguration.CardValidationRule(matcher: "^0[1-9]{0,1}$|^1[0-2]{0,1}$",
                                                             validLengths: [1,2])
        let yearRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,2}$",
                                                            validLengths: [2])
        let defaults = CardConfiguration.CardDefaults(pan: nil,
                                                      cvv: nil,
                                                      month: monthRule,
                                                      year: yearRule)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)
        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        let valid = cardValidator.validate(month: "01", year: "04", target: Date())
        XCTAssertFalse(valid.partial)
        XCTAssertFalse(valid.complete)
    }

    // MARK: Full card validation

    func testCardIsInvalid_nilCVV() {
        let now = Date()
        guard let futureDate = Calendar.current.date(byAdding: .year, value: 1, to: now) else {
            XCTFail()
            return
        }
        yearDateFormatter.dateFormat = "yy"
        monthDateFormatter.dateFormat = "MM"

        let validPan = "4111111111111111"
        let validMonth = monthDateFormatter.string(from: futureDate)
        let validYear = yearDateFormatter.string(from: futureDate)

        let cardValidator = AccessCheckoutCardValidator()
        XCTAssertFalse(cardValidator.isValid(pan: validPan,
                                             expiryMonth: validMonth,
                                             expiryYear: validYear,
                                             cvv: nil))
    }

    func testCardIsValid_noConfiguration() {

        let now = Date()
        guard let futureDate = Calendar.current.date(byAdding: .year, value: 1, to: now) else {
            XCTFail()
            return
        }
        yearDateFormatter.dateFormat = "yy"
        monthDateFormatter.dateFormat = "MM"

        let validPan = "4111111111111111"
        let validMonth = monthDateFormatter.string(from: futureDate)
        let validYear = yearDateFormatter.string(from: futureDate)
        let validCvv = "123"

        let cardValidator = AccessCheckoutCardValidator()
        XCTAssertTrue(cardValidator.isValid(pan: validPan,
                                            expiryMonth: validMonth,
                                            expiryYear: validYear,
                                            cvv: validCvv))
    }

    func testCardIsValid_noConfiguration_badLuhn() {

        let now = Date()
        guard let futureDate = Calendar.current.date(byAdding: .year, value: 1, to: now) else {
            XCTFail()
            return
        }
        yearDateFormatter.dateFormat = "yy"
        monthDateFormatter.dateFormat = "MM"

        let badPan = "4111111111111112" // Fails Luhn
        let validMonth = monthDateFormatter.string(from: futureDate)
        let validYear = yearDateFormatter.string(from: futureDate)
        let validCvv = "1"

        let cardValidator = AccessCheckoutCardValidator()
        XCTAssertFalse(cardValidator.isValid(pan: badPan,
                                             expiryMonth: validMonth,
                                             expiryYear: validYear,
                                             cvv: validCvv))
    }

    func testCardIsValid_defaults() {

        let panRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,16}$",
                                                           validLengths: [16])

        let cvvRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,3}$",
                                                           validLengths: [3])

        let monthRule = CardConfiguration.CardValidationRule(matcher: "^0[1-9]{0,1}$|^1[0-2]{0,1}$",
                                                             validLengths: [1,2])
        let yearRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,2}$",
                                                            validLengths: [2])
        let defaults = CardConfiguration.CardDefaults(pan: panRule,
                                                      cvv: cvvRule,
                                                      month: monthRule,
                                                      year: yearRule)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)

        let now = Date()
        guard let futureDate = Calendar.current.date(byAdding: .year, value: 1, to: now) else {
            XCTFail()
            return
        }
        yearDateFormatter.dateFormat = "yy"
        monthDateFormatter.dateFormat = "MM"

        let validPan = "4111111111111111"
        let validMonth = monthDateFormatter.string(from: futureDate)
        let validYear = yearDateFormatter.string(from: futureDate)
        let validCvv = "123"

        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        XCTAssertTrue(cardValidator.isValid(pan: validPan,
                                            expiryMonth: validMonth,
                                            expiryYear: validYear,
                                            cvv: validCvv))
    }

    func testCardIsValid_defaults_badPan() {

        let panRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,16}$",
                                                           validLengths: [16])

        let cvvRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,3}$",
                                                           validLengths: [3])

        let monthRule = CardConfiguration.CardValidationRule(matcher: "^0[1-9]{0,1}$|^1[0-2]{0,1}$",
                                                             validLengths: [1,2])
        let yearRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,2}$",
                                                            validLengths: [2])
        let defaults = CardConfiguration.CardDefaults(pan: panRule,
                                                      cvv: cvvRule,
                                                      month: monthRule,
                                                      year: yearRule)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)

        let now = Date()
        guard let futureDate = Calendar.current.date(byAdding: .year, value: 1, to: now) else {
            XCTFail()
            return
        }
        yearDateFormatter.dateFormat = "yy"
        monthDateFormatter.dateFormat = "MM"

        let validPan = "41111111"
        let validMonth = monthDateFormatter.string(from: futureDate)
        let validYear = yearDateFormatter.string(from: futureDate)
        let validCvv = "123"

        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        XCTAssertFalse(cardValidator.isValid(pan: validPan,
                                             expiryMonth: validMonth,
                                             expiryYear: validYear,
                                             cvv: validCvv))
    }

    func testCardIsValid_defaults_badExpiry() {

        let panRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,16}$",
                                                           validLengths: [16])

        let cvvRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,3}$",
                                                          validLengths: [3])

        let monthRule = CardConfiguration.CardValidationRule(matcher: "^0[1-9]{0,1}$|^1[0-2]{0,1}$",
                                                            validLengths: [1,2])
        let yearRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,2}$",
                                                            validLengths: [2])
        let defaults = CardConfiguration.CardDefaults(pan: panRule,
                                                      cvv: cvvRule,
                                                      month: monthRule,
                                                      year: yearRule)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)

        let now = Date()
        guard let pastDate = Calendar.current.date(byAdding: .year, value: -1, to: now) else {
            XCTFail()
            return
        }
        yearDateFormatter.dateFormat = "yy"
        monthDateFormatter.dateFormat = "MM"

        let validPan = "4111111111111111"
        let validMonth = monthDateFormatter.string(from: pastDate)
        let validYear = yearDateFormatter.string(from: pastDate)
        let validCvv = "123"

        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        XCTAssertFalse(cardValidator.isValid(pan: validPan,
                                             expiryMonth: validMonth,
                                             expiryYear: validYear,
                                             cvv: validCvv))
    }

    func testCardIsValid_defaults_badCvv() {

        let panRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,16}$",
                                                           validLengths: [16])

        let cvvRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,3}$",
                                                          validLengths: [3])

        let monthRule = CardConfiguration.CardValidationRule(matcher: "^0[1-9]{0,1}$|^1[0-2]{0,1}$",
                                                             validLengths: [1,2])
        let yearRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,2}$",
                                                            validLengths: [2])
        let defaults = CardConfiguration.CardDefaults(pan: panRule,
                                                      cvv: cvvRule,
                                                      month: monthRule,
                                                      year: yearRule)
        let cardConfiguration = CardConfiguration(defaults: defaults, brands: nil)

        let now = Date()
        guard let futureDate = Calendar.current.date(byAdding: .year, value: 1, to: now) else {
            XCTFail()
            return
        }
        yearDateFormatter.dateFormat = "yy"
        monthDateFormatter.dateFormat = "MM"

        let validPan = "4111111111111111"
        let validMonth = monthDateFormatter.string(from: futureDate)
        let validYear = yearDateFormatter.string(from: futureDate)
        let validCvv = "1"

        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        XCTAssertFalse(cardValidator.isValid(pan: validPan,
                                             expiryMonth: validMonth,
                                             expiryYear: validYear,
                                             cvv: validCvv))
    }

    func testCardIsValid_brand() {

        let cardBrand = CardConfiguration.CardBrand(name: "visa", images: nil, matcher: "^4\\d{0,15}", cvv: 3, pans: [16])
        let cardConfiguration = CardConfiguration(defaults: nil, brands: [cardBrand])

        let now = Date()
        guard let futureDate = Calendar.current.date(byAdding: .year, value: 1, to: now) else {
            XCTFail()
            return
        }
        yearDateFormatter.dateFormat = "yy"
        monthDateFormatter.dateFormat = "MM"

        let validPan = "4111111111111111"
        let validMonth = monthDateFormatter.string(from: futureDate)
        let validYear = yearDateFormatter.string(from: futureDate)
        let validCvv = "123"

        let cardValidator = AccessCheckoutCardValidator()
        cardValidator.cardConfiguration = cardConfiguration
        let valid = cardValidator.isValid(pan: validPan,
                                          expiryMonth: validMonth,
                                          expiryYear: validYear,
                                          cvv: validCvv)
        XCTAssertTrue(valid)
    }
}
