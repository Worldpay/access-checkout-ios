import SwiftUI
import AccessCheckoutSDK
import Combine

// MARK: - CvcFormViewModel

/// ViewModel for CVC-only session generation
/// Simpler than full card form - only validates and submits CVC
@MainActor
class CvcFormViewModel: ObservableObject {
    
    // MARK: - Published State
    
    @Published var isCvcValid = false
    @Published var isCvcFocused = false
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    @Published var sessionResult: String?
    @Published var showSuccess = false
    
    // MARK: - UIKit Reference
    
    var cvcTextField: AccessCheckoutUITextField?
    
    // MARK: - SDK
    
    private var accessCheckoutClient: AccessCheckoutClient?
    private var isInitialized = false
    
    // MARK: - Initialization
    
    func initializeSDK() {
        guard !isInitialized else { return }
        guard let cvc = cvcTextField else {
            print("⚠️ CVC text field not yet available")
            return
        }
        
        do {
            accessCheckoutClient = try AccessCheckoutClientBuilder()
                .accessBaseUrl(AppConfiguration.accessBaseUrl)
                .checkoutId(AppConfiguration.checkoutId)
                .build()
            
            let validationConfig = try CvcOnlyValidationConfig.builder()
                .cvc(cvc)
                .validationDelegate(self)
                .build()
            
            accessCheckoutClient?.initialiseValidation(validationConfig)
            
            isInitialized = true
            print("✅ CVC SDK initialized")
            
        } catch {
            errorMessage = "Failed to initialize: \(error.localizedDescription)"
            showError = true
        }
    }
    
    // MARK: - Actions
    
    func submit() async {
        guard let client = accessCheckoutClient,
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
                .cvc(cvc)
                .build()
            
            let sessions = try await withCheckedThrowingContinuation { continuation in
                do {
                    try client.generateSessions(
                        cardDetails: cardDetails,
                        sessionTypes: [.cvc]
                    ) { result in
                        continuation.resume(with: result)
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
            
            if let cvcSession = sessions[.cvc] {
                sessionResult = cvcSession
                showSuccess = true
            }
            
        } catch let error as AccessCheckoutError {
            errorMessage = error.localizedDescription
            showError = true
            
            // Check for CVC validation error
            if error.validationErrors.contains(where: { $0.jsonPath == "$.cvv" }) {
                isCvcValid = false
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
    func reset() {
        cvcTextField?.clear()
        isCvcValid = false
        sessionResult = nil
        showSuccess = false
        errorMessage = nil
        showError = false
    }
}

// MARK: - AccessCheckoutCvcOnlyValidationDelegate

extension CvcFormViewModel: AccessCheckoutCvcOnlyValidationDelegate {
    
    nonisolated func cvcValidChanged(isValid: Bool) {
        Task { @MainActor in
            isCvcValid = isValid
        }
    }
    
    nonisolated func validationSuccess() {
        Task { @MainActor in
            // CVC is valid and ready to submit
            print("✅ CVC validation success")
        }
    }
}
