import UIKit

// MARK: - LiquidGlassCardView
/// A floating glass card container using iOS 26 UIGlassEffect
/// Falls back to a basic card design for earlier iOS versions

class LiquidGlassCardView: UIView {
    
    // MARK: - Glass Style
    enum GlassStyle {
        case regular      // Standard glass
        case translucent  // More transparent, like real glass
        case subtle       // Very light glass effect
    }
    
    // MARK: - Properties
    
    /// The content view where you add your elements
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    /// Corner radius for the card
    var cardCornerRadius: CGFloat = 24 {
        didSet { updateAppearance() }
    }
    
    /// Glass style (only affects iOS 26+)
    private var _glassStyle: GlassStyle = .regular
    var glassStyle: GlassStyle {
        get { _glassStyle }
        set {
            _glassStyle = newValue
            if #available(iOS 26.0, *) {
                updateGlassStyleInternal()
            }
        }
    }
    
    // Store reference to glass effect view
    private var _glassEffectView: UIVisualEffectView?
    
    // Fallback for pre-iOS 26
    private var fallbackBackgroundView: UIView?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    convenience init(style: GlassStyle, cornerRadius: CGFloat = 24) {
        self.init(frame: .zero)
        self._glassStyle = style
        self.cardCornerRadius = cornerRadius
        updateAppearance()
        if #available(iOS 26.0, *) {
            updateGlassStyleInternal()
        }
    }
    
    // MARK: - Setup
    
    private func setupView() {
        backgroundColor = .clear
        
        if #available(iOS 26.0, *) {
            setupLiquidGlass()
        } else {
            setupFallbackCard()
        }
        
        // Add content view on top
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - iOS 26 Liquid Glass Setup
    
    @available(iOS 26.0, *)
    private func setupLiquidGlass() {
        // Create the native UIGlassEffect
        let glassEffect = UIGlassEffect()
        
        // Create the visual effect view with the glass effect
        let effectView = UIVisualEffectView(effect: glassEffect)
        effectView.translatesAutoresizingMaskIntoConstraints = false
        
        // Corner styling
        effectView.layer.cornerRadius = cardCornerRadius
        effectView.layer.cornerCurve = .continuous
        effectView.clipsToBounds = true
        
        insertSubview(effectView, at: 0)
        
        NSLayoutConstraint.activate([
            effectView.topAnchor.constraint(equalTo: topAnchor),
            effectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            effectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            effectView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        _glassEffectView = effectView
        
        // Add shadow for floating depth
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 6)
        layer.shadowRadius = 20
        layer.shadowOpacity = 0.10
    }
    
    // MARK: - Fallback for pre-iOS 26
    
    private func setupFallbackCard() {
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .systemBackground
        backgroundView.layer.cornerRadius = cardCornerRadius
        if #available(iOS 13.0, *) {
            backgroundView.layer.cornerCurve = .continuous
        }
        
        // Border
        backgroundView.layer.borderWidth = 1
        backgroundView.layer.borderColor = UIColor.separator.cgColor
        
        // Shadow
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 4)
        backgroundView.layer.shadowRadius = 12
        backgroundView.layer.shadowOpacity = 0.08
        
        insertSubview(backgroundView, at: 0)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        fallbackBackgroundView = backgroundView
    }
    
    // MARK: - Update Appearance
    
    private func updateAppearance() {
        if #available(iOS 26.0, *) {
            _glassEffectView?.layer.cornerRadius = cardCornerRadius
        } else {
            fallbackBackgroundView?.layer.cornerRadius = cardCornerRadius
        }
    }
    
    @available(iOS 26.0, *)
    private func updateGlassStyleInternal() {
        guard let effectView = _glassEffectView else { return }
        
        // Adjust alpha/opacity based on style for more translucent effect
        switch _glassStyle {
        case .regular:
            effectView.alpha = 1.0
            layer.shadowOpacity = 0.10
        case .translucent:
            effectView.alpha = 0.85
            layer.shadowOpacity = 0.08
        case .subtle:
            effectView.alpha = 0.7
            layer.shadowOpacity = 0.06
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update shadow path for performance
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: cardCornerRadius
        ).cgPath
        
        fallbackBackgroundView?.layer.shadowPath = layer.shadowPath
    }
}

// MARK: - GradientBackgroundView
/// Animated gradient background for the Liquid Glass aesthetic

class GradientBackgroundView: UIView {
    
    private var gradientLayer: CAGradientLayer?
    private var orb1: CAGradientLayer?
    private var orb2: CAGradientLayer?
    private var orb3: CAGradientLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBackground()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBackground()
    }
    
    private func setupBackground() {
        if #available(iOS 26.0, *) {
            setupLiquidGlassBackground()
        } else {
            backgroundColor = UIColor.systemGroupedBackground
        }
    }
    
    @available(iOS 26.0, *)
    private func setupLiquidGlassBackground() {
        // Base gradient
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.systemBackground.cgColor,
            UIColor.secondarySystemBackground.cgColor
        ]
        gradient.locations = [0.0, 1.0]
        layer.addSublayer(gradient)
        gradientLayer = gradient
        
        // Floating gradient orbs
        orb1 = createOrb(color: .systemBlue, opacity: 0.15)
        orb2 = createOrb(color: .systemPurple, opacity: 0.12)
        orb3 = createOrb(color: .systemTeal, opacity: 0.10)
        
        if let orb1 = orb1 { layer.addSublayer(orb1) }
        if let orb2 = orb2 { layer.addSublayer(orb2) }
        if let orb3 = orb3 { layer.addSublayer(orb3) }
    }
    
    private func createOrb(color: UIColor, opacity: CGFloat) -> CAGradientLayer {
        let orb = CAGradientLayer()
        orb.type = .radial
        orb.colors = [
            color.withAlphaComponent(opacity).cgColor,
            color.withAlphaComponent(opacity * 0.3).cgColor,
            UIColor.clear.cgColor
        ]
        orb.startPoint = CGPoint(x: 0.5, y: 0.5)
        orb.endPoint = CGPoint(x: 1, y: 1)
        return orb
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer?.frame = bounds
        
        let orbSize: CGFloat = 300
        orb1?.frame = CGRect(x: -50, y: bounds.height * 0.05, width: orbSize, height: orbSize)
        orb2?.frame = CGRect(x: bounds.width - 120, y: bounds.height * 0.35, width: orbSize * 1.2, height: orbSize * 1.2)
        orb3?.frame = CGRect(x: bounds.width * 0.2, y: bounds.height * 0.65, width: orbSize * 0.9, height: orbSize * 0.9)
    }
}

// MARK: - UIView Extension for Glass Input Styling



extension UIView {
    
    /// Apply glass-style input field appearance
    func applyGlassInputStyle(cornerRadius: CGFloat = 8) {
        if #available(iOS 26.0, *) {
            applyiOS26GlassInputStyle(cornerRadius: cornerRadius)
        } else {
            applyFallbackInputStyle(cornerRadius: cornerRadius)
        }
    }
    
    @available(iOS 26.0, *)
    private func applyiOS26GlassInputStyle(cornerRadius: CGFloat) {
        // More translucent glass-like background
        backgroundColor = UIColor.white.withAlphaComponent(0.12)
        
        // Rounded corners
        layer.cornerRadius = cornerRadius
        layer.cornerCurve = .continuous
        
        // Very subtle border for glass edge
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.withAlphaComponent(0.25).cgColor
    }
    
    private func applyFallbackInputStyle(cornerRadius: CGFloat) {
        backgroundColor = .systemBackground
        layer.cornerRadius = cornerRadius
        if #available(iOS 13.0, *) {
            layer.cornerCurve = .continuous
        }
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    /// Update focus state for glass input
    func updateGlassFocusState(isFocused: Bool) {
        if #available(iOS 26.0, *) {
            UIView.animate(withDuration: 0.2) {
                self.layer.borderColor = isFocused
                    ? UIColor.systemBlue.withAlphaComponent(0.5).cgColor
                    : UIColor.white.withAlphaComponent(0.25).cgColor
                self.layer.borderWidth = isFocused ? 1.5 : 1
                self.backgroundColor = isFocused
                    ? UIColor.white.withAlphaComponent(0.20)
                    : UIColor.white.withAlphaComponent(0.12)
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.layer.borderColor = isFocused
                    ? UIColor.systemBlue.cgColor
                    : UIColor.systemGray5.cgColor
                self.layer.borderWidth = isFocused ? 2 : 1
            }
        }
    }
}
