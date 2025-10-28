import Swifter

@testable import AccessCheckoutSDK

struct ServiceStubs {
    init() {
        self.port = UInt16.random(in: 7000..<8000)
        self.httpServer = .init()
        self.baseUrl = "http://localhost:\(port)"
    }

    init(port: UInt16) {
        self.port = port
        self.httpServer = .init()
        self.baseUrl = "http://localhost:\(port)"
    }

    let baseUrl: String

    private let port: UInt16
    private let httpServer: HttpServer

    private let sessionsServicePath = "/sessions"
    private let sessionsServiceCardSessionPath = "/sessions/card"
    private let sessionsServicePaymentsCvcSessionPath = "/sessions/paymentsCvc"
    private let cardBinServicePath = "/public/card/bindetails"

    func get200(path: String, jsonResponse: String) -> ServiceStubs {
        let jsonData = try! toJSON(jsonResponse)
        httpServer.GET[path] = { _ in .ok(.json(jsonData as AnyObject)) }
        return self
    }

    func get200(path: String, textResponse: String) -> ServiceStubs {
        httpServer.GET[path] = { _ in .ok(.text(textResponse)) }
        return self
    }

    func get200(path: String, textResponse: String, delayInSeconds: TimeInterval) -> ServiceStubs {
        let response: ((HttpRequest) -> HttpResponse) = { req in
            return HttpResponse.ok(
                .custom(
                    "",
                    { _ -> String in
                        Thread.sleep(forTimeInterval: delayInSeconds)
                        return ""
                    }))
        }

        httpServer.GET[path] = response
        return self
    }

    func get400(path: String, jsonResponse: String) -> ServiceStubs {
        let jsonData = try! toJSON(jsonResponse)
        httpServer.GET[path] = { _ in .badRequest(.json(jsonData as AnyObject)) }
        return self
    }

    func get400(path: String, textResponse: String) -> ServiceStubs {
        httpServer.GET[path] = { _ in .badRequest(.text(textResponse)) }
        return self
    }

    func failed400(path: String, error: AccessCheckoutError) -> ServiceStubs {
        let jsonData = try! toJSON(toJSONString(error))
        httpServer.GET[path] = { _ in .badRequest(.json(jsonData as AnyObject)) }
        return self
    }

    func post200(path: String, jsonResponse: String) -> ServiceStubs {
        let jsonData = try! toJSON(jsonResponse)
        httpServer.POST[path] = { _ in .ok(.json(jsonData as AnyObject)) }
        return self
    }

    func post200(path: String, textResponse: String, delayInSeconds: TimeInterval) -> ServiceStubs {
        httpServer.POST[path] = { _ in
            Thread.sleep(forTimeInterval: delayInSeconds)
            return .ok(.text(textResponse))
        }
        return self
    }

    func post400(path: String, error: AccessCheckoutError) -> ServiceStubs {
        let jsonData = try! toJSON(toJSONString(error))
        httpServer.POST[path] = { _ in .badRequest(.json(jsonData as AnyObject)) }
        return self
    }

    func post500(path: String, delayInSeconds: TimeInterval) -> ServiceStubs {
        httpServer.POST[path] = { _ in
            Thread.sleep(forTimeInterval: delayInSeconds)
            return .internalServerError
        }
        return self
    }

    func servicesRootDiscoverySuccess() -> ServiceStubs {
        return get200(path: "", jsonResponse: successfulDiscoveryResponse())
    }

    func servicesRootDiscoveryFailure(error: AccessCheckoutError) -> ServiceStubs {
        return failed400(path: "", error: error)
    }

    func cardSessionSuccess(session: String) -> ServiceStubs {
        return post200(
            path: sessionsServiceCardSessionPath,
            jsonResponse: successfulCardSessionResponse(session: session))
    }

    func cardSessionFailure(error: AccessCheckoutError) -> ServiceStubs {
        return post400(path: sessionsServiceCardSessionPath, error: error)
    }

    func sessionsEndPointsDiscoverySuccess() -> ServiceStubs {
        return get200(path: sessionsServicePath, jsonResponse: successfulDiscoveryResponse())
    }

    func sessionsEndPointDiscoveryFailure(error: AccessCheckoutError) -> ServiceStubs {
        return failed400(path: sessionsServicePath, error: error)
    }

    func sessionsPaymentsCvcSessionSuccess(session: String) -> ServiceStubs {
        let jsonResponse = successfulPaymentsCvcSessionResponse(session: session)
        return post200(path: sessionsServicePaymentsCvcSessionPath, jsonResponse: jsonResponse)
    }

    func sessionsPaymentsCvcSessionFailure(error: AccessCheckoutError) -> ServiceStubs {
        return post400(path: sessionsServicePaymentsCvcSessionPath, error: error)
    }

    func start() {
        try! httpServer.start(port)
    }

    func stop() {
        httpServer.stop()
    }

    private func successfulDiscoveryResponse() -> String {
        return """
            {
                "_links": {
                    "service:sessions": {
                        "href": "\(baseUrl)\(sessionsServicePath)"
                    },
                    "sessions:card": {
                        "href": "\(baseUrl)\(sessionsServiceCardSessionPath)"
                    },
                    "sessions:paymentsCvc": {
                        "href": "\(baseUrl)\(sessionsServicePaymentsCvcSessionPath)"
                    },
                    "cardBinPublic:binDetails": {
                        "href": "\(baseUrl)\(cardBinServicePath)"
                    },
                }
            }
            """
    }

    private func successfulCardSessionResponse(session: String) -> String {
        return """
            {
                "_links": {
                    "sessions:session": {
                        "href": "\(session)"
                    }
                }
            }
            """
    }

    private func successfulPaymentsCvcSessionResponse(session: String) -> String {
        return """
            {
                "_links": {
                    "sessions:session": {
                        "href": "\(session)"
                    }
                }
            }
            """
    }

    private func toJSONString(_ error: AccessCheckoutError) -> String {
        return String(data: try! JSONEncoder().encode(error), encoding: .utf8)!
    }

    private func toJSON(_ content: String) throws -> Any? {
        let data = content.data(using: .utf8)

        return try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
    }
}
