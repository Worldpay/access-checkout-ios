import Foundation

class URLSessionMock: URLSession {
    private let urlSessionDataTask: URLSessionDataTask
    private(set) var dataTaskCalled = false
    private var forRequest: URLRequest

    init(forRequest: URLRequest, usingDataTask: URLSessionDataTask) {
        self.forRequest = forRequest
        self.urlSessionDataTask = usingDataTask
    }

    override func dataTask(
        with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        if request == forRequest {
            self.dataTaskCalled = true
            return urlSessionDataTask
        } else {
            return URLSessionDataTaskMock()
        }
    }
}
