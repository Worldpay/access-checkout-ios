import Foundation

/// Discovery of the Access Worldpay Verified Tokens Session service
public protocol Discovery {
    
    /// The discovered verified tokens session service endpoint
    var serviceEndpoint: URL? { get }
    /// Starts discovery of services
    func discover(serviceLinks: DiscoverLinks, urlSession: URLSession, onComplete: (() -> Void)?)
}

public class DiscoverLinks {
    var service: String
    var endpoint: String
    
    static let verifiedTokens =  DiscoverLinks(service: "service:verifiedTokens", endpoint: "verifiedTokens:session")
    static let sessions =  DiscoverLinks(service: "service:sessions", endpoint: "sessions:session")
    
    
    public init(service: String, endpoint: String) {
        self.service = service
        self.endpoint = endpoint
    }
}

/// Discovers Access Worldpay Verified Tokens Session service
public final class AccessCheckoutDiscovery: Discovery {
    
    private let baseUrl: URL

    private var serviceDiscoveryTask: URLSessionTask?
    private var endpointDiscoveryTask: URLSessionTask?

    /// The discovered Access Worldpay Verified Tokens Session service endpoint
    public var serviceEndpoint: URL?
    
    /**
     Initialises discovery with the base URL of Access Worldpay services.
     
     - Parameter baseUrl: The Access Worldpay services root URL
     */
    public init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }
    
    /**
     Starts the discovery of the Access Worldpay Verified Tokens Session service.
     
     - Parameters:
        - urlSession: A `URLSession` object
        - onComplete: Callback upon discovery completion, successful or otherwise
     */
    public func discover(serviceLinks: DiscoverLinks, urlSession: URLSession, onComplete: (() -> Void)? = nil) {
        
        // Check for existing tasks running
        guard serviceDiscoveryTask?.state != URLSessionTask.State.running &&
             endpointDiscoveryTask?.state != URLSessionTask.State.running else {
            return
        }

        // Discovers the root end-point in verified tokens service
        self.serviceDiscoveryTask = urlSession.dataTask(with: baseUrl) { (data, response, error) in
            if let jsonData = data,
                let rootEndPoint = self.fetchServiceURL(withLinkId: serviceLinks.service, in: jsonData) {
                self.discoverServiceEndPoint(service: serviceLinks.endpoint, withSession: urlSession, from: rootEndPoint, onComplete: onComplete)
            } else {
                onComplete?()
            }
        }
        self.serviceDiscoveryTask?.resume()
    }
    
    private func discoverServiceEndPoint(service: String, withSession urlSession: URLSession, from startUrl: URL, onComplete: (() -> Void)? = nil) -> Void {
        
        self.endpointDiscoveryTask = urlSession.dataTask(with: startUrl) { (data, response, error) in
            if let jsonData = data,
               let endpointURL = self.fetchServiceURL(withLinkId: service, in: jsonData) {
                    self.serviceEndpoint = endpointURL
            }
            onComplete?()
        }
        self.endpointDiscoveryTask?.resume()
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
