public struct AccessCheckoutValidationInitialiser {
    private var configurationProvider: CardBrandsConfigurationProvider
    
    public init() {
        let restClient = RestClient()
        let transformer = CardBrandDtoTransformer()
        let configurationFactory = CardBrandsConfigurationFactory(restClient, transformer)
        
        self.configurationProvider = CardBrandsConfigurationProvider(configurationFactory)
    }
    
    init(_ cardBrandsConfigurationProvider: CardBrandsConfigurationProvider) {
        self.configurationProvider = cardBrandsConfigurationProvider
    }
    
    public func initialise(_ validationConfiguration: ValidationConfig) {
        if validationConfiguration is CardValidationConfig {
            initialiseForCardPaymentFlow(validationConfiguration as! CardValidationConfig)
        } else if validationConfiguration is CvcOnlyValidationConfig {
            initialiseForCvcOnlyFlow(validationConfiguration as! CvcOnlyValidationConfig)
        }
    }
    
    private func initialiseForCardPaymentFlow(_ config: CardValidationConfig) {
        configurationProvider.retrieveRemoteConfiguration(baseUrl: config.accessBaseUrl)
        
        let validationStateHandler = CardValidationStateHandler(config.validationDelegate)
        let cvcValidator = CvcValidator()
        let cvcValidationFlow = CvcValidationFlow(cvcValidator, validationStateHandler)
        
        config.cvcView.presenter = CvcViewPresenter(cvcValidationFlow, cvcValidator)
        config.panView.presenter = panViewPresenter(configurationProvider, cvcValidationFlow, validationStateHandler)
        config.expiryDateView.presenter = expiryDateViewPresenter(validationStateHandler)
    }
    
    private func initialiseForCvcOnlyFlow(_ config: CvcOnlyValidationConfig) {
        let validationStateHandler = CvcOnlyValidationStateHandler(config.validationDelegate)
        let cvcValidator = CvcValidator()
        let cvcValidationFlow = CvcValidationFlow(cvcValidator, validationStateHandler)
        
        config.cvcView.presenter = CvcViewPresenter(cvcValidationFlow, cvcValidator)
    }
    
    private func panViewPresenter(_ configurationProvider: CardBrandsConfigurationProvider,
                                  _ cvcValidationFlow: CvcValidationFlow,
                                  _ validationStateHandler: PanValidationStateHandler) -> PanViewPresenter {
        let panValidator = PanValidator(configurationProvider)
        let panValidationFlow = PanValidationFlow(panValidator, validationStateHandler, cvcValidationFlow)
        return PanViewPresenter(panValidationFlow, panValidator)
    }
    
    private func expiryDateViewPresenter(_ validationStateHandler: ExpiryDateValidationStateHandler) -> ExpiryDateViewPresenter {
        let expiryDateValidator = ExpiryDateValidator()
        let expiryDateValidationFlow = ExpiryDateValidationFlow(expiryDateValidator, validationStateHandler)
        return ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidator)
    }
}
