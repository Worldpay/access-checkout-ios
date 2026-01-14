import SwiftUI
import AccessCheckoutSDK

// MARK: - CardFormView

/// Complete card payment form with SDK integration
/// Demonstrates wrapping UIKit AccessCheckoutUITextField in SwiftUI
struct CardFormView: View {
    
    @StateObject private var viewModel = CardFormViewModel()
    
    /// Include CVC session in addition to card session
    @State private var includeCvcSession = false
    
    /// Track SDK initialization
    @State private var isSDKReady = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.lg) {
                
                // Card Form Island
                cardFormCard
                
                // Options Island
                optionsCard
                
                // Submit Island
                submitCard
                
                // Error display
                if viewModel.showError, let error = viewModel.errorMessage {
                    ErrorBanner(message: error) {
                        viewModel.showError = false
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .padding(.horizontal, DesignTokens.Spacing.lg)
            .padding(.vertical, DesignTokens.Spacing.xl)
        }
        .background(GradientBackground())
        .navigationTitle("Card Payment")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            // Initialize SDK after a brief delay to ensure text fields are created
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if !isSDKReady {
                    viewModel.initializeSDK()
                    isSDKReady = true
                }
            }
        }
        .sheet(isPresented: $viewModel.showSuccess) {
            successSheet
        }
        .animation(DesignTokens.Animation.standard, value: viewModel.showError)
    }
    
    // MARK: - Card Form Card
    
    private var cardFormCard: some View {
        GlassCard {
            VStack(spacing: DesignTokens.Spacing.md) {
                
                // Header row with icons
                headerRow
                
                // Card number field
                LabeledField("Card Number") {
                    AccessCheckoutTextField(
                        fieldType: .pan,
                        isValid: $viewModel.isPanValid,
                        isFocused: $viewModel.isPanFocused,
                        textFieldRef: Binding(
                            get: { viewModel.panTextField },
                            set: { viewModel.panTextField = $0 }
                        )
                    )
                    .frame(height: 48)
                }
                
                // Expiry and CVC row
                HStack(spacing: DesignTokens.Spacing.md) {
                    LabeledField("Expiry Date") {
                        AccessCheckoutTextField(
                            fieldType: .expiryDate,
                            isValid: $viewModel.isExpiryValid,
                            isFocused: $viewModel.isExpiryFocused,
                            textFieldRef: Binding(
                                get: { viewModel.expiryTextField },
                                set: { viewModel.expiryTextField = $0 }
                            )
                        )
                        .frame(height: 48)
                    }
                    
                    LabeledField("CVC") {
                        AccessCheckoutTextField(
                            fieldType: .cvc,
                            isValid: $viewModel.isCvcValid,
                            isFocused: $viewModel.isCvcFocused,
                            textFieldRef: Binding(
                                get: { viewModel.cvcTextField },
                                set: { viewModel.cvcTextField = $0 }
                            )
                        )
                        .frame(height: 48)
                    }
                    .frame(maxWidth: 100)
                }
            }
            .padding(DesignTokens.Spacing.lg)
        }
    }
    
    // MARK: - Header Row
    
    private var headerRow: some View {
        HStack {
            // Card icon
            Image(systemName: "creditcard.fill")
                .font(.title2)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            // Detected card brand
            CardBrandImage(
                image: viewModel.cardBrandImage,
                brandName: viewModel.cardBrandName
            )
        }
    }
    
    // MARK: - Options Card
    
    private var optionsCard: some View {
        GlassCard(cornerRadius: DesignTokens.CornerRadius.large) {
            Toggle(isOn: $includeCvcSession) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Include CVC Session")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text("Generate both card and CVC sessions")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .tint(DesignTokens.Colors.worldpayRed)
            .padding(DesignTokens.Spacing.md)
        }
    }
    
    // MARK: - Submit Card
    
    private var submitCard: some View {
        GlassCard(cornerRadius: DesignTokens.CornerRadius.large) {
            VStack(spacing: DesignTokens.Spacing.sm) {
                PrimaryButton(
                    "Submit Payment",
                    isEnabled: viewModel.isFormValid,
                    isLoading: viewModel.isLoading
                ) {
                    Task {
                        await viewModel.submit(includeCvcSession: includeCvcSession)
                    }
                }
                
                // Validation status (for debugging - can be removed)
                if !viewModel.isFormValid {
                    HStack(spacing: DesignTokens.Spacing.sm) {
                        validationIndicator("PAN", isValid: viewModel.isPanValid)
                        validationIndicator("Expiry", isValid: viewModel.isExpiryValid)
                        validationIndicator("CVC", isValid: viewModel.isCvcValid)
                    }
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                }
            }
            .padding(DesignTokens.Spacing.md)
        }
    }
    
    private func validationIndicator(_ label: String, isValid: Bool) -> some View {
        HStack(spacing: 4) {
            Image(systemName: isValid ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(isValid ? .green : .secondary)
            Text(label)
        }
    }
    
    // MARK: - Success Sheet
    
    private var successSheet: some View {
        NavigationView {
            VStack(spacing: DesignTokens.Spacing.xl) {
                Spacer()
                
                if let result = viewModel.sessionResult {
                    SuccessResultView(
                        title: result.cvcSession != nil ? "Card & CVC Sessions" : "Card Session",
                        message: result.formattedResult
                    ) {
                        viewModel.reset()
                        viewModel.showSuccess = false
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Success")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        viewModel.reset()
                        viewModel.showSuccess = false
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationView {
        CardFormView()
    }
}
