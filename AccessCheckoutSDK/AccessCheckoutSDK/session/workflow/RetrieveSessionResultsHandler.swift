import Dispatch

class RetrieveSessionResultsHandler {
    private let numberOfExpectedResults: Int
    private let completionHandler: (Result<[SessionType: String], AccessCheckoutError>) -> Void
    private var sessions = [SessionType: String]()
    private var completionHandlerCalled = false
    
    private let serialQueue = DispatchQueue(label: "com.worldpay.access.checkout.RetrieveSessionResultsHandler")
    
    init(numberOfExpectedResults: Int, completeWith completionHandler: @escaping (Result<[SessionType: String], AccessCheckoutError>) -> Void) {
        self.numberOfExpectedResults = numberOfExpectedResults
        self.completionHandler = completionHandler
    }
    
    func handle(_ result: Result<String, AccessCheckoutError>, for sessionType: SessionType) {
        switch result {
        case .success(let session):
            serialQueue.async {
                self.sessions[sessionType] = session
                if self.hasAllResults() {
                    self.completionHandler(.success(self.sessions))
                }
            }
            
        case .failure(let error):
            serialQueue.async {
                if !self.completionHandlerCalled {
                    self.completionHandler(.failure(error))
                    self.completionHandlerCalled = true
                }
            }
        }
    }
    
    private func hasAllResults() -> Bool {
        return sessions.count == numberOfExpectedResults
    }
}
