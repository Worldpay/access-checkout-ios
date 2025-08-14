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
        let factoryMock = MockServiceDiscoveryResponseFactory()
        let apiResponseLookUpMock = MockApiResponseLinkLookup()

        ServiceDiscoveryProvider.shared.clearCache()
        ServiceDiscoveryProvider.shared = ServiceDiscoveryProvider(
            factoryMock, apiResponseLookUpMock)

        // simulate access root discovery and sessions discovery responses
        // a response with actual links is not needed, just a valid response
        factoryMock.getStubbingProxy()
            .create(request: any(), completionHandler: any())
            .then {
                _, completionHandler in
                completionHandler(Result.success(self.toApiReponse()))
            }.then {
                _, completionHandler in
                completionHandler(Result.success(self.toApiReponse()))
            }

        // simulate api response link lookups
        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: any(), in: any())
            .thenReturn("sessionsServiceLink")  // access root discovery lookup
            .thenReturn("card-bin-url")  // card bin lookup
            .thenReturn(cardUrlToReturn)  // sessions discovery lookup for card sessions
            .thenReturn(cvcUrlToReturn)  // sessions discovery lookup for cvc sessions

        ServiceDiscoveryProvider.discover(baseUrl: "some-url") { result in }
    }

    static func clearServiceDiscoveryCache() {
        ServiceDiscoveryProvider.shared.clearCache()
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
