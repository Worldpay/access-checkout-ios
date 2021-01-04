/**
 * Class that is responsible for initialising validation using a given `ValidationConfig`
 */
public struct AccessCheckoutValidationInitialiser {
    static var presenters = [Presenter]()
    
    private var configurationProvider: CardBrandsConfigurationProvider
    
    /**
     This initialiser should be used to create an instance of `AccessCheckoutValidationInitialiser`
     */
    public init() {
        let restClient = RestClient()
        let transformer = CardBrandDtoTransformer()
        let configurationFactory = CardBrandsConfigurationFactory(restClient, transformer)
        
        self.configurationProvider = CardBrandsConfigurationProvider(configurationFactory)
    }
    
    init(_ cardBrandsConfigurationProvider: CardBrandsConfigurationProvider) {
        self.configurationProvider = cardBrandsConfigurationProvider
    }
    
    /**
     This function should be used to initialise the validation using a given `ValidationConfig` provided by the merchant
     - Parameter validationConfig]: `ValidationConfig` that represents the configuration that should be used to initialise the validation
     */
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
        
        let panPresenter = panViewPresenter(configurationProvider, cvcValidationFlow, validationStateHandler)
        let expiryDatePresenter = expiryDateViewPresenter(validationStateHandler)
        let cvcPresenter = CvcViewPresenter(cvcValidationFlow, cvcValidator)
        
        if config.textFieldMode {
            AccessCheckoutValidationInitialiser.presenters.append(panPresenter)
            AccessCheckoutValidationInitialiser.presenters.append(expiryDatePresenter)
            AccessCheckoutValidationInitialiser.presenters.append(cvcPresenter)

            config.panTextField!.delegate = panPresenter
            config.panTextField!.addTarget(panPresenter, action: #selector(panPresenter.textFieldEditingChanged), for: .editingChanged)
        
            config.expiryDateTextField!.delegate = expiryDatePresenter
            config.expiryDateTextField!.addTarget(expiryDatePresenter, action: #selector(expiryDatePresenter.textFieldEditingChanged), for: .editingChanged)

            config.cvcTextField!.delegate = cvcPresenter
            config.cvcTextField!.addTarget(cvcPresenter, action: #selector(cvcPresenter.textFieldEditingChanged), for: .editingChanged)
        } else {
            config.cvcView!.presenter = cvcPresenter
            config.panView!.presenter = panPresenter
            config.expiryDateView!.presenter = expiryDatePresenter
        }
        
    }
    
    private func initialiseForCvcOnlyFlow(_ config: CvcOnlyValidationConfig) {
        let validationStateHandler = CvcOnlyValidationStateHandler(config.validationDelegate)
        let cvcValidator = CvcValidator()
        let cvcValidationFlow = CvcValidationFlow(cvcValidator, validationStateHandler)
        let cvcPresenter = CvcViewPresenter(cvcValidationFlow, cvcValidator)

        if config.textFieldMode {
            AccessCheckoutValidationInitialiser.presenters.append(cvcPresenter)
            
            config.cvcTextField!.delegate = cvcPresenter
            config.cvcTextField!.addTarget(cvcPresenter, action: #selector(cvcPresenter.textFieldEditingChanged), for: .editingChanged)
        } else {
            config.cvcView!.presenter = cvcPresenter
        }
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
