class CardBrandsConfigurationProvider {
    private let factory:CardBrandsConfigurationFactory
    private var configuration:CardBrandsConfiguration
    
    init (_ cardBrandsConfigurationFactory:CardBrandsConfigurationFactory) {
        factory = cardBrandsConfigurationFactory
        configuration = cardBrandsConfigurationFactory.createWithDefaultsOnly()
    }
    
    func retrieveRemoteConfiguration(baseUrl:String) {
        factory.create(baseUrl: baseUrl) { configuration in
            self.configuration = configuration
        }
    }
    
    func get() -> CardBrandsConfiguration {
        return configuration
    }
}
