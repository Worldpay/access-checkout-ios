public struct AccessCheckoutValidationInitialiser {
    private var cardBrandsConfigurationFactory: CardBrandsConfigurationFactory
    
    init(_ cardBrandsConfigurationFactory: CardBrandsConfigurationFactory) {
        self.cardBrandsConfigurationFactory = cardBrandsConfigurationFactory
    }
    
    public func initialise(panView: PANView, expiryDateView: ExpiryDateView, cvvView: CVVView, baseUrl: String, completionHandler: @escaping () -> Void) {
        cardBrandsConfigurationFactory.create(baseUrl: baseUrl) { _ in
            panView.presenter = PANViewPresenter()
            expiryDateView.presenter = ExpiryDateViewPresenter()
            cvvView.presenter = CVVViewForCardPaymentFlowPresenter()
            
            completionHandler()
        }
    }
    
    public func initialise(cvvView: CVVView) {
        cvvView.presenter = CVVViewForCvvOnlyFlowPresenter()
    }
}
