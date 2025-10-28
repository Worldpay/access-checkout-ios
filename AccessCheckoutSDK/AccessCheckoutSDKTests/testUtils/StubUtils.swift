import Cuckoo
import Swifter
import XCTest

@testable import AccessCheckoutSDK

class StubUtils {
    static func createError(errorName: String, message: String) -> AccessCheckoutError {
        let json = """
            {
                "errorName": "\(errorName)",
                "message": "\(message)"
            }
            """

        let jsonAsData = json.data(using: .utf8)!
        return try! JSONDecoder().decode(AccessCheckoutError.self, from: jsonAsData)
    }

    static func parseAccessCheckoutError(json: String) -> AccessCheckoutError {
        let jsonAsData = json.data(using: .utf8)!
        return try! JSONDecoder().decode(AccessCheckoutError.self, from: jsonAsData)
    }

    static func createApiValidationError(errorName: String, message: String, jsonPath: String)
        -> AccessCheckoutError.AccessCheckoutValidationError
    {
        let json = """
            {
                "errorName": "\(errorName)",
                "message": "\(message)",
                "jsonPath": "\(jsonPath)"
            }
            """

        let jsonAsData = json.data(using: .utf8)!
        return try! JSONDecoder().decode(
            AccessCheckoutError.AccessCheckoutValidationError.self, from: jsonAsData)
    }

    static func createApiError(
        errorName: String, message: String,
        validationErrors: [AccessCheckoutError.AccessCheckoutValidationError]
    ) -> AccessCheckoutError {
        var validationErrorsJson = [String]()

        for error in validationErrors {
            let jsonError = """
                {
                    "errorName": "\(error.errorName)",
                    "message": "\(error.message)",
                    "jsonPath": "\(error.jsonPath)"
                }
                """
            validationErrorsJson.append(jsonError)
        }

        let json = """
            {
                "errorName": "\(errorName)",
                "message": "\(message)",
                "validationErrors" : [\(validationErrorsJson.joined(separator: ","))]
            }
            """

        let jsonAsData = json.data(using: .utf8)!
        return try! JSONDecoder().decode(AccessCheckoutError.self, from: jsonAsData)
    }

    static func setUpServiceDiscovery(
        cardUrlToReturn: String? = "cardHref",
        cvcUrlToReturn: String? = "cvcHref"
    ) {
        let restClientMock = MockRetryRestClientDecorator<ApiResponse>()
        let apiResponseLookUpMock = MockApiResponseLinkLookup()

        ServiceDiscoveryProvider.clearCache()
        try? ServiceDiscoveryProvider.initialise("some-url", restClientMock, apiResponseLookUpMock)

        // simulate access root discovery and sessions discovery responses
        // a response with actual links is not needed, just a valid response
        restClientMock.getStubbingProxy()
            .send(urlSession: any(), request: any(), completionHandler: any())
            .then {
                _, _, completionHandler in
                completionHandler(Result.success(self.toApiReponse()), nil)
                return URLSessionTask()
            }.then {
                _, _, completionHandler in
                completionHandler(Result.success(self.toApiReponse()), nil)
                return URLSessionTask()
            }

        // simulate api response link lookups
        apiResponseLookUpMock
            .getStubbingProxy().lookup(link: ApiLinks.cardSessions.service, in: any())
            .thenReturn("sessionsServiceLink")  // access root discovery lookup

        apiResponseLookUpMock
            .getStubbingProxy().lookup(link: ApiLinks.cardBin.endpoint, in: any())
            .thenReturn("card-bin-url")  // card bin lookup

        apiResponseLookUpMock
            .getStubbingProxy().lookup(link: ApiLinks.cardSessions.endpoint, in: any())
            .thenReturn(cardUrlToReturn)  // sessions discovery lookup for card sessions

        apiResponseLookUpMock
            .getStubbingProxy().lookup(link: ApiLinks.cvcSessions.endpoint, in: any())
            .thenReturn(cvcUrlToReturn)  // sessions discovery lookup for cvc sessions

        ServiceDiscoveryProvider.discoverAll { result in }
    }

    static func clearServiceDiscoveryCache() {
        ServiceDiscoveryProvider.clearCache()
    }

    private static func toApiReponse() -> ApiResponse {
        let responseAsString =
            """
                {
                    "_links": {
                        "some:service": {
                            "href": "some-href"
                        }
                    }
                }
            """

        let responseAsData = responseAsString.data(using: .utf8)!
        return try! JSONDecoder().decode(ApiResponse.self, from: responseAsData)
    }
}
