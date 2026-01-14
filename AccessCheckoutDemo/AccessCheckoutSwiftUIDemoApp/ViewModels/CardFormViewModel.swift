import SwiftUI
import AccessCheckoutSDK
import Combine

// MARK: - CardFormViewModel

/// ViewModel that bridges the AccessCheckout SDK with SwiftUI
/// Manages validation state, SDK initialization, and session generation
@MainActor
class CardFormViewModel: ObservableObject {
    
    // MARK: - Published State
    
    // Validation states
    @Published var isPanValid = false
    @Published var isExpiryValid = false
    @Published var isCvcValid = false
    @Published var isFormValid = false
    
    // Focus states
    @Published var isPanFocused = false
    @Published var isExpiryFocused = false
    @Published var isCvcFocused = false
    
    // Card brand
    @Published var cardBrandName: String = ""
    @Published var cardBrandImage: UIImage?
    
    // UI State
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    @Published var sessionResult: SessionResult?
    @Published var showSuccess = false
    
    // MARK: - UIKit References
    
    /// Direct references to UIKit text fields (required by SDK)
    var panTextField: AccessCheckoutUITextField?
    var expiryTextField: AccessCheckoutUITextField?
    var cvcTextField: AccessCheckoutUITextField?
    
    // MARK: - SDK
    
    private var accessCheckoutClient: AccessCheckoutClient?
    private var isInitialized = false
    
    // Image cache
    private var brandImageCache: [String: UIImage] = [:]
    
    // MARK: - Initialization
    
    /// Initialize the SDK once all text field references are available
    func initializeSDK() {
        guard !isInitialized else { return }
        guard let pan = panTextField,
              let expiry = expiryTextField,
              let cvc = cvcTextField else {
            print("⚠️ Text fields not yet available")
            return
        }
        
        do {
            // Build the client
            accessCheckoutClient = try AccessCheckoutClientBuilder()
                .accessBaseUrl(AppConfiguration.accessBaseUrl)
                .checkoutId(AppConfiguration.checkoutId)
                .build()
            
            // Configure validation
            let validationConfig = try CardValidationConfig.builder()
                .pan(pan)
                .expiryDate(expiry)
                .cvc(cvc)
                .validationDelegate(self)
                .enablePanFormatting()
                .build()
            
            accessCheckoutClient?.initialiseValidation(validationConfig)
            
            isInitialized = true
            print("✅ SDK initialized successfully")
            
        } catch {
            errorMessage = "Failed to initialize SDK: \(error.localizedDescription)"
            showError = true
            print("❌ SDK initialization failed: \(error)")
        }
    }
    
    // MARK: - Actions
    
    /// Submit card details and generate session(s)
    func submit(includeCvcSession: Bool = false) async {
        guard let client = accessCheckoutClient,
              let pan = panTextField,
              let expiry = expiryTextField,
              let cvc = cvcTextField else {
            errorMessage = "SDK not initialized"
            showError = true
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        do {
            let cardDetails = try CardDetailsBuilder()
                .pan(pan)
                .expiryDate(expiry)
                .cvc(cvc)
                .build()
            
            let sessionTypes: Set<SessionType> = includeCvcSession
                ? [.card, .cvc]
                : [.card]
            
            // Wrap callback-based API in async/await
            let sessions = try await withCheckedThrowingContinuation { continuation in
                do {
                    try client.generateSessions(
                        cardDetails: cardDetails,
                        sessionTypes: sessionTypes
                    ) { result in
                        continuation.resume(with: result)
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
            
            // Create result
            sessionResult = SessionResult(
                cardSession: sessions[.card],
                cvcSession: sessions[.cvc]
            )
            showSuccess = true
            
            print("✅ Session generated successfully")
            
        } catch let error as AccessCheckoutError {
            handleAccessCheckoutError(error)
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
    /// Reset the form to initial state
    func reset() {
        // Clear text fields
        panTextField?.clear()
        expiryTextField?.clear()
        cvcTextField?.clear()
        
        // Reset validation state
        isPanValid = false
        isExpiryValid = false
        isCvcValid = false
        isFormValid = false
        
        // Reset card brand
        cardBrandName = ""
        cardBrandImage = nil
        
        // Reset UI state
        sessionResult = nil
        showSuccess = false
        errorMessage = nil
        showError = false
    }
    
    // MARK: - Error Handling
    
    private func handleAccessCheckoutError(_ error: AccessCheckoutError) {
        errorMessage = error.localizedDescription
        showError = true
        
        // Highlight specific fields based on validation errors
        if error.message.contains("bodyDoesNotMatchSchema") {
            for validationError in error.validationErrors {
                switch validationError.jsonPath {
                case "$.cardNumber":
                    isPanValid = false
                case "$.cardExpiryDate.month", "$.cardExpiryDate.year":
                    isExpiryValid = false
                case "$.cvv":
                    isCvcValid = false
                default:
                    break
                }
            }
        }
    }
    
    // MARK: - Brand Image Loading
    
    private func loadBrandImage(from urlString: String, brandName: String) {
        // Check cache first
        if let cached = brandImageCache[urlString] {
            cardBrandImage = cached
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    brandImageCache[urlString] = image
                    await MainActor.run {
                        cardBrandImage = image
                    }
                }
            } catch {
                print("Failed to load brand image: \(error)")
            }
        }
    }
}

// MARK: - AccessCheckoutCardValidationDelegate


extension CardFormViewModel: AccessCheckoutCardValidationDelegate {
    nonisolated func cardBrandsChanged(cardBrands: [CardBrand]) {
        Task { @MainActor in
            if let brand = cardBrands.first {
                cardBrandName = brand.name

                // Load PNG image if available
                if let imageInfo = brand.images.first(where: { $0.type == "image/png" }) {
                    let urlString = imageInfo.url
                    guard !urlString.isEmpty else { return }
                    loadBrandImage(from: urlString, brandName: brand.name)
                }
            } else {
                cardBrandName = ""
                cardBrandImage = nil
            }
        }
    }
    
    nonisolated func panValidChanged(isValid: Bool) {
        Task { @MainActor in
            isPanValid = isValid
            print("PAN valid: \(isValid)")
        }
    }
    
    nonisolated func expiryDateValidChanged(isValid: Bool) {
        Task { @MainActor in
            isExpiryValid = isValid
            print("Expiry valid: \(isValid)")
        }
    }
    
    nonisolated func cvcValidChanged(isValid: Bool) {
        Task { @MainActor in
            isCvcValid = isValid
            print("CVC valid: \(isValid)")
        }
    }
    
    nonisolated func validationSuccess() {
        Task { @MainActor in
            isFormValid = true
            print("✅ Form validation success")
        }
    }
}

// MARK: - Session Result

struct SessionResult: Identifiable {
    let id = UUID()
    let cardSession: String?
    let cvcSession: String?
    
    var formattedResult: String {
        var result = ""
        if let card = cardSession {
            result += "Card Session:\n\(card)"
        }
        if let cvc = cvcSession {
            if !result.isEmpty { result += "\n\n" }
            result += "CVC Session:\n\(cvc)"
        }
        return result
    }
}
