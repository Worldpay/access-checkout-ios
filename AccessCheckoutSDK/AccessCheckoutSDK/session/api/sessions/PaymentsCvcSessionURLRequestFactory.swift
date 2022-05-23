import Foundation

class PaymentsCvcSessionURLRequestFactory {
    func create(url: String, cvc: String, merchantIdentity: String) -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        let sessionRequest: PaymentsCvcSessionRequest = PaymentsCvcSessionRequest(cvc: cvc, identity: merchantIdentity)
        request.httpBody = try? JSONEncoder().encode(sessionRequest)
        request.httpMethod = "POST"
        request.addValue(ApiHeaders.sessionsHeaderValue, forHTTPHeaderField: "Content-type")
        request.addValue(ApiHeaders.sessionsHeaderValue, forHTTPHeaderField: "Accept")
        request.addValue(UserAgent.headerValue, forHTTPHeaderField: UserAgent.headerName)

        return request
    }
}
