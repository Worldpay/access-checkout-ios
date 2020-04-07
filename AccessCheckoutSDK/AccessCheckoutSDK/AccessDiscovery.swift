import Foundation

/// Discovery of the Access Worldpay Verified Tokens Session service
public protocol Discovery {
    
    /// The discovered verified tokens session service endpoint
    var serviceEndpoint: URL? { get }
    /// Starts discovery of services
    func discover(serviceLinks: ApiLinks, urlSession: URLSession, onComplete: (() -> Void)?)
}

public final class ApiLinks {
    var service: String
    var endpoint: String
    var result: String
    
    public static let verifiedTokens =  ApiLinks(service: "service:verifiedTokens", endpoint: "verifiedTokens:sessions", result: "verifiedTokens:session")
    public static let sessions =  ApiLinks(service: "service:sessions", endpoint: "sessions:paymentsCvc", result: "sessions:session")
    
    public init(service: String, endpoint: String, result: String) {
        self.service = service
        self.endpoint = endpoint
        self.result = result
    }
}

public final class ApiHeaders {
    public static let verifiedTokensHeaderValue = "application/vnd.worldpay.verified-tokens-v1.hal+json"
    public static let sessionsHeaderValue = "application/vnd.worldpay.sessions-v1.hal+json"
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
    private func buildRequest(url: URL, service: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        switch service {
            case ApiLinks.verifiedTokens.endpoint:
                request.addValue(ApiHeaders.verifiedTokensHeaderValue, forHTTPHeaderField: "content-type")
            case ApiLinks.sessions.endpoint:
                request.addValue(ApiHeaders.sessionsHeaderValue, forHTTPHeaderField: "content-type")
                request.addValue(ApiHeaders.sessionsHeaderValue, forHTTPHeaderField: "accept")
            default:
                return request
        }
        return request
    }
    
    
    public func discover(serviceLinks: ApiLinks, urlSession: URLSession, onComplete: (() -> Void)? = nil) {
        
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
        
        let request = buildRequest(url: startUrl, service: service)
        self.endpointDiscoveryTask = urlSession.dataTask(with: request) { (data, response, error) in
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
