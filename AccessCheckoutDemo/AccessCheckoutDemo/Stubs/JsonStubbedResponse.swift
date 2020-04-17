import Foundation

class JsonStubbedResponse {
    private let resourceName:String
    
    init(_ resourceName:String) {
        self.resourceName = resourceName
    }
    
    func toData(usingBaseUri baseUri:String) -> Data? {
        return content()?
            .replacingOccurrences(of: "<BASE_URI>", with: baseUri)
            .data(using: .utf8)
    }
    
    private func content() -> String? {
        guard let resourceUrl:URL = Bundle.main.url(forResource: resourceName, withExtension: "json"),
            let stringContent = try? String(contentsOf: resourceUrl) else {
            return nil
        }
        
        return stringContent
    }
    
}
