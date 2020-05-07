class VerifiedTokensSessionURLRequestFactory {
    func create(url: String, merchantId: String, pan: PAN, expiryMonth: UInt, expiryYear: UInt, cvv: CVV, bundle: Bundle) -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        
        request.addValue(ApiHeaders.verifiedTokensHeaderValue, forHTTPHeaderField: "content-type")
        let userAgent = UserAgent(bundle: bundle)
        request.addValue(userAgent.headerValue, forHTTPHeaderField: UserAgent.headerName)
        
        let expiryDate = VerifiedTokensSessionRequest.CardExpiryDate(month: expiryMonth, year: expiryYear)
        let tokenRequest = VerifiedTokensSessionRequest(cardNumber: pan,
                                                        cardExpiryDate: expiryDate,
                                                        cvc: cvv,
                                                        identity: merchantId)
        
        request.httpBody = try? JSONEncoder().encode(tokenRequest)

        return request
    }
}
