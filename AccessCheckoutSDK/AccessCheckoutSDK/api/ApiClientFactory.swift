class ApiClientFactory {
    func createVerifiedTokensApiClient(baseUrl: String, merchantId: String) -> VerifiedTokensApiClient {
        let apiDiscoveryClient = createApiDiscoveryClient(baseUrl)
        return VerifiedTokensApiClient(discovery: apiDiscoveryClient, merchantIdentifier: merchantId)
    }
    
    func createSessionsApiClient(baseUrl: String, merchantId: String) -> SessionsApiClient {
        let apiDiscoveryClient = createApiDiscoveryClient(baseUrl)
        return SessionsApiClient(discovery: apiDiscoveryClient, merchantIdentifier: merchantId)
    }
    
    private func createApiDiscoveryClient(_ baseUrl: String) -> ApiDiscoveryClient {
        return ApiDiscoveryClient(baseUrl: URL(string: baseUrl)!)
    }
}
