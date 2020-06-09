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
        } else if validationConfiguration is CvvOnlyValidationConfig {
            initialiseForCvvOnlyFlow(validationConfiguration as! CvvOnlyValidationConfig)
        }
    }
    
    private func initialiseForCardPaymentFlow(_ config: CardValidationConfig) {
        configurationProvider.retrieveRemoteConfiguration(baseUrl: config.accessBaseUrl)
        
        let validationStateHandler = CardValidationStateHandler(config.validationDelegate)
        let cvvValidationFlow = CvvValidationFlow(CvvValidator(), validationStateHandler)
        
        config.cvvView.presenter = CVVViewPresenter(cvvValidationFlow)
        config.panView.presenter = panViewPresenter(configurationProvider, cvvValidationFlow, validationStateHandler)
        config.expiryDateView.presenter = expiryDateViewPresenter(validationStateHandler)
    }
    
    private func initialiseForCvvOnlyFlow(_ config: CvvOnlyValidationConfig) {
        let validationStateHandler = CvvOnlyValidationStateHandler(config.validationDelegate)
        let cvvValidationFlow = CvvValidationFlow(CvvValidator(), validationStateHandler)
        
        config.cvvView.presenter = CVVViewPresenter(cvvValidationFlow)
    }
    
    private func panViewPresenter(_ configurationProvider: CardBrandsConfigurationProvider,
                                  _ cvvValidationFlow: CvvValidationFlow,
                                  _ validationStateHandler: PanValidationStateHandler) -> PanViewPresenter {
        let panValidator = PanValidator(configurationProvider)
        let panValidationFlow = PanValidationFlow(panValidator, validationStateHandler, cvvValidationFlow)
        return PanViewPresenter(panValidationFlow, panValidator)
    }
    
    private func expiryDateViewPresenter(_ validationStateHandler: ExpiryDateValidationStateHandler) -> ExpiryDateViewPresenter {
        let expiryDateValidator = ExpiryDateValidator()
        let expiryDateValidationFlow = ExpiryDateValidationFlow(expiryDateValidator, validationStateHandler)
        return ExpiryDateViewPresenter(expiryDateValidationFlow)
    }
}
