import Foundation

class CardSessionURLRequestFactory {
    func create(
        url: String,
        checkoutId: String,
        pan: String,
        expiryMonth: UInt,
        expiryYear: UInt,
        cvc: String
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.addValue(ApiHeaders.sessionsHeaderValue, forHTTPHeaderField: "content-type")
        request.addValue(ApiHeaders.sessionsHeaderValue, forHTTPHeaderField: "Accept")
        request.addValue(WpSdkHeader.value, forHTTPHeaderField: WpSdkHeader.name)

        let expiryDate = CardSessionRequest.CardExpiryDate(month: expiryMonth, year: expiryYear)
        let tokenRequest = CardSessionRequest(
            cardNumber: pan,
            cardExpiryDate: expiryDate,
            cvc: cvc,
            identity: checkoutId
        )

        request.httpBody = try? JSONEncoder().encode(tokenRequest)

        return request
    }
}
