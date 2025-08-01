import Foundation
@testable import AccessCheckoutSDK

class ServiceDiscoveryFactoryMock: ServiceDiscoveryResponseFactory {
    private(set) var getDiscoveryCalledCount = 0
    private(set) var requestsSent: [URLRequest] = []
    var mockReturnValue: [Any?] = [] // Store ApiResponse? for each call
    
    override func create(
        request: URLRequest,
        completionHandler: @escaping (ApiResponse?) -> Void
    ) {
        getDiscoveryCalledCount += 1
        requestsSent.append(request)
        
        if !mockReturnValue.isEmpty, let result = mockReturnValue.removeFirst() as? ApiResponse? {
            completionHandler(result)
        }
    }
}
