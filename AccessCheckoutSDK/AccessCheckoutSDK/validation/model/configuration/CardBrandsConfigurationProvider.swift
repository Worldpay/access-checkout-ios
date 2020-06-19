class CardBrandsConfigurationProvider {
    private let factory:CardBrandsConfigurationFactory
    private let concurrentQueue = DispatchQueue(label: "com.worldpay.access.checkout.CardBrandsConfigurationProvider")
    
    private var configuration:CardBrandsConfiguration
    
    init (_ cardBrandsConfigurationFactory:CardBrandsConfigurationFactory) {
        factory = cardBrandsConfigurationFactory
        configuration = cardBrandsConfigurationFactory.emptyConfiguration()
    }
    
    func retrieveRemoteConfiguration(baseUrl:String) {
        factory.create(baseUrl: baseUrl) { configuration in
            self.concurrentQueue.async(flags: .barrier) { [weak self] in
              guard let self = self else {
                return
              }

              self.configuration = configuration
            }
        }
    }
    
    func get() -> CardBrandsConfiguration {
        concurrentQueue.sync {
            return configuration
        }
    }
}
