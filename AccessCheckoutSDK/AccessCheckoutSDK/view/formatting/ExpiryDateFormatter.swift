import Foundation

class ExpiryDateFormatter {
    let separator = "/"
    
    private let nonNumericRegex = try! NSRegularExpression(pattern: "[^0-9/]", options: NSRegularExpression.Options.caseInsensitive)
    private let maxLength = 5

    func format(_ text: String) -> String {
        // do not format empty strings
        if text.isEmpty {
            return text
        }

        var expiryDate = text.replacingOccurrences(of: "/", with: "")
        expiryDate = stripNonNumericalCharacters(expiryDate)

        if expiryDate.isEmpty {
            return expiryDate
        }

        if expiryDate.count == 1 {
            let month = getFormattedMonth(expiryDate)
            if month.count > 1 {
                return month + separator
            } else {
                return month
            }
        }

        let month = getFormattedMonth(expiryDate)
        let year = getFormattedYear(expiryDate)
        return limitToMaxLength(month + separator + year)
    }

    private func stripNonNumericalCharacters(_ string: String) -> String {
        if !isNumeric(string) {
            let range = NSMakeRange(0, string.count)
            return nonNumericRegex.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: "")
        }

        return string
    }

    private func getFormattedMonth(_ expiryDate: String) -> String {
        if expiryDate.count == 1 {
            let month = leftPartOf(string: expiryDate, count: 1)
            if Int(month)! >= 2 {
                return "0\(month)"
            }

            return month
        } else {
            let month = leftPartOf(string: expiryDate, count: 2)
            if Int(month)! >= 13 {
                return "0\(leftPartOf(string: expiryDate, count: 1))"
            }

            return month
        }
    }

    private func getFormattedYear(_ expiryDate: String) -> String {
        let month = leftPartOf(string: expiryDate, count: 2)
        if Int(month)! >= 13 {
            return rightPartOf(string: expiryDate, startingAt: 1)
        }
        return rightPartOf(string: expiryDate, startingAt: 2)
    }

    private func limitToMaxLength(_ expiryDate: String) -> String {
        if expiryDate.count > maxLength {
            return leftPartOf(string: expiryDate, count: maxLength)
        }
        return expiryDate
    }

    private func isNumeric(_ string: String) -> Bool {
        return string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }

    private func leftPartOf(string: String, count: Int) -> String {
        return String(string.prefix(count))
    }

    private func rightPartOf(string: String, startingAt: Int) -> String {
        let index = string.index(string.startIndex, offsetBy: startingAt)
        return String(string.suffix(from: index))
    }
}
