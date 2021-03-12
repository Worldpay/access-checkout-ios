struct UserAgent {
    static let sdkVersion = "2.2.0"
    static private let valueFormat = "access-checkout-ios/%@"
    
    static let headerName = "X-WP-SDK"
    static let headerValue = String(format: valueFormat, UserAgent.sdkVersion)
}
