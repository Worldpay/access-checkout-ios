import Foundation
import Mockingjay

protocol ServiceStub {
    func start()
}

class DiscoveryStub : ServiceStub {
    let baseUri:String
    
    init(baseUri: String) {
        self.baseUri = baseUri
    }
    
    func start() {
        guard let resourceName = LaunchArguments.valueOf(LaunchArguments.DiscoveryStub),
            let data = JsonStubbedResponse(resourceName).toData(usingBaseUri: self.baseUri) else {
                return
        }
            
        MockingjayProtocol.addStub(matcher: http(.get, uri: self.baseUri), builder: jsonData(data))
    }
}

class VerifiedTokensStub : ServiceStub {
    let baseUri:String
    
    init(baseUri: String) {
        self.baseUri = baseUri
    }
    
    func start() {
        guard let resourceName = LaunchArguments.valueOf(LaunchArguments.VerifiedTokensStub),
            let data = JsonStubbedResponse(resourceName).toData(usingBaseUri: self.baseUri) else {
                return
        }
            
        MockingjayProtocol.addStub(matcher: http(.get, uri: "\(self.baseUri)/verifiedTokens"), builder: jsonData(data))
    }
}

class VerifiedTokensSessionStub : ServiceStub {
    let baseUri:String
    
    init(baseUri: String) {
        self.baseUri = baseUri
    }
    
    func start() {
        guard let resourceName = LaunchArguments.valueOf(LaunchArguments.VerifiedTokensSessionStub),
            let data = JsonStubbedResponse(resourceName).toData(usingBaseUri: self.baseUri) else {
                return
        }
            
        MockingjayProtocol.addStub(matcher: checkBody(.post, "\(self.baseUri)/verifiedTokens/sessions"), builder: jsonData(data))
    }
    
    func checkBody(_ method: HTTPMethod, _ uri: String) -> (_ request: URLRequest) -> Bool {
        return { (request:URLRequest) in
            let body = request.httpBodyStream?.readfully() ?? Data()
            let parsedJson = try? JSONSerialization.jsonObject(with: body)
            guard let jsonDict = parsedJson as? Dictionary<String, AnyObject> else { return false }

            guard let pan = jsonDict["cardNumber"] as? String else { return false }
            
            let range = NSRange(location: 0, length: pan.utf16.count)
            let regex = try! NSRegularExpression(pattern: "^[0-9]+$")
            if(regex.firstMatch(in: pan, options: [], range: range) == nil) {
                return false
            }
            
            if let requestMethod = request.httpMethod {
              if requestMethod == method.description {
                return Mockingjay.uri(uri)(request)
              }
            }
            
            return false
        }
    }
}

class CardConfigurationStub : ServiceStub {
    let baseUri:String
    let cardConfigurationUri:String
    
    init(baseUri: String, cardConfigurationUri: String) {
        self.baseUri = baseUri
        self.cardConfigurationUri = cardConfigurationUri
    }
    
    func start() {
        guard let resourceName = LaunchArguments.valueOf(LaunchArguments.CardConfigurationStub),
            let data = JsonStubbedResponse(resourceName).toData(usingBaseUri: self.baseUri) else {
                return
        }
            
        MockingjayProtocol.addStub(matcher: http(.get, uri: self.cardConfigurationUri), builder: jsonData(data))
    }
}

class SessionsStub : ServiceStub {
    let baseUri:String
    
    init(baseUri: String) {
        self.baseUri = baseUri
    }
    
    func start() {
        guard let resourceName = LaunchArguments.valueOf(LaunchArguments.SessionsStub),
            let data = JsonStubbedResponse(resourceName).toData(usingBaseUri: self.baseUri) else {
                return
        }
            
        MockingjayProtocol.addStub(matcher: http(.get, uri: "\(self.baseUri)/sessions"), builder: jsonData(data))
    }
}

class SessionsPaymentsCvcStub : ServiceStub {
    let baseUri:String
    
    init(baseUri: String) {
        self.baseUri = baseUri
    }
    
    func start() {
        guard let resourceName = LaunchArguments.valueOf(LaunchArguments.SessionsPaymentsCvcStub),
            let data = JsonStubbedResponse(resourceName).toData(usingBaseUri: self.baseUri) else {
                return
        }
            
        MockingjayProtocol.addStub(matcher: http(.post, uri: "\(self.baseUri)/sessions/payments/cvc"), builder: jsonData(data))
    }
}

import Foundation

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
