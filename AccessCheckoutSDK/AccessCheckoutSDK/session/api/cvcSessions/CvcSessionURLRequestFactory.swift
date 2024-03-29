import Foundation

class CvcSessionURLRequestFactory {
    func create(url: String, cvc: String, checkoutId: String) -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        let sessionRequest = CvcSessionRequest(cvc: cvc, identity: checkoutId)
        request.httpBody = try? JSONEncoder().encode(sessionRequest)
        request.httpMethod = "POST"
        request.addValue(ApiHeaders.sessionsHeaderValue, forHTTPHeaderField: "Content-type")
        request.addValue(ApiHeaders.sessionsHeaderValue, forHTTPHeaderField: "Accept")
        request.addValue(WpSdkHeader.value, forHTTPHeaderField: WpSdkHeader.name)

        return request
    }
}
