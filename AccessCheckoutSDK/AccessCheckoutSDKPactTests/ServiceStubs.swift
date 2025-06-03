import Swifter

@testable import AccessCheckoutSDK

struct ServiceStubs {
    init() {
        self.port = UInt16.random(in: 7000..<8000)
        self.httpServer = .init()
        self.baseUrl = "http://localhost:\(port)"
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
        try! httpServer.start(port)
    }

    func stop() {
        httpServer.stop()
    }

    private func toJSON(_ content: String) throws -> Any? {
        let data = content.data(using: .utf8)

        return try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
    }
}
