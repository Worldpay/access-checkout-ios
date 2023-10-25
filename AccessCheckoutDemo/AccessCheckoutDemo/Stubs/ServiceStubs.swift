import Foundation
import Swifter

private let httpServer: HttpServer = .init()

struct ServiceStubs {
    static let port:UInt16 = 8123
    static var baseUri: String {
        get {
            return "http://localhost:\(port)"
        }
    }
    
    let baseUri:String = ServiceStubs.baseUri
    
    func discovery() throws -> ServiceStubs {
        guard let jsonAsData = try stubResponseAsJSON(LaunchArguments.DiscoveryStub) else {
            return self
        }

        httpServer.GET[""] = { _ in .ok(.json(jsonAsData)) }
        httpServer.GET["/"] = { _ in .ok(.json(jsonAsData)) }
        return self
    }

    func verifiedTokensRoot() throws -> ServiceStubs {
        guard let jsonAsData = try stubResponseAsJSON(LaunchArguments.VerifiedTokensStub) else {
            return self
        }

        httpServer.GET["/verifiedTokens"] = { _ in
            .ok(.json(jsonAsData))
        }
        return self
    }

    func verifiedTokensSessions() throws -> ServiceStubs {
        guard let jsonAsData = try stubResponseAsJSON(LaunchArguments.VerifiedTokensSessionStub) else {
            return self
        }

        //    func checkBody(_ method: HTTPMethod, _ uri: String) -> (_ request: URLRequest) -> Bool {
        //        return { (request: URLRequest) in
        //            let body = request.httpBodyStream?.readfully() ?? Data()
        //            let parsedJson = try? JSONSerialization.jsonObject(with: body)
        //            guard let jsonDict = parsedJson as? [String: AnyObject] else { return false }
        //
        //            guard let pan = jsonDict["cardNumber"] as? String else { return false }
        //
        //            let range = NSRange(location: 0, length: pan.utf16.count)
        //            let regex = try! NSRegularExpression(pattern: "^[0-9]+$")
        //            if regex.firstMatch(in: pan, options: [], range: range) == nil {
        //                return false
        //            }
        //
        //            if let requestMethod = request.httpMethod {
        //                if requestMethod == method.description {
        //                    return Mockingjay.uri(uri)(request)
        //                }
        //            }
        //
        //            return false
        //        }
        //    }
        // }
        httpServer.POST["/verifiedTokens/sessions"] = { _ in
//            let utf8String = String(bytes: request.body, encoding: .utf8)
//            NSLog("BODY of request to /verifiedTokens/sessions")
//            NSLog("> Start")
//            NSLog(utf8String!)
//            NSLog("> End")
            .ok(.json(jsonAsData))
        }
        return self
    }

    func cardConfiguration() throws -> ServiceStubs {
        guard let jsonAsData = try stubResponseAsJSON(LaunchArguments.CardConfigurationStub) else {
            return self
        }

        httpServer.GET["/access-checkout/cardTypes.json"] = { _ in
            .ok(.json(jsonAsData))
        }
        return self
    }

    func sessionsRoot() throws -> ServiceStubs {
        guard let jsonAsData = try stubResponseAsJSON(LaunchArguments.SessionsStub) else {
            return self
        }

        httpServer.GET["/sessions"] = { _ in
            .ok(.json(jsonAsData))
        }
        return self
    }

    func sessionsPaymentsCvc() throws -> ServiceStubs {
        guard let jsonAsData = try stubResponseAsJSON(LaunchArguments.SessionsPaymentsCvcStub) else {
            return self
        }

        httpServer.POST["/sessions/payments/cvc"] = { _ in
            .ok(.json(jsonAsData))
        }
        return self
    }
    
    func start() {
        try! httpServer.start(ServiceStubs.port)
    }
    
    func stop() {
        httpServer.stop()
    }

    private func stubResponseAsJSON(_ launchArgumentName: String) throws -> Any? {
        guard let resourceName = LaunchArguments.valueOf(launchArgumentName) else {
            throw StubsConfigurationError("failed to find value for launch argument with name \(launchArgumentName)")
        }

        guard let data = try? StubResponse(resourceName).toJSON(replaceBaseUriWith: baseUri)
        else {
            throw StubsConfigurationError("failed to find or decode resource in the 'Stubs' folder with name \(resourceName)")
        }

        return data
    }
}

struct StubsConfigurationError: Error {
    public let message: String

    init(_ message: String) {
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
