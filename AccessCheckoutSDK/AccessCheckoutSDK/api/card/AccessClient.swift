import Foundation

/// Entrypoint to Access Checkout API
public protocol AccessClient {
    
    /// Request to create a Verified Token session
    func createSession(pan: PAN,
                       expiryMonth: UInt,
                       expiryYear: UInt,
                       cvv: CVV,
                       urlSession: URLSession,
                       completionHandler: @escaping (Result<String, Error>) -> Void)
}
