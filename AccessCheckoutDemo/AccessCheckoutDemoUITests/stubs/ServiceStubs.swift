import Foundation
import Swifter

private let httpServer: HttpServer = .init()

class ServiceStubs {
    static let bundle = Bundle(for: ServiceStubs.self)
    static let port: UInt16 = 8123
    static var baseUri: String {
        return "http://localhost:\(port)"
    }

    let baseUri: String = ServiceStubs.baseUri

    func cardConfiguration() -> ServiceStubs {
        let jsonObject = try! jsonResponse(of: .cardConfiguration)

        httpServer.GET["/access-checkout/cardTypes.json"] = { _ in
            .ok(.json(jsonObject))
        }
        return self
    }

    func discovery(respondWith: StubResponse) -> ServiceStubs {
        let jsonObject = try! jsonResponse(of: respondWith)

        httpServer.GET[""] = { _ in .ok(.json(jsonObject)) }
        httpServer.GET["/"] = { _ in .ok(.json(jsonObject)) }
        return self
    }

    func verifiedTokensRoot(respondWith: StubResponse) -> ServiceStubs {
        let jsonObject = try! jsonResponse(of: respondWith)

        httpServer.GET["/verifiedTokens"] = { _ in
            .ok(.json(jsonObject))
        }
        return self
    }

    func verifiedTokensSessions(respondWith: StubResponse) -> ServiceStubs {
        let jsonObject = try! jsonResponse(of: respondWith)
        httpServer.POST["/verifiedTokens/sessions"] = { _ in
            if respondWith == .verifiedTokensSessionsPanFailedLuhnCheck {
                return .badRequest(.json(jsonObject))
            } else {
                return .ok(.json(jsonObject))
            }
        }
        return self
    }

    func sessionsRoot(respondWith: StubResponse) -> ServiceStubs {
        let jsonObject = try! jsonResponse(of: respondWith)

        httpServer.GET["/sessions"] = { _ in
            .ok(.json(jsonObject))
        }
        return self
    }

    func sessionsPaymentsCvc(respondWith: StubResponse) -> ServiceStubs {
        let jsonObject = try! jsonResponse(of: respondWith)

        httpServer.POST["/sessions/payments/cvc"] = { _ in
            .ok(.json(jsonObject))
        }
        return self
    }

    func start() {
        try! httpServer.start(ServiceStubs.port)
    }

    func stop() {
        httpServer.stop()
    }

    private func jsonResponse(of stubResponseName: StubResponse) throws -> Any {
        guard let resourceUrl: URL = ServiceStubs.bundle.url(forResource: stubResponseName.rawValue, withExtension: "json"),
              let stringContent = try? String(contentsOf: resourceUrl)
        else {
            throw ResourceError(message: "Failed to set up stub. Could not find JSON resource with name '\(stubResponseName)'")
        }

        let data = stringContent
            .replacingOccurrences(of: "<BASE_URI>", with: ServiceStubs.baseUri)
            .data(using: .utf8)

        return try JSONSerialization.jsonObject(with: data!, options: [])
    }
}

class ResourceError: Error {
    let message: String

    init(message: String) {
        self.message = message
    }
}

extension InputStream {
    func readfully() -> Data {
        var result = Data()
        var buffer = [UInt8](repeating: 0, count: 4096)

        open()

        var amount = 0
        repeat {
            amount = read(&buffer, maxLength: buffer.count)
            if amount > 0 {
                result.append(buffer, count: amount)
            }
        } while amount > 0

        close()

        return result
    }
}
