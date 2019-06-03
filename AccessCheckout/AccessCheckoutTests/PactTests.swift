//
//  PactTests.swift
//  AccessCheckoutTests
//
//  Created by Matt Davison on 03/06/2019.
//  Copyright © 2019 Worldpay. All rights reserved.
//

import XCTest
import PactConsumerSwift
import Mockingjay
@testable import AccessCheckout

class PactTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    let verifiedTokensMockService = MockService(provider: "verified-tokens",
                                                consumer: "access-checkout-iOS-sdk")

    func testGetSession() {
        
        let baseURI = "https://access.worldpay.com"
        guard let url = Bundle(for: type(of: self)).url(forResource: "VerifiedTokens-success",
                                                        withExtension: "json") else {
            XCTFail()
            return
        }
        guard let vtsStubFormat = try? String(contentsOf: url) else {
            XCTFail()
            return
        }
        let vtsStub = String(format: vtsStubFormat, baseURI)
        
        guard let vtsData = vtsStub.data(using: .utf8) else {
            XCTFail()
            return
        }
        
        let verifiedTokensPath = "/verifiedTokens"
        let uri = baseURI + verifiedTokensPath
        stub(http(.get, uri: uri), jsonData(vtsData))
        
//        let vtsRoot = "https://access.worldpay.com/verifiedTokens"
//        let vtsStubData = vtsRootEndpointResponse(verifiedTokensMockService.baseUrl).data(using: .utf8)!
//        stub(http(.get, uri: vtsRoot), jsonData(vtsStubData))
//
//
//
        let expectedHref = "\(baseURI)/verifiedTokens/sessions/token-id"
//        let jsonData = vtsSessionsResponse(expectedHref)
        
        guard let json = try? JSONSerialization.jsonObject(with: vtsData, options: .allowFragments) else {
            XCTFail()
            return
        }
        
        verifiedTokensMockService
            .given("a session is available")
            .uponReceiving("a request for verified tokens links")
            .withRequest(method: .GET, path: verifiedTokensPath)
            .willRespondWith(status: 200,
                             headers: ["Content-Type": "application/json"],
                             body: json)
        
        
        let accessDiscovery = AccessCheckoutDiscovery(baseUrl: URL(string: baseURI)!)
        let verifiedTokensClient = AccessCheckoutClient(discovery: accessDiscovery, merchantIdentifier: "identity")
        
        verifiedTokensMockService.run(timeout: 10) { testComplete in
            verifiedTokensClient.createSession(pan: "1234", expiryMonth: 0, expiryYear: 0, cvv: "123") { result in
                switch result {
                case .success(let href):
                    XCTAssertEqual(href, expectedHref)
                case .failure:
                    XCTFail()
                }
                testComplete()
            }
        }
    }

}
