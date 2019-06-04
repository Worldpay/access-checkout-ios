import Foundation

/// Test utility for stubbing
public class StubProvider {
    
    public static func stub(forName name: String, bundle: Bundle) -> (data: Data, baseUri: String)? {
        guard let baseUri = bundle.infoDictionary?["ACCESS_CHECKOUT_BASE_URI"] as? String else {
            return nil
        }
        guard let stubURL = bundle.url(forResource: name, withExtension: "json") else {
            return nil
        }
        guard let json = try? String(contentsOf: stubURL) else {
            return nil
        }
        guard let data = json.replacingOccurrences(of: "<BASE_URI>", with: baseUri).data(using: .utf8) else {
            return nil
        }
        return (data, baseUri)
    }
}
