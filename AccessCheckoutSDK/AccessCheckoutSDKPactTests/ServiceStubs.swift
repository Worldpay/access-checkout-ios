import Swifter

@testable import AccessCheckoutSDK

struct ServiceStubs {
    init() {
        self.port = UInt16.random(in: 7000..<8000)
        self.httpServer = .init()
        // Address the stub via `127.0.0.1` rather than `localhost`. On newer iOS
        // simulators (Xcode 26/27) `localhost` resolves to IPv6 `::1` first, but the
        // stub below is started as an IPv4-only socket, so a `localhost` client would
        // try `::1`, fail to connect and (via retries) time out. Pinning both ends to
        // IPv4 keeps the behaviour deterministic across Xcode/simulator versions.
        self.baseUrl = "http://127.0.0.1:\(port)"
    }

    let baseUrl: String

    private let port: UInt16
    private let httpServer: HttpServer

    func get200(path: String, jsonResponse: String) -> ServiceStubs {
        let jsonData = try! toJSON(jsonResponse)
        httpServer.GET[path] = { _ in .ok(.json(jsonData as AnyObject)) }
        return self
    }

    func start() {
        // Force an IPv4 socket so the server is reachable via `127.0.0.1`.
        try! httpServer.start(port, forceIPv4: true)
    }

    func stop() {
        httpServer.stop()
    }

    private func toJSON(_ content: String) throws -> Any? {
        let data = content.data(using: .utf8)

        return try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
    }
}
