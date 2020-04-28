/// The card number or 'Primary Account Number'
public typealias PAN = String

extension PAN {
    
    /**
     Convenience regex matcher function.
     
     - Parameter text: Input text to match against
     - Returns: If any match exists
     */
    func regexMatches(text: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: self) else {
            return false
        }
        return regex.firstMatch(in: text, range: NSRange(location: 0, length: text.count)) != nil
    }
    
    /**
     Convenience Luhn check.
     - Returns: Is a valid Luhn.
     */
    func isValidLuhn() -> Bool {
        var sum = 0
        let reversedCharacters = self.reversed().map {
            String($0)
        }
        for (idx, element) in reversedCharacters.enumerated() {
            guard let digit = Int(element) else {
                return false
            }
            switch ((idx % 2 == 1), digit) {
            case (true, 9): sum += 9
            case (true, 0...8): sum += (digit * 2) % 9
            default: sum += digit
            }
        }
        return sum % 10 == 0
    }
}
