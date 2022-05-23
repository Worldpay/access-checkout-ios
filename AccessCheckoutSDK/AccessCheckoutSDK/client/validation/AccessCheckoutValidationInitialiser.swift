import UIKit

/**
 * Class that is responsible for initialising validation using a given `ValidationConfig`
 */
public struct AccessCheckoutValidationInitialiser {
    private static var presenters = [Presenter]()
    
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
        configurationProvider.retrieveRemoteConfiguration(baseUrl: config.accessBaseUrl, acceptedCardBrands: config.acceptedCardBrands)
        
        let validationStateHandler = CardValidationStateHandler(config.validationDelegate)
        let cvcValidator = CvcValidator()
        let cvcValidationFlow = CvcValidationFlow(cvcValidator, validationStateHandler)
        
        let panPresenter = panViewPresenter(configurationProvider, cvcValidationFlow, validationStateHandler, config.panFormattingEnabled)
        let expiryDatePresenter = expiryDateViewPresenter(validationStateHandler)
        let cvcPresenter = CvcViewPresenter(cvcValidationFlow, cvcValidator)
        
        if config.textFieldMode {
            setTextFieldDelegate(textField: config.panTextField!, delegate: panPresenter)
            setTextFieldDelegate(textField: config.expiryDateTextField!, delegate: expiryDatePresenter)
            setTextFieldDelegate(textField: config.cvcTextField!, delegate: cvcPresenter)
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
            setTextFieldDelegate(textField: config.cvcTextField!, delegate: cvcPresenter)
        } else {
            config.cvcView!.presenter = cvcPresenter
        }
    }
    
    private func panViewPresenter(_ configurationProvider: CardBrandsConfigurationProvider,
                                  _ cvcValidationFlow: CvcValidationFlow,
                                  _ validationStateHandler: PanValidationStateHandler,
                                  _ panFormattingEnabled: Bool) -> PanViewPresenter {
        let panValidator = PanValidator(configurationProvider)
        let panValidationFlow = PanValidationFlow(panValidator, validationStateHandler, cvcValidationFlow)
        return PanViewPresenter(panValidationFlow, panValidator, panFormattingEnabled: panFormattingEnabled)
    }
    
    private func expiryDateViewPresenter(_ validationStateHandler: ExpiryDateValidationStateHandler) -> ExpiryDateViewPresenter {
        let expiryDateValidator = ExpiryDateValidator()
        let expiryDateValidationFlow = ExpiryDateValidationFlow(expiryDateValidator, validationStateHandler)
        return ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidator)
    }
    
    private func setTextFieldDelegate(textField: UITextField, delegate: Presenter) {
        clearExistingPresenter(from: textField)
        textField.delegate = delegate
        textField.addTarget(delegate, action: #selector(delegate.textFieldEditingChanged), for: .editingChanged)
        
        AccessCheckoutValidationInitialiser.presenters.append(delegate)
    }
    
    private func clearExistingPresenter(from uiTextField: UITextField) {
        let existingPresenter: Presenter? = uiTextField.delegate as? Presenter
        
        if existingPresenter != nil {
            uiTextField.removeTarget(existingPresenter, action: #selector(existingPresenter!.textFieldEditingChanged), for: .editingChanged)
            AccessCheckoutValidationInitialiser.presenters.removeAll(where: { $0 === existingPresenter })
        }
    }
}
