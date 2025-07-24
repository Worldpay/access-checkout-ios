import Foundation

class CardBinURLRequestFactory {
    private let url:String
    private let checkoutId:String

    init(url: String, checkoutId:String) {
        self.url = url
        self.checkoutId = checkoutId
    }

    func create(cardNumber: String) -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        
        
        request.httpMethod = "POST"
        request.addValue(ApiHeaders.cardBinContentType, forHTTPHeaderField: "content-type")
        request.addValue(ApiHeaders.cardBinContentType, forHTTPHeaderField: "Accept")
        request.addValue(ApiHeaders.cardBinWpCallerId, forHTTPHeaderField: "WP-CallerId")
        request.addValue(ApiHeaders.cardBinWpApiVersion, forHTTPHeaderField: "WP-Api-Version")

        let payload = CardBinRequest(cardNumber: cardNumber, checkoutId: self.checkoutId)
        request.httpBody = try? JSONEncoder().encode(payload)

        return request
    }
}

