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
    
    public func initialise(panView: PANView, expiryDateView: ExpiryDateView, cvvView: CVVView, baseUrl: String, cardDelegate merchantDelegate: AccessCardDelegate) {
        configurationProvider.retrieveRemoteConfiguration(baseUrl: baseUrl)
        
        let validationStateHandler = CardValidationStateHandler(merchantDelegate)
        
        let cvvFlow = CvvValidationFlow(CvvValidator(), validationStateHandler)
        cvvView.presenter = CVVViewForCardPaymentFlowPresenter(cvvFlow)
        
        let panValidator = PanValidator(configurationProvider)
        let panValidationFlow = PanValidationFlow(panValidator, validationStateHandler, cvvFlow)
        panView.presenter = PanViewPresenter(panValidationFlow)
        
        let expiryDateValidator = ExpiryDateValidator()
        let expiryDateValidationFlow = ExpiryDateValidationFlow(expiryDateValidator, validationStateHandler)
        expiryDateView.presenter = ExpiryDateViewPresenter(expiryDateValidationFlow)
    }
    
    public func initialise(cvvView: CVVView, cvvOnlyDelegate merchantDelegate: AccessCvvOnlyDelegate) {
        // Rename merchant delegate anywhere where possible
        let validationStateHandler = CvvOnlyValidationStateHandler(merchantDelegate)
        let cvvFlow = CvvValidationFlow(CvvValidator(), validationStateHandler)
        cvvView.presenter = CVVViewForCvvOnlyFlowPresenter(cvvFlow)
    }
}
