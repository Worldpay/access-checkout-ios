import Dispatch

class CardBrandsConfigurationProvider {
    private let factory: CardBrandsConfigurationFactory
    private let serialQueue = DispatchQueue(label: "com.worldpay.access.checkout.CardBrandsConfigurationProvider")
    
    private var configuration: CardBrandsConfiguration
    
    init(_ cardBrandsConfigurationFactory: CardBrandsConfigurationFactory) {
        factory = cardBrandsConfigurationFactory
        configuration = cardBrandsConfigurationFactory.emptyConfiguration()
    }
    
    func retrieveRemoteConfiguration(baseUrl: String, acceptedCardBrands: [String]) {
        factory.create(baseUrl: baseUrl, acceptedCardBrands: acceptedCardBrands) { configuration in
            self.serialQueue.async { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.configuration = configuration
            }
        }
    }
    
    func get() -> CardBrandsConfiguration {
        serialQueue.sync {
            configuration
        }
    }
}
