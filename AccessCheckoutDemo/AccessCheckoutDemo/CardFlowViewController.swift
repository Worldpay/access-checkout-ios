import AccessCheckoutSDK
import UIKit

// MARK: - CardFlowViewController with iOS 26 Liquid Glass Design
/// Two floating glass islands:
/// 1. Settings (CVC Session toggle) - at the top
/// 2. Card Form (icon, logo, card number, expiry/cvc, submit button)

class CardFlowViewController: UIViewController {
    
    // MARK: - Constants
    
    /// Worldpay red color
    private let worldpayRed = UIColor(red: 235/255, green: 0/255, blue: 27/255, alpha: 1.0)
    
    // MARK: - IBOutlets
    @IBOutlet var panTextField: AccessCheckoutUITextField!
    @IBOutlet var expiryDateTextField: AccessCheckoutUITextField!
    @IBOutlet var cvcTextField: AccessCheckoutUITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var cardBrandsLabel: UILabel!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var paymentsCvcSessionToggle: UISwitch!

    @IBOutlet var panIsValidLabel: UILabel!
    @IBOutlet var expiryDateIsValidLabel: UILabel!
    @IBOutlet var cvcIsValidLabel: UILabel!

    // MARK: - Glass Island Views
    
    /// Island 1: Settings (CVC Session toggle) - at the top
    private var settingsIsland: LiquidGlassCardView!
    
    /// Island 2: Card form (includes submit button)
    private var formIsland: LiquidGlassCardView!
    
    /// Background view
    private var backgroundView: GradientBackgroundView!
    
    /// Main container stack
    private var mainStackView: UIStackView!
    
    /// Track form validity
    private var isFormValid = false {
        didSet { updateButtonState() }
    }
    
    private let unknownBrandImage = UIImage(named: "card_unknown")
    private var accessCheckoutClient: AccessCheckoutClient!

    // MARK: - Actions
    
    @IBAction func submit(_ sender: Any) {
        submitCard()
    }

    // MARK: - Lifecyclex
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTextFields()
        setupAccessCheckout()

    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        setupBackground()
        setupMainStack()
        setupFormIsland()
        setupSettingsIsland() // This will insert at index 0 to appear above form
        setupSpinner()
    }
    
    private func setupBackground() {
        backgroundView = GradientBackgroundView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(backgroundView, at: 0)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupMainStack() {
        mainStackView = UIStackView()
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        mainStackView.alignment = .fill
        
        view.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Island 2: Card Form (with Submit Button)
    
    private func setupFormIsland() {
        formIsland = LiquidGlassCardView()
        formIsland.translatesAutoresizingMaskIntoConstraints = false
        formIsland.cardCornerRadius = 20
        
        if #available(iOS 26.0, *) {
            formIsland.glassStyle = .translucent
        }
        
        // Form content stack
        let formStack = UIStackView()
        formStack.translatesAutoresizingMaskIntoConstraints = false
        formStack.axis = .vertical
        formStack.spacing = 20
        formStack.alignment = .fill
        formStack.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        formStack.isLayoutMarginsRelativeArrangement = true
        
        // Row 1: Card icons
        let iconRow = createIconRow()
        formStack.addArrangedSubview(iconRow)
        
        // Row 2: Card Number
        let cardNumberSection = createCardNumberSection()
        formStack.addArrangedSubview(cardNumberSection)
        
        // Row 3: Expiry + CVC (inline)
        let expiryCvcRow = createExpiryCvcRow()
        formStack.addArrangedSubview(expiryCvcRow)
        
        // Row 4: Submit Button (inside form)
        let submitSection = createSubmitSection()
        formStack.addArrangedSubview(submitSection)
        
        formIsland.contentView.addSubview(formStack)
        NSLayoutConstraint.activate([
            formStack.topAnchor.constraint(equalTo: formIsland.contentView.topAnchor),
            formStack.leadingAnchor.constraint(equalTo: formIsland.contentView.leadingAnchor),
            formStack.trailingAnchor.constraint(equalTo: formIsland.contentView.trailingAnchor),
            formStack.bottomAnchor.constraint(equalTo: formIsland.contentView.bottomAnchor)
        ])
        
        mainStackView.addArrangedSubview(formIsland)
        
        updateButtonState()
    }
    
    private func createIconRow() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Generic card icon on the left
        let cardIconView = UIImageView()
        cardIconView.translatesAutoresizingMaskIntoConstraints = false
        cardIconView.image = UIImage(systemName: "creditcard.fill")
        cardIconView.tintColor = .secondaryLabel
        cardIconView.contentMode = .scaleAspectFit
        container.addSubview(cardIconView)
        
        // Card brand image on the right
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        container.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            cardIconView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            cardIconView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            cardIconView.widthAnchor.constraint(equalToConstant: 32),
            cardIconView.heightAnchor.constraint(equalToConstant: 24),
            
            imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 48),
            imageView.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        return container
    }
    
    private func createCardNumberSection() -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 8
        
        // Label
        let labelView = UILabel()
        labelView.text = "CARD NUMBER"
        labelView.font = .systemFont(ofSize: 11, weight: .semibold)
        labelView.textColor = .secondaryLabel
        container.addArrangedSubview(labelView)
        
        // Input
        panTextField.translatesAutoresizingMaskIntoConstraints = false
        panTextField.applyGlassInputStyle()
        panTextField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        container.addArrangedSubview(panTextField)
        
        return container
    }
    
    private func createExpiryCvcRow() -> UIView {
        let container = UIStackView()
        container.axis = .horizontal
        container.spacing = 16
        container.distribution = .fill
        
        // Expiry Date section
        let expirySection = UIStackView()
        expirySection.axis = .vertical
        expirySection.spacing = 8
        
        let expiryLabel = UILabel()
        expiryLabel.text = "EXPIRY DATE"
        expiryLabel.font = .systemFont(ofSize: 11, weight: .semibold)
        expiryLabel.textColor = .secondaryLabel
        expirySection.addArrangedSubview(expiryLabel)
        
        expiryDateTextField.translatesAutoresizingMaskIntoConstraints = false
        expiryDateTextField.applyGlassInputStyle()
        expiryDateTextField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        expirySection.addArrangedSubview(expiryDateTextField)
        
        // CVC section
        let cvcSection = UIStackView()
        cvcSection.axis = .vertical
        cvcSection.spacing = 8
        
        let cvcLabel = UILabel()
        cvcLabel.text = "CVC"
        cvcLabel.font = .systemFont(ofSize: 11, weight: .semibold)
        cvcLabel.textColor = .secondaryLabel
        cvcSection.addArrangedSubview(cvcLabel)
        
        cvcTextField.translatesAutoresizingMaskIntoConstraints = false
        cvcTextField.applyGlassInputStyle()
        cvcTextField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        cvcSection.addArrangedSubview(cvcTextField)
        
        // Add to container first, then set constraint
        container.addArrangedSubview(expirySection)
        container.addArrangedSubview(cvcSection)
        
        // Expiry takes more space than CVC
        expirySection.widthAnchor.constraint(equalTo: cvcSection.widthAnchor, multiplier: 1.5).isActive = true
        
        return container
    }
    
    // MARK: - Submit Button Section (inside form)
    
    private func createSubmitSection() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure submit button
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle("SUBMIT", for: .normal)
        submitButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        submitButton.backgroundColor = UIColor.systemGray5
        submitButton.setTitleColor(.darkGray, for: .normal)
        submitButton.setTitleColor(.lightGray, for: .disabled)
        submitButton.layer.cornerRadius = 12
        if #available(iOS 13.0, *) {
            submitButton.layer.cornerCurve = .continuous
        }
        
        container.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalTo: container.topAnchor),
            submitButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            submitButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            submitButton.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        return container
    }
    
    // MARK: - Island 1: Settings (CVC Session Toggle) - at the top
    
    private func setupSettingsIsland() {
        settingsIsland = LiquidGlassCardView()
        settingsIsland.translatesAutoresizingMaskIntoConstraints = false
        settingsIsland.cardCornerRadius = 16
        
        // Settings content stack
        let settingsStack = UIStackView()
        settingsStack.translatesAutoresizingMaskIntoConstraints = false
        settingsStack.axis = .vertical
        settingsStack.spacing = 12
        settingsStack.alignment = .fill
        settingsStack.layoutMargins = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
        settingsStack.isLayoutMarginsRelativeArrangement = true
        
        // Settings header
        let headerLabel = UILabel()
        headerLabel.text = "SETTINGS"
        headerLabel.font = .systemFont(ofSize: 11, weight: .semibold)
        headerLabel.textColor = .secondaryLabel
        settingsStack.addArrangedSubview(headerLabel)
        
        // Toggle row
        let toggleRow = createToggleRow()
        settingsStack.addArrangedSubview(toggleRow)
        
        settingsIsland.contentView.addSubview(settingsStack)
        NSLayoutConstraint.activate([
            settingsStack.topAnchor.constraint(equalTo: settingsIsland.contentView.topAnchor),
            settingsStack.leadingAnchor.constraint(equalTo: settingsIsland.contentView.leadingAnchor),
            settingsStack.trailingAnchor.constraint(equalTo: settingsIsland.contentView.trailingAnchor),
            settingsStack.bottomAnchor.constraint(equalTo: settingsIsland.contentView.bottomAnchor)
        ])
        
        // INSERT AT INDEX 0 to appear ABOVE the form island
        mainStackView.insertArrangedSubview(settingsIsland, at: 0)
    }
    
    private func createToggleRow() -> UIView {
        let row = UIView()
        row.translatesAutoresizingMaskIntoConstraints = false
        row.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        // Labels stack
        let labelsStack = UIStackView()
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        labelsStack.axis = .vertical
        labelsStack.spacing = 2
        
        let titleLabel = UILabel()
        titleLabel.text = "CVC Session"
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .label
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Retrieve Card + CVC sessions"
        subtitleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        
        labelsStack.addArrangedSubview(titleLabel)
        labelsStack.addArrangedSubview(subtitleLabel)
        
        row.addSubview(labelsStack)
        
        // Toggle
        paymentsCvcSessionToggle.translatesAutoresizingMaskIntoConstraints = false
        paymentsCvcSessionToggle.onTintColor = worldpayRed
        row.addSubview(paymentsCvcSessionToggle)
        
        NSLayoutConstraint.activate([
            labelsStack.leadingAnchor.constraint(equalTo: row.leadingAnchor),
            labelsStack.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            labelsStack.trailingAnchor.constraint(lessThanOrEqualTo: paymentsCvcSessionToggle.leadingAnchor, constant: -16),
            
            paymentsCvcSessionToggle.trailingAnchor.constraint(equalTo: row.trailingAnchor),
            paymentsCvcSessionToggle.centerYAnchor.constraint(equalTo: row.centerYAnchor)
        ])
        
        return row
    }
    
    private func updateButtonState() {
        UIView.animate(withDuration: 0.25) {
            if self.isFormValid {
                // Worldpay red when valid
                self.submitButton.backgroundColor = self.worldpayRed
                self.submitButton.setTitleColor(.white, for: .normal)
                self.submitButton.layer.shadowColor = self.worldpayRed.cgColor
                self.submitButton.layer.shadowOffset = CGSize(width: 0, height: 3)
                self.submitButton.layer.shadowRadius = 8
                self.submitButton.layer.shadowOpacity = 0.3
            } else {
                // Grey when invalid
                self.submitButton.backgroundColor = UIColor.systemGray5
                self.submitButton.setTitleColor(.darkGray, for: .normal)
                self.submitButton.layer.shadowOpacity = 0
            }
        }
        
        submitButton.isEnabled = isFormValid
    }
    
    private func setupSpinner() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: formIsland.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: formIsland.centerYAnchor)
        ])
    }
    
    // MARK: - Text Field Setup
    
    private func setupTextFields() {
        panTextField.placeholder = "Card Number"
        expiryDateTextField.placeholder = "MM/YY"
        cvcTextField.placeholder = "123"
        
        panTextField.textContentType = .creditCardNumber
        
        // Focus listeners
        panTextField.setOnFocusChangedListener { view, hasFocus in
            view.updateGlassFocusState(isFocused: hasFocus)
        }
        
        expiryDateTextField.setOnFocusChangedListener { view, hasFocus in
            view.updateGlassFocusState(isFocused: hasFocus)
        }
        
        cvcTextField.setOnFocusChangedListener { view, hasFocus in
            view.updateGlassFocusState(isFocused: hasFocus)
        }
        
        // Fonts
        panTextField.font = .systemFont(ofSize: 16, weight: .regular)
        expiryDateTextField.font = .systemFont(ofSize: 16, weight: .regular)
        cvcTextField.font = .systemFont(ofSize: 16, weight: .regular)
        
        // Hidden labels for automated tests
        panIsValidLabel?.textColor = .clear
        expiryDateIsValidLabel?.textColor = .clear
        cvcIsValidLabel?.textColor = .clear
    }
    
    // MARK: - AccessCheckout Setup
    
    private func setupAccessCheckout() {
        resetCard(preserveContent: false, validationErrors: nil)
        
        do {
            self.accessCheckoutClient = try AccessCheckoutClientBuilder()
                .accessBaseUrl(Configuration.accessBaseUrl)
                .checkoutId(Configuration.checkoutId)
                .build()
            
            let validationConfig = try CardValidationConfig.builder()
                .pan(panTextField)
                .expiryDate(expiryDateTextField)
                .cvc(cvcTextField)
                .validationDelegate(self)
                .enablePanFormatting()
                .build()

            accessCheckoutClient.initialiseValidation(validationConfig)
            
            isFormValid = false
            cardBrandsChanged(cardBrands: [])
        } catch {
            AlertView.display(
                using: self,
                title: "Initialization Error",
                message: "Failed to initialize AccessCheckout: \(error.localizedDescription)"
            )
        }
    }

    // MARK: - Submit Logic
    
    private func submitCard() {
        panTextField.isEnabled = false
        expiryDateTextField.isEnabled = false
        cvcTextField.isEnabled = false

        spinner.startAnimating()

        let sessionTypes: Set<SessionType> =
            paymentsCvcSessionToggle.isOn
            ? [SessionType.card, SessionType.cvc] : [SessionType.card]

        do {
            let cardDetails = try CardDetailsBuilder().pan(panTextField)
                .expiryDate(expiryDateTextField)
                .cvc(cvcTextField)
                .build()

            try accessCheckoutClient.generateSessions(
                cardDetails: cardDetails,
                sessionTypes: sessionTypes
            ) { result in
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()

                    switch result {
                    case .success(let sessions):
                        var titleToDisplay: String
                        var messageToDisplay: String

                        if sessionTypes.count > 1 {
                            titleToDisplay = "Card & CVC Sessions"
                            messageToDisplay = """
                                \(sessions[SessionType.card]!)
                                \(sessions[SessionType.cvc]!)
                                """
                        } else {
                            titleToDisplay = "Card Session"
                            messageToDisplay = "\(sessions[SessionType.card]!)"
                        }

                        AlertView.display(
                            using: self,
                            title: titleToDisplay,
                            message: messageToDisplay,
                            closeHandler: {
                                self.resetCard(preserveContent: false, validationErrors: nil)
                            }
                        )
                    case .failure(let error):
                        let title = error.localizedDescription
                        var accessCheckoutClientValidationErrors:
                            [AccessCheckoutError.AccessCheckoutValidationError]?
                        if error.message.contains("bodyDoesNotMatchSchema") {
                            accessCheckoutClientValidationErrors = error.validationErrors
                        }

                        AlertView.display(
                            using: self,
                            title: title,
                            message: nil,
                            closeHandler: {
                                self.resetCard(
                                    preserveContent: true,
                                    validationErrors: accessCheckoutClientValidationErrors
                                )
                            }
                        )
                    }
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                AlertView.display(
                    using: self,
                    title: "Error",
                    message: error.localizedDescription,
                    closeHandler: {
                        self.resetCard(preserveContent: true, validationErrors: nil)
                    }
                )
            }
        }
    }

    private func resetCard(
        preserveContent: Bool,
        validationErrors: [AccessCheckoutError.AccessCheckoutValidationError]?
    ) {
        panTextField.isEnabled = true
        expiryDateTextField.isEnabled = true
        cvcTextField.isEnabled = true

        if !preserveContent {
            panTextField.clear()
            expiryDateTextField.clear()
            cvcTextField.clear()

            cardBrandsLabel?.text = ""
            cardBrandsLabel?.accessibilityIdentifier = "cardBrandsLabel"
            imageView.image = unknownBrandImage
            
            isFormValid = false
        }

        validationErrors?.forEach { error in
            if error.errorName == "panFailedLuhnCheck" {
                changePanValidIndicator(isValid: false)
            } else if error.errorName == "dateHasInvalidFormat" {
                if error.jsonPath == "$.cardNumber" {
                    changePanValidIndicator(isValid: false)
                } else if error.jsonPath == "$.cardExpiryDate.month" {
                    changeExpiryDateValidIndicator(isValid: false)
                } else if error.jsonPath == "$.cardExpiryDate.year" {
                    changeExpiryDateValidIndicator(isValid: false)
                } else if error.jsonPath == "$.cvv" {
                    changeCvcValidIndicator(isValid: false)
                }
            }
        }
    }

    private func changePanValidIndicator(isValid: Bool) {
        panTextField.textColor =
            isValid ? Configuration.validCardDetailsColor : Configuration.invalidCardDetailsColor
        panIsValidLabel?.text = isValid ? "valid" : "invalid"
    }

    private func changeExpiryDateValidIndicator(isValid: Bool) {
        expiryDateTextField.textColor =
            isValid ? Configuration.validCardDetailsColor : Configuration.invalidCardDetailsColor
        expiryDateIsValidLabel?.text = isValid ? "valid" : "invalid"
    }

    private func changeCvcValidIndicator(isValid: Bool) {
        cvcTextField.textColor =
            isValid ? Configuration.validCardDetailsColor : Configuration.invalidCardDetailsColor
        cvcIsValidLabel?.text = isValid ? "valid" : "invalid"
    }
}

// MARK: - AccessCheckoutCardValidationDelegate

extension CardFlowViewController: AccessCheckoutCardValidationDelegate {
    func cardBrandsChanged(cardBrands: [CardBrand]) {
        UiUtils.updateCardBrandImage(imageView, using: cardBrands)

        let brandNames = cardBrands.map { $0.name }.joined(separator: ", ")
        DispatchQueue.main.async {
            self.cardBrandsLabel?.text = brandNames
            self.cardBrandsLabel?.accessibilityIdentifier = "cardBrandsLabel"
        }
    }

    func panValidChanged(isValid: Bool) {
        changePanValidIndicator(isValid: isValid)
        if !isValid {
            isFormValid = false
        }
    }

    func cvcValidChanged(isValid: Bool) {
        changeCvcValidIndicator(isValid: isValid)
        if !isValid {
            isFormValid = false
        }
    }

    func expiryDateValidChanged(isValid: Bool) {
        changeExpiryDateValidIndicator(isValid: isValid)
        if !isValid {
            isFormValid = false
        }
    }

    func validationSuccess() {
        isFormValid = true
    }
}
