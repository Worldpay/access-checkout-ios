import Foundation

// A client for the Access Checkout API
public final class AccessCheckoutClient {
    
    private let merchantIdentifier: String
    private let discovery: Discovery
    
    /**
     Initialises a client for API communication.
     
     - Parameters:
        - discovery: The `AccessCheckoutDiscovery` object
        - merchantIdentifier: The merchants unique identifier provided by Worldpay
     */
    public init(discovery: Discovery, merchantIdentifier: String) {
        self.discovery = discovery
        self.merchantIdentifier = merchantIdentifier
    }
    
    /**
     Creates a Verified Tokens session.
     
     - Parameters:
        - pan: The card number
        - expiryMonth: The card expiry date month
        - expiryYear: The card expiry date year
        - cvv: The card CVV
        - urlSession: A `URLSession` object
        - completionHandler: Closure returning a `Result` with the created session or an error
     */
    public func createSession(pan: PAN,
                    expiryMonth: UInt,
                    expiryYear: UInt,
                    cvv: CVV,
                    urlSession: URLSession = URLSession.shared,
                    completionHandler: @escaping (Result<String, Error>) -> Void) {
        
        if let url = discovery.verifiedTokensSessionEndpoint {
            do {
                let request = try buildRequest(url: url,
                                               bundle: Bundle(for: AccessCheckoutClient.self),
                                               pan: pan,
                                               expiryMonth: expiryMonth,
                                               expiryYear: expiryYear,
                                               cvv: cvv)
                
                createSession(request: request, completionHandler: completionHandler)
            } catch {
                completionHandler(.failure(error))
            }
        } else {
            discovery.discover(urlSession: urlSession) {
                if let url = self.discovery.verifiedTokensSessionEndpoint {
                    do {
                        let request = try self.buildRequest(url: url,
                                                            bundle: Bundle(for: AccessCheckoutClient.self),
                                                            pan: pan,
                                                            expiryMonth: expiryMonth,
                                                            expiryYear: expiryYear,
                                                            cvv: cvv)
                        
                        self.createSession(request: request, completionHandler: completionHandler)
                    } catch {
                        completionHandler(.failure(error))
                    }
                } else {
                    completionHandler(.failure(AccessCheckoutClientError.undiscoverable(message: "Unable to discover services")))
                }
            }
        }
    }
    
    private func buildRequest(url: URL,
                      bundle: Bundle,
                      pan: PAN,
                      expiryMonth: UInt,
                      expiryYear: UInt,
                      cvv: CVV) throws -> URLRequest {
        
        var request = URLRequest(url: url)
        request.addValue("application/vnd.worldpay.verified-tokens-v1.hal+json", forHTTPHeaderField: "content-type")
        request.httpMethod = "POST"
        let tokenRequest = VerifiedTokenRequest(cardNumber: pan,
                                                cardExpiryDate: VerifiedTokenRequest.CardExpiryDate(
                                                    month: expiryMonth,
                                                    year: expiryYear),
                                                cvc: cvv,
                                                identity: merchantIdentifier)
        request.httpBody = try JSONEncoder().encode(tokenRequest)
            
        // Add user-agent header
        let userAgent = UserAgent(bundle: bundle)
        request.addValue(userAgent.headerValue, forHTTPHeaderField: UserAgent.headerName)
        
        return request
    }
    
    private func createSession(request: URLRequest,
                       urlSession: URLSession = URLSession.shared,
                       completionHandler: @escaping (Result<String, Error>) -> Void ) {
        
        urlSession.dataTask(with: request) { (data, _, error) in
            if let sessionData = data {
                if let verifiedTokensResponse = try? JSONDecoder().decode(AccessCheckoutResponse.self, from: sessionData),
                    let href = verifiedTokensResponse.links.endpoints.mapValues({ $0.href })["verifiedTokens:session"] {
                        completionHandler(.success(href))
                } else if let accessCheckoutClientError = try? JSONDecoder().decode(AccessCheckoutClientError.self, from: sessionData) {
                    completionHandler(.failure(accessCheckoutClientError))
                } else {
                    completionHandler(.failure(AccessCheckoutClientError.unknown(message: "Failed to decode response data")))
                }
            } else {
                    completionHandler(.failure(error ??
                        AccessCheckoutClientError.unknown(message: "Unexpected response: no data or error returned")))
            }
        }.resume()
    }
}

struct VerifiedTokenRequest: Codable {
    
    enum Key: String, CodingKey {
        case cardExpiryDate = "cardExpiryDate"
        case cardNumber = "cardNumber"
        case cvc = "cvc"
        case identity = "identity"
    }
    
    struct CardExpiryDate: Codable {
        enum Key: String, CodingKey {
            case month = "month"
            case year = "year"
        }
        var month: UInt
        var year: UInt
    }
    var cardNumber: String
    var cardExpiryDate: CardExpiryDate
    var cvc: String
    var identity: String
}

private struct UserAgent {
    static let headerName = "X-WP-SDK"
    static let valueFormat = "access-checkout-ios/%@"
    let headerValue: String
    
    init(bundle: Bundle) {
        let appVersion = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "unknown"
        self.headerValue = String(format: UserAgent.valueFormat, appVersion)
    }
}

