import XCTest
@testable import AccessCheckoutSDK

class BaseUrlSanitiserTests: XCTestCase {

    // MARK: - Nil / trailing slash

    func testAcceptsNilBaseUrl() throws {
        XCTAssertNil(try sanitise(nil))
    }

    func testRemovesTrailingSlashFromLocalhostUrl() throws {
        XCTAssertEqual("http://localhost:123", try sanitise("http://localhost:123/"))
    }

    func testRemovesTrailingSlashFromLoopbackUrl() throws {
        XCTAssertEqual("http://127.0.0.1:123", try sanitise("http://127.0.0.1:123/"))
    }

    func testRemovesTrailingSlashFromWorldpayUrl() throws {
        XCTAssertEqual("https://access.worldpay.com", try sanitise("https://access.worldpay.com/"))
    }

    func testDoesNotChangeValidUrl() throws {
        XCTAssertEqual("http://localhost:123", try sanitise("http://localhost:123"))
    }

    // MARK: - worldpay.com (https only, any subdomain)

    func testAcceptsHttpsWithSingleSubdomainOnWorldpay() throws {
        let url = "https://access.worldpay.com"
        XCTAssertEqual(url, try sanitise(url))
    }

    func testAcceptsHttpsWithMultiPartSubdomainOnWorldpay() throws {
        let url = "https://try.access.worldpay.com"
        XCTAssertEqual(url, try sanitise(url))
    }

    func testAcceptsHttpsWithHyphenatedSubdomainOnWorldpay() throws {
        let url = "https://my-service.worldpay.com"
        XCTAssertEqual(url, try sanitise(url))
    }

    func testAcceptsWorldpayWithoutSubdomain() throws {
        let url = "https://worldpay.com"
        XCTAssertEqual(url, try sanitise(url))
    }

    func testRejectsNonHttpProtocolOnWorldpay() {
        assertNotPermitted("ftp://access.worldpay.com")
    }

    func testRejectsHttpOnWorldpaySubdomain() {
        assertNotPermitted("http://access.worldpay.com")
    }

    func testRejectsWorldpaySubdomainWithPath() {
        assertNotPermitted("http://access.worldpay.com/some-path")
    }

    func testRejectsDifferentTldContainingWorldpay() {
        assertNotPermitted("https://evil.worldpay.com.attacker.com")
    }

    // MARK: - localhost

    func testAcceptsHttpLocalhostWithPort() throws {
        let url = "http://localhost:8080"
        XCTAssertEqual(url, try sanitise(url))
    }

    func testAcceptsHttpsLocalhostWithPort() throws {
        let url = "https://localhost:8443"
        XCTAssertEqual(url, try sanitise(url))
    }

    func testAcceptsLocalhostMinAndMaxPort() throws {
        XCTAssertEqual("http://localhost:1", try sanitise("http://localhost:1"))
        XCTAssertEqual("https://localhost:65535", try sanitise("https://localhost:65535"))
    }

    func testAcceptsLocalhostWithoutPortHttp() throws {
        let url = "http://localhost"
        XCTAssertEqual(url, try sanitise(url))
    }

    func testAcceptsLocalhostWithoutPortHttps() throws {
        let url = "https://localhost"
        XCTAssertEqual(url, try sanitise(url))
    }

    func testRejectsDomainContainingLocalhost() {
        assertNotPermitted("http://some-url-localhost-and-something-else")
    }

    func testRejectsLocalhostWithPath() {
        assertNotPermitted("http://localhost/some-path")
    }

    func testRejectsLocalhostWithNonNumericPort() {
        assertNotPermitted("http://localhost:abc")
    }

    // MARK: - 127.0.0.1

    func testRejectsDomainContainingLoopback() {
        assertNotPermitted("http://some-url-127.0.0.1-and-something-else")
    }

    func testAcceptsHttpLoopbackWithPort() throws {
        let url = "http://127.0.0.1:8080"
        XCTAssertEqual(url, try sanitise(url))
    }

    func testAcceptsHttpsLoopbackWithPort() throws {
        let url = "https://127.0.0.1:8443"
        XCTAssertEqual(url, try sanitise(url))
    }

    func testAcceptsLoopbackMinAndMaxPort() throws {
        XCTAssertEqual("http://127.0.0.1:1", try sanitise("http://127.0.0.1:1"))
        XCTAssertEqual("https://127.0.0.1:65535", try sanitise("https://127.0.0.1:65535"))
    }

    func testAcceptsLoopbackWithoutPortHttp() throws {
        let url = "http://127.0.0.1"
        XCTAssertEqual(url, try sanitise(url))
    }

    func testAcceptsLoopbackWithoutPortHttps() throws {
        let url = "https://127.0.0.1"
        XCTAssertEqual(url, try sanitise(url))
    }

    func testRejectsLoopbackWithPath() {
        assertNotPermitted("http://127.0.0.1/some-path")
    }

    func testRejectsLoopbackWithNonNumericPort() {
        assertNotPermitted("http://127.0.0.1:abc")
    }

    // MARK: - Helper

    // assertNotPermitted — compare the full error description
    private func assertNotPermitted(_ url: String) {
        XCTAssertThrowsError(try sanitise(url)) { error in
            guard case .notPermitted = error as? BaseUrlSanitiserError else {
                return XCTFail("Expected BaseUrlSanitiserError.notPermitted")
            }
            XCTAssertEqual(
                "base url '\(url)' is not permitted",
                error.localizedDescription
            )
        }
    }
}
