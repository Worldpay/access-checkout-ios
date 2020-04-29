public final class VerifiedTokensApiClient {
    
    private let merchantIdentifier: String
    private let discovery: Discovery
    
    /**
     Initialises a client for API communication.
     
     - Parameters:
        - discovery: The `Discovery` component
        - merchantIdentifier: The merchants unique identifier provided by Worldpay
     */
    public init(discovery: Discovery, merchantIdentifier: String) {
        self.discovery = discovery
        self.merchantIdentifier = merchantIdentifier
    }
    
    /**
     Request to create a Verified Tokens Session.
     
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
                              urlSession: URLSession,
                              completionHandler: @escaping (Result<String, Error>) -> Void) {
        
        if let url = discovery.serviceEndpoint {
            do {
                let request = try buildRequest(url: url,
                                               bundle: Bundle(for: VerifiedTokensApiClient.self),
                                               pan: pan,
                                               expiryMonth: expiryMonth,
                                               expiryYear: expiryYear,
                                               cvv: cvv)
                
                createSession(request: request, completionHandler: completionHandler)
            } catch {
                completionHandler(.failure(error))
            }
        } else {
            discovery.discover(serviceLinks: ApiLinks.verifiedTokens, urlSession: urlSession) {
                if let url = self.discovery.serviceEndpoint {
                    do {
                        let request = try self.buildRequest(url: url,
                                                            bundle: Bundle(for: VerifiedTokensApiClient.self),
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
        request.addValue(ApiHeaders.verifiedTokensHeaderValue, forHTTPHeaderField: "content-type")
        request.httpMethod = "POST"
        let tokenRequest = VerifiedTokensSessionRequest(cardNumber: pan,
                                                cardExpiryDate: VerifiedTokensSessionRequest.CardExpiryDate(
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
                if let verifiedTokensResponse = try? JSONDecoder().decode(ApiResponse.self, from: sessionData),
                    let href = verifiedTokensResponse.links.endpoints.mapValues({ $0.href })[ApiLinks.verifiedTokens.result] {
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
