struct UserAgent {
    static let headerName = "X-WP-SDK"
    static let valueFormat = "access-checkout-ios/%@"
    let headerValue: String
    
    init(bundle: Bundle) {
        let appVersion = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "unknown"
        self.headerValue = String(format: UserAgent.valueFormat, appVersion)
    }
}
