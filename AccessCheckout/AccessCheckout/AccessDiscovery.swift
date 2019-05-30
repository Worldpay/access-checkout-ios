import Foundation

public class AccessCheckoutDiscovery {
    
    private let baseUrl: URL
    private let verifiedTokensServiceLinkId = "service:verifiedTokens"
    private let verifiedTokensSessionLinkId = "verifiedTokens:sessions"

    private var verifiedTokensSessionEndPoint: URL? = nil
    private var accessRootDiscoveryTask: URLSessionTask?
    private var verifiedTokensDiscoveryTask: URLSessionTask?

    public init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }
    
    public func getVerifiedTokensSessionEndPoint() -> URL? {
        return verifiedTokensSessionEndPoint
    }
    
    public func discover(urlSession: URLSession, onComplete: (() -> Void)? = nil) {
        
        // Check for existing tasks running
        guard accessRootDiscoveryTask?.state != URLSessionTask.State.running &&
             verifiedTokensDiscoveryTask?.state != URLSessionTask.State.running else {
            return
        }
        
        // Discovers the root end-point in verified tokens service
        self.accessRootDiscoveryTask = urlSession.dataTask(with: baseUrl) { (data, response, error) in
            if let jsonData = data,
               let vtsRootEndPoint = self.fetchServiceURL(withLinkId: self.verifiedTokensServiceLinkId, in: jsonData) {
                    self.discoverSessionsEndPoint(withSession: urlSession, from: vtsRootEndPoint, onComplete: onComplete)
            } else {
                onComplete?()
            }
        }
        self.accessRootDiscoveryTask?.resume()
    }
    
    private func discoverSessionsEndPoint(withSession urlSession: URLSession, from startUrl: URL, onComplete: (() -> Void)? = nil) -> Void {
        
        self.verifiedTokensDiscoveryTask = urlSession.dataTask(with: startUrl) { (data, response, error) in
            if let jsonData = data,
               let vtsSessionURL = self.fetchServiceURL(withLinkId: self.verifiedTokensSessionLinkId, in: jsonData) {
                    self.verifiedTokensSessionEndPoint = vtsSessionURL
            }
            onComplete?()
        }
        self.verifiedTokensDiscoveryTask?.resume()
    }
    
    private func decodeJSON(fromData data: Data) throws -> AccessCheckoutResponse? {
        return try JSONDecoder().decode(AccessCheckoutResponse.self, from: data)
    }
    
    private func fetchServiceURL(withLinkId linkId: String, in jsonData: Data) -> URL? {
        var resultURL : URL? = nil
        
        do {
            if let accessCheckoutResponse = try self.decodeJSON(fromData: jsonData) {
                let serviceMap = accessCheckoutResponse.links.endpoints.mapValues({ URL(string: $0.href) })
                resultURL = serviceMap[linkId] ?? nil
            }
        } catch {
            if let json = String(data: jsonData, encoding: .utf8) {
                print("Error parsing JSON: \(json)")
            }
        }
        
        return resultURL
    }
}
