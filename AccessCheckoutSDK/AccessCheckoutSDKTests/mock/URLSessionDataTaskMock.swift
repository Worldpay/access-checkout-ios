import Foundation

class URLSessionDataTaskMock: URLSessionDataTask {
    private(set) var resumeCalled = false

    override func resume() {
        self.resumeCalled = true
    }
}
