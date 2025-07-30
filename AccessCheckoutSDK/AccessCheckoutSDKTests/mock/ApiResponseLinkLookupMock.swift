@testable import AccessCheckoutSDK

class ApiResponseLinkLookupMock: ApiResponseLinkLookup {
    private(set) var lookupMethodCalledCount = 0
    private(set) var lookupLinks: [String] = []

    var mockReturnValue: [String?] = []

    override func lookup(link: String, in apiResponse: ApiResponse) -> String? {
        lookupMethodCalledCount += 1
        lookupLinks.append(link)

        if !mockReturnValue.isEmpty {
            let result = mockReturnValue.removeFirst()
            return result
        }
        return nil
    }
}
