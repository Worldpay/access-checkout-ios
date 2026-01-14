import SwiftUI
import AccessCheckoutSDK

// MARK: - CvcFormView

/// CVC-only payment form
/// For scenarios where only CVC verification is needed (e.g., saved cards)
struct CvcFormView: View {
    
    @StateObject private var viewModel = CvcFormViewModel()
    @State private var isSDKReady = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.lg) {
                
                // Info card
                infoCard
                
                // CVC input card
                cvcInputCard
                
                // Submit card
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
        .navigationTitle("CVC Verification")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
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
    
    // MARK: - Info Card
    
    private var infoCard: some View {
        GlassCard(cornerRadius: DesignTokens.CornerRadius.large) {
            HStack(spacing: DesignTokens.Spacing.md) {
                Image(systemName: "lock.shield.fill")
                    .font(.title)
                    .foregroundStyle(DesignTokens.Colors.worldpayRed)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Verify Your Card")
                        .font(.headline)
                    
                    Text("Enter the 3-digit security code from the back of your card")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            .padding(DesignTokens.Spacing.md)
        }
    }
    
    // MARK: - CVC Input Card
    
    private var cvcInputCard: some View {
        GlassCard {
            VStack(spacing: DesignTokens.Spacing.md) {
                
                // Card illustration
                HStack {
                    Spacer()
                    
                    // Simple card back illustration
                    ZStack {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 120, height: 75)
                        
                        VStack(spacing: 4) {
                            // Magnetic stripe
                            Rectangle()
                                .fill(Color.gray.opacity(0.4))
                                .frame(height: 20)
                            
                            // CVC area highlight
                            HStack {
                                Spacer()
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(DesignTokens.Colors.worldpayRed, lineWidth: 2)
                                    .frame(width: 40, height: 20)
                                    .padding(.trailing, 8)
                            }
                            
                            Spacer()
                        }
                        .frame(width: 120, height: 75)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, DesignTokens.Spacing.sm)
                
                // CVC input field
                LabeledField("Security Code (CVC)") {
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
                    .frame(maxWidth: 120)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(DesignTokens.Spacing.lg)
        }
    }
    
    // MARK: - Submit Card
    
    private var submitCard: some View {
        GlassCard(cornerRadius: DesignTokens.CornerRadius.large) {
            PrimaryButton(
                "Verify CVC",
                isEnabled: viewModel.isCvcValid,
                isLoading: viewModel.isLoading
            ) {
                Task {
                    await viewModel.submit()
                }
            }
            .padding(DesignTokens.Spacing.md)
        }
    }
    
    // MARK: - Success Sheet
    
    private var successSheet: some View {
        NavigationView {
            VStack(spacing: DesignTokens.Spacing.xl) {
                Spacer()
                
                if let session = viewModel.sessionResult {
                    SuccessResultView(
                        title: "CVC Verified",
                        message: "CVC Session:\n\(session)"
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
        CvcFormView()
    }
}
