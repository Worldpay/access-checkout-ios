import Foundation

// ToDo - This should be renamed once the SessionsSessionRequest class has been renamed
class SessionsSessionURLRequestFactory {
    func create(url :URL, cvv: CVV, merchantIdentity: String, bundle: Bundle) -> URLRequest {
        var request = URLRequest(url: url)
        let sessionRequest: SessionsSessionRequest = SessionsSessionRequest(cvc: cvv, identity: merchantIdentity)
        request.httpBody = try? JSONEncoder().encode(sessionRequest)
        request.httpMethod = "POST"
        request.addValue(ApiHeaders.sessionsHeaderValue, forHTTPHeaderField: "Content-type")
        request.addValue(ApiHeaders.sessionsHeaderValue, forHTTPHeaderField: "Accept")
        let userAgent = UserAgent(bundle: bundle)

        request.addValue(userAgent.headerValue, forHTTPHeaderField: UserAgent.headerName)

        return request
    }
}
