import Foundation

enum BaseUrlSanitiserError: LocalizedError {
    case notPermitted(String)
    
    var errorDescription: String? {
        if case .notPermitted(let url) = self {
            return "base url '\(url)' is not permitted"
        }
        return nil
    }
}

private let allowedPatterns: [NSRegularExpression] = [
    try! NSRegularExpression(pattern: #"^https://([a-zA-Z0-9\-]+\.)*worldpay\.com$"#),
    try! NSRegularExpression(pattern: #"^https?://localhost(:\d+)?$"#),
    try! NSRegularExpression(pattern: #"^https?://127\.0\.0\.1(:\d+)?$"#)
]

private extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(string.startIndex..., in: string)
        return firstMatch(in: string, range: range) != nil
    }
}

func sanitise(_ baseUrl: String?) throws -> String? {
    guard let baseUrl else { return nil }
    
    let trimmed = baseUrl.hasSuffix("/") ? String(baseUrl.dropLast()) : baseUrl
    
    guard allowedPatterns.contains(where: { $0.matches(trimmed) }) else {
        throw BaseUrlSanitiserError.notPermitted(baseUrl)
    }
    
    return trimmed
}
