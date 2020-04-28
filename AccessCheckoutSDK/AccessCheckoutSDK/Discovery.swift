import Foundation

/// Discovery of the Access Worldpay Verified Tokens Session service
public protocol Discovery {
    
    /// The discovered verified tokens session service endpoint
    var serviceEndpoint: URL? { get }
    /// Starts discovery of services
    func discover(serviceLinks: ApiLinks, urlSession: URLSession, onComplete: (() -> Void)?)
}
