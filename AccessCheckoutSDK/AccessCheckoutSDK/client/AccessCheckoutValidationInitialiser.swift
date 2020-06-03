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
    
    public func initialise(panView: PANView, expiryDateView: ExpiryDateView, cvvView: CVVView, baseUrl: String, cardDelegate: AccessCardDelegate) {
        configurationProvider.retrieveRemoteConfiguration(baseUrl: baseUrl)
        
//        cardBrandsConfigurationFactory.create(baseUrl: baseUrl) { _ in
//            let config = AccessCardConfiguration.init(defaults: AccessCardConfiguration.CardDefaults.baseDefaults(), brands: [])
        let validationStateHandler = CardValidationStateHandler(accessCardDelegate: cardDelegate)
        
        let cvvFlow = CvvValidationFlow(cvvValidator: CvvValidator(), cvvValidationStateHandler: validationStateHandler)
        
        let panValidator = PanValidator(configurationProvider)
        let panValidationFlow = PanValidationFlow(panValidator, validationStateHandler, cvvFlow)
        
        panView.presenter = PANViewPresenter(panValidationFlow)
        expiryDateView.presenter = ExpiryDateViewPresenter()
        cvvView.presenter = CVVViewForCardPaymentFlowPresenter()
        
        // cardDelegate.handlePanValidationChange(isValid: true)
    }
    
    public func initialise(cvvView: CVVView) {
        cvvView.presenter = CVVViewForCvvOnlyFlowPresenter()
    }
}
