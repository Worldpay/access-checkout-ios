import UIKit

/// Class that is responsible for initialising validation using a given `ValidationConfig`
internal struct AccessCheckoutValidationInitialiser {
    private static var presenters = [Presenter]()

    private var configurationProvider: CardBrandsConfigurationProvider
    /**
     This initialiser should be used to create an instance of `AccessCheckoutValidationInitialiser`
     */
    internal init() {
        let restClient = RestClient<[CardBrandDto]>()
        let transformer = CardBrandDtoTransformer()
        let configurationFactory = CardBrandsConfigurationFactory(restClient, transformer)
        self.configurationProvider = CardBrandsConfigurationProvider(configurationFactory)
    }

    internal init(_ cardBrandsConfigurationProvider: CardBrandsConfigurationProvider) {
        self.configurationProvider = cardBrandsConfigurationProvider
    }

    /**
     This function should be used to initialise the validation using a given `ValidationConfig` provided by the merchant
     - Parameter validationConfiguration: `ValidationConfig` that represents the configuration that should be used to initialise the validation
     - Parameter checkoutId: The checkout identifier
     - Parameter baseUrl: The base URL for the service
     */
    internal func initialise(
        _ validationConfiguration: ValidationConfig,
        checkoutId: String,
        baseUrl: String
    ) {
        if validationConfiguration is CardValidationConfig {
            initialiseForCardPaymentFlow(
                validationConfiguration as! CardValidationConfig,
                checkoutId: checkoutId,
                baseUrl: baseUrl
            )
        } else if validationConfiguration is CvcOnlyValidationConfig {
            initialiseForCvcOnlyFlow(validationConfiguration as! CvcOnlyValidationConfig)
        }
    }

    private func initialiseForCardPaymentFlow(
        _ config: CardValidationConfig,
        checkoutId: String,
        baseUrl: String
    ) {
        configurationProvider.retrieveRemoteConfiguration(
            baseUrl: baseUrl,
            acceptedCardBrands: config.acceptedCardBrands
        )

        let cardBinService = CardBinService(
            checkoutId: checkoutId,
            client: CardBinApiClient(),
            configurationProvider: configurationProvider
        )

        let validationStateHandler = CardValidationStateHandler(config.validationDelegate)
        let cvcValidator = CvcValidator()
        let cvcValidationFlow = CvcValidationFlow(cvcValidator, validationStateHandler)

        let panPresenter = panViewPresenter(
            configurationProvider,
            cardBinService,
            cvcValidationFlow,
            validationStateHandler,
            config.panFormattingEnabled
        )
        let expiryDatePresenter = expiryDateViewPresenter(validationStateHandler)
        let cvcPresenter = CvcViewPresenter(cvcValidationFlow, cvcValidator)

        setTextFieldDelegate(textField: config.pan!.uiTextField, delegate: panPresenter)
        setTextFieldDelegate(
            textField: config.expiryDate!.uiTextField,
            delegate: expiryDatePresenter
        )
        setTextFieldDelegate(textField: config.cvc!.uiTextField, delegate: cvcPresenter)

        try? ServiceDiscoveryProvider.initialise(baseUrl)
        ServiceDiscoveryProvider.discoverAll { result in }
    }

    private func initialiseForCvcOnlyFlow(_ config: CvcOnlyValidationConfig) {
        let validationStateHandler = CvcOnlyValidationStateHandler(config.validationDelegate)
        let cvcValidator = CvcValidator()
        let cvcValidationFlow = CvcValidationFlow(cvcValidator, validationStateHandler)
        let cvcPresenter = CvcViewPresenter(cvcValidationFlow, cvcValidator)

        setTextFieldDelegate(textField: config.cvc!.uiTextField, delegate: cvcPresenter)
    }

    private func panViewPresenter(
        _ configurationProvider: CardBrandsConfigurationProvider,
        _ cardBinService: CardBinService,
        _ cvcValidationFlow: CvcValidationFlow,
        _ validationStateHandler: PanValidationStateHandler,
        _ panFormattingEnabled: Bool
    ) -> PanViewPresenter {
        let panValidator = PanValidator(configurationProvider)
        let panValidationFlow = PanValidationFlow(
            panValidator,
            validationStateHandler,
            cvcValidationFlow,
            cardBinService
        )
        return PanViewPresenter(
            panValidationFlow,
            panValidator,
            panFormattingEnabled: panFormattingEnabled
        )
    }

    private func expiryDateViewPresenter(_ validationStateHandler: ExpiryDateValidationStateHandler)
        -> ExpiryDateViewPresenter
    {
        let expiryDateValidator = ExpiryDateValidator()
        let expiryDateValidationFlow = ExpiryDateValidationFlow(
            expiryDateValidator,
            validationStateHandler
        )
        return ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidator)
    }

    private func setTextFieldDelegate(textField: UITextField, delegate: Presenter) {
        clearExistingPresenter(from: textField)
        textField.delegate = delegate
        textField.addTarget(
            delegate,
            action: #selector(delegate.textFieldEditingChanged),
            for: .editingChanged
        )

        AccessCheckoutValidationInitialiser.presenters.append(delegate)
    }

    private func clearExistingPresenter(from uiTextField: UITextField) {
        let existingPresenter: Presenter? = uiTextField.delegate as? Presenter

        if existingPresenter != nil {
            uiTextField.removeTarget(
                existingPresenter,
                action: #selector(existingPresenter!.textFieldEditingChanged),
                for: .editingChanged
            )
            AccessCheckoutValidationInitialiser.presenters.removeAll(where: {
                $0 === existingPresenter
            })
        }
    }
}
