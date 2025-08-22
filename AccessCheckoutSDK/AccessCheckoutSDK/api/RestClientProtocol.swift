import Foundation

protocol RestClientProtocol {
    associatedtype ResponseType: Decodable

    func send(
        urlSession: URLSession,
        request: URLRequest,
        completionHandler: @escaping (Result<ResponseType, AccessCheckoutError>, Int?) -> Void
    ) -> URLSessionTask
}
