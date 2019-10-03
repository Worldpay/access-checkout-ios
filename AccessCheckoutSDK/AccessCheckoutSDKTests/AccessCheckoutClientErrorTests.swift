//
//  AccessCheckoutClientErrorTests.swift
//  AccessCheckoutSDKTests
//
//  Created by Matt Davison on 03/10/2019.
//  Copyright © 2019 Worldpay. All rights reserved.
//

import XCTest
@testable import AccessCheckoutSDK

class AccessCheckoutClientErrorTests: XCTestCase {
    
    let expectedMessage = "Some error message"
    let expectedJsonPath = "json.path"
    let accessDeniedJSON = """
{"errorName": "accessDenied", "message": "Access is denied"}
"""
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCodable() {
        let data = Data(accessDeniedJSON.utf8)
        let error = try? JSONDecoder().decode(AccessCheckoutClientError.self, from: data)
        XCTAssertEqual(error?.errorName, "accessDenied")
        XCTAssertNotNil(try? JSONEncoder().encode(error))
    }

    func testLocalizedDescription_accessDenied() {
        assertLocalizedDescription(error: AccessCheckoutClientError.accessDenied(message: expectedMessage), withMessage: expectedMessage)
        assertLocalizedDescription(error: AccessCheckoutClientError.accessDenied(message: nil))
    }
    
    func testLocalizedDescription_apiRateLimitExceeded() {
        assertLocalizedDescription(error: AccessCheckoutClientError.apiRateLimitExceeded(message: expectedMessage),
                                   withMessage: expectedMessage)
        assertLocalizedDescription(error: AccessCheckoutClientError.apiRateLimitExceeded(message: nil))
    }
    
    func testLocalizedDescription_bodyDoesNotMatchSchema() {
        let validationMessage = "some validation problem"
        let validationError = AccessCheckoutClientValidationError.unrecognizedField(message: validationMessage,
                                                                                    jsonPath: expectedJsonPath)
        assertLocalizedDescription(error: AccessCheckoutClientError.bodyDoesNotMatchSchema(message: expectedMessage,
                                                                                           validationErrors: [validationError]),
                                   withMessage: expectedMessage,
                                   withJsonPath: expectedJsonPath,
                                   withValidationMessages: [validationMessage])
        assertLocalizedDescription(error: AccessCheckoutClientError.bodyDoesNotMatchSchema(message: nil,
                                                                                           validationErrors: nil))
    }
    
    func testLocalizedDescription_bodyIsEmpty() {
        assertLocalizedDescription(error: AccessCheckoutClientError.bodyIsEmpty(message: expectedMessage),
                                   withMessage: expectedMessage)
        assertLocalizedDescription(error: AccessCheckoutClientError.bodyIsEmpty(message: nil))
    }
    
    func testLocalizedDescription_bodyIsNotJson() {
        assertLocalizedDescription(error: AccessCheckoutClientError.bodyIsNotJson(message: expectedMessage),
                                   withMessage: expectedMessage)
        assertLocalizedDescription(error: AccessCheckoutClientError.bodyIsNotJson(message: nil))
    }
    
    func testLocalizedDescription_endpointNotFound() {
        assertLocalizedDescription(error: AccessCheckoutClientError.endpointNotFound(message: expectedMessage),
                                   withMessage: expectedMessage)
        assertLocalizedDescription(error: AccessCheckoutClientError.endpointNotFound(message: nil))
    }
    
    func testLocalizedDescription_fieldHasInvalidValue() {
        assertLocalizedDescription(error: AccessCheckoutClientError.fieldHasInvalidValue(message: expectedMessage,
                                                                                         jsonPath: expectedJsonPath),
                                   withMessage: expectedMessage,
                                   withJsonPath: expectedJsonPath)
        assertLocalizedDescription(error: AccessCheckoutClientError.fieldHasInvalidValue(message: nil,
                                                                                         jsonPath: nil))
    }
    
    func testLocalizedDescription_internalErrorTokenNotCreated() {
        assertLocalizedDescription(error: AccessCheckoutClientError.internalErrorTokenNotCreated(message: expectedMessage),
                                   withMessage: expectedMessage)
        assertLocalizedDescription(error: AccessCheckoutClientError.internalErrorTokenNotCreated(message: nil))
    }
    
    func testLocalizedDescription_internalServerError() {
        assertLocalizedDescription(error: AccessCheckoutClientError.internalServerError(message: expectedMessage),
                                   withMessage: expectedMessage)
        assertLocalizedDescription(error: AccessCheckoutClientError.internalServerError(message: nil))
    }
    
    func testLocalizedDescription_invalidCredentials() {
        assertLocalizedDescription(error: AccessCheckoutClientError.invalidCredentials(message: expectedMessage),
                                   withMessage: expectedMessage)
        assertLocalizedDescription(error: AccessCheckoutClientError.invalidCredentials(message: nil))
    }
    
    func testLocalizedDescription_maximumUpdatesExceeded() {
        assertLocalizedDescription(error: AccessCheckoutClientError.maximumUpdatesExceeded(message: expectedMessage),
                                   withMessage: expectedMessage)
        assertLocalizedDescription(error: AccessCheckoutClientError.maximumUpdatesExceeded(message: nil))
    }
    
    func testLocalizedDescription_methodNotAllowed() {
        assertLocalizedDescription(error: AccessCheckoutClientError.methodNotAllowed(message: expectedMessage),
                                   withMessage: expectedMessage)
        assertLocalizedDescription(error: AccessCheckoutClientError.methodNotAllowed(message: nil))
    }
    
    func testLocalizedDescription_notTokenizable() {
        assertLocalizedDescription(error: AccessCheckoutClientError.notTokenizable(message: expectedMessage),
                                   withMessage: expectedMessage)
        assertLocalizedDescription(error: AccessCheckoutClientError.notTokenizable(message: nil))
    }
    
    func testLocalizedDescription_resourceNotFound() {
        assertLocalizedDescription(error: AccessCheckoutClientError.resourceNotFound(message: expectedMessage),
                                   withMessage: expectedMessage)
        assertLocalizedDescription(error: AccessCheckoutClientError.resourceNotFound(message: nil))
    }
    
    func testLocalizedDescription_sessionNotFound() {
        assertLocalizedDescription(error: AccessCheckoutClientError.sessionNotFound(message: expectedMessage),
                                   withMessage: expectedMessage)
        assertLocalizedDescription(error: AccessCheckoutClientError.sessionNotFound(message: nil))
    }
    
    func testLocalizedDescription_tokenExpiryDateExceededMaximum() {
        assertLocalizedDescription(error: AccessCheckoutClientError.tokenExpiryDateExceededMaximum(message: expectedMessage),
                                   withMessage: expectedMessage)
        assertLocalizedDescription(error: AccessCheckoutClientError.tokenExpiryDateExceededMaximum(message: nil))
    }
    
    func testLocalizedDescription_tooManyTokensForNamespace() {
        assertLocalizedDescription(error: AccessCheckoutClientError.tooManyTokensForNamespace(message: expectedMessage),
                                   withMessage: expectedMessage)
        assertLocalizedDescription(error: AccessCheckoutClientError.tooManyTokensForNamespace(message: nil))
    }
    
    func testLocalizedDescription_unauthorized() {
        assertLocalizedDescription(error: AccessCheckoutClientError.unauthorized(message: expectedMessage),
                                   withMessage: expectedMessage)
        assertLocalizedDescription(error: AccessCheckoutClientError.unauthorized(message: nil))
    }
    
    func testLocalizedDescription_undiscoverable() {
        assertLocalizedDescription(error: AccessCheckoutClientError.undiscoverable(message: expectedMessage),
                                   withMessage: expectedMessage)
        assertLocalizedDescription(error: AccessCheckoutClientError.undiscoverable(message: nil))
    }
    
    func testLocalizedDescription_unknown() {
        assertLocalizedDescription(error: AccessCheckoutClientError.unknown(message: expectedMessage),
                                   withMessage: expectedMessage)
        assertLocalizedDescription(error: AccessCheckoutClientError.unknown(message: nil))
    }
    
    func testLocalizedDescription_unrecognizedCardBrand() {
        assertLocalizedDescription(error: AccessCheckoutClientError.unrecognizedCardBrand(message: expectedMessage),
                                   withMessage: expectedMessage)
        assertLocalizedDescription(error: AccessCheckoutClientError.unrecognizedCardBrand(message: nil))
    }
    
    func testLocalizedDescription_unsupportedAcceptHeader() {
        assertLocalizedDescription(error: AccessCheckoutClientError.unsupportedAcceptHeader(message: expectedMessage),
                                   withMessage: expectedMessage)
        assertLocalizedDescription(error: AccessCheckoutClientError.unsupportedAcceptHeader(message: nil))
    }
    
    func testLocalizedDescription_unsupportedCardBrand() {
        assertLocalizedDescription(error: AccessCheckoutClientError.unsupportedCardBrand(message: expectedMessage),
                                   withMessage: expectedMessage)
        assertLocalizedDescription(error: AccessCheckoutClientError.unsupportedCardBrand(message: nil))
    }
    
    func testLocalizedDescription_unsupportedContentType() {
        assertLocalizedDescription(error: AccessCheckoutClientError.unsupportedContentType(message: expectedMessage),
                                   withMessage: expectedMessage)
        assertLocalizedDescription(error: AccessCheckoutClientError.unsupportedContentType(message: nil))
    }
    
    func testLocalizedDescription_unsupportedVerificationCurrency() {
        assertLocalizedDescription(error: AccessCheckoutClientError.unsupportedVerificationCurrency(message: expectedMessage,
                                                                                                    jsonPath: expectedJsonPath),
                                   withMessage: expectedMessage,
                                   withJsonPath: expectedJsonPath)
        assertLocalizedDescription(error: AccessCheckoutClientError.unsupportedVerificationCurrency(message: nil,
                                                                                                    jsonPath: nil))
    }
    
    
    private func assertLocalizedDescription(error: AccessCheckoutClientError,
                                            withMessage message: String? = nil,
                                            withJsonPath jsonPath: String? = nil,
                                            withValidationMessages validationMessages: [String]? = nil) {
        let localizedDescription = error.localizedDescription
        XCTAssertTrue(localizedDescription.contains(error.errorName))
        if let expectedMessage = message {
            XCTAssertTrue(localizedDescription.contains(expectedMessage))
        }
        if let expectedJsonPath = jsonPath {
            XCTAssertTrue(localizedDescription.contains(expectedJsonPath))
        }
        validationMessages?.forEach { XCTAssertTrue(localizedDescription.contains($0)) }
    }
}

