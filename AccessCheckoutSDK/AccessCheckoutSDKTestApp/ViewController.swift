import AccessCheckoutSDK
import UIKit

class ViewController: UIViewController {
    @IBOutlet var panWithSpacing: AccessCheckoutUITextField!
    @IBOutlet var panWithSpacingCaretPositionTextField: UITextField!
    @IBOutlet var setPanWithSpacingCaretPositionTextField: UITextField!
    @IBOutlet var setPanWithSpacingCaretPositionButton: UIButton!

    @IBOutlet var panWithoutSpacing: AccessCheckoutUITextField!
    @IBOutlet var panWithoutSpacingCaretPositionTextField: UITextField!
    @IBOutlet var setPanWithoutSpacingCaretPositionTextField: UITextField!
    @IBOutlet var setPanWithoutSpacingCaretPositionButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        panWithSpacing.addTarget(
            self, action: #selector(recordPanWithSpacingCaretPosition), for: .editingDidEnd)
        initialiseValidation(usingCardNumberField: panWithSpacing, cardNumberSpacingEnabled: true)

        panWithoutSpacing.addTarget(
            self, action: #selector(recordPanWithoutSpacingCaretPosition), for: .editingDidEnd)
        initialiseValidation(
            usingCardNumberField: panWithoutSpacing, cardNumberSpacingEnabled: false)
    }

    // MARK: Event handlers for Methods for pan with spacing

    @IBAction func panWithSpacingSetButton_touchHandler(_ sender: Any) {
        guard let caretPositionText = setPanWithSpacingCaretPositionTextField.text,
            !caretPositionText.isEmpty
        else {
            return
        }

        setPanCaret(in: panWithSpacing, with: caretPositionText)
    }

    @objc
    func recordPanWithSpacingCaretPosition(sender: UITextField) {
        displayPanCaretPosition(of: sender, in: panWithSpacingCaretPositionTextField)
    }

    // MARK: Event handlers for Methods for pan without spacing

    @IBAction func panWithoutSpacingSetButton_touchHandler(_ sender: Any) {
        guard let caretPositionText = setPanWithoutSpacingCaretPositionTextField.text,
            !caretPositionText.isEmpty
        else {
            return
        }

        setPanCaret(in: panWithoutSpacing, with: caretPositionText)
    }

    @objc
    func recordPanWithoutSpacingCaretPosition(sender: UITextField) {
        displayPanCaretPosition(of: sender, in: panWithoutSpacingCaretPositionTextField)
    }

    private func displayPanCaretPosition(
        of ofUiTextField: UITextField,
        in inTextField: UITextField
    ) {
        if let textRange = ofUiTextField.selectedTextRange {
            let caretPosition = ofUiTextField.offset(
                from: ofUiTextField.beginningOfDocument, to: textRange.start)
            inTextField.text = "\(caretPosition)"
        }
    }

    private func setPanCaret(
        in accessCheckoutUITextField: AccessCheckoutUITextField,
        with caretPositionText: String
    ) {
        var caretPositionFrom: UITextPosition
        var caretPositionTo: UITextPosition

        // If caret position contains a | then it represents a selection. The caret position should be before | and the length of the selection after |
        if caretPositionText.contains("|") {
            let split = caretPositionText.split(separator: "|")
            let start = Int(split[0])!
            let length = Int(split[1])!
            caretPositionFrom = accessCheckoutUITextField.position(
                from: accessCheckoutUITextField.beginningOfDocument, offset: start)!
            caretPositionTo = accessCheckoutUITextField.position(
                from: accessCheckoutUITextField.beginningOfDocument, offset: start + length)!
        } else {
            caretPositionFrom = accessCheckoutUITextField.position(
                from: accessCheckoutUITextField.beginningOfDocument, offset: Int(caretPositionText)!
            )!
            caretPositionTo = accessCheckoutUITextField.position(
                from: accessCheckoutUITextField.beginningOfDocument, offset: Int(caretPositionText)!
            )!
        }

        _ = accessCheckoutUITextField.becomeFirstResponder()
        accessCheckoutUITextField.selectedTextRange = accessCheckoutUITextField.textRange(
            from: caretPositionFrom, to: caretPositionTo)
    }

    // MARK: methods related to Access Checkout SDK

    private func initialiseValidation(
        usingCardNumberField panAccessCheckoutUITextField: AccessCheckoutUITextField,
        cardNumberSpacingEnabled: Bool
    ) {
        let validationConfigBuilder = CardValidationConfig.builder()
            .checkoutId("00000000-0000-0000-0000-000000000000")
            .pan(panAccessCheckoutUITextField)
            .expiryDate(AccessCheckoutUITextField(frame: CGRect()))
            .cvc(AccessCheckoutUITextField(frame: CGRect()))
            .accessBaseUrl(Configuration.accessBaseUrl)
            .validationDelegate(self)
            .acceptedCardBrands(["visa", "mastercard", "AMEX"])
            .checkoutId(Configuration.checkoutId)

        if cardNumberSpacingEnabled {
            _ = validationConfigBuilder.enablePanFormatting()
        }

        AccessCheckoutValidationInitialiser().initialise(try! validationConfigBuilder.build())
    }
}

extension ViewController: AccessCheckoutCardValidationDelegate {
    func cardBrandChanged(cardBrand: CardBrand?) {}
    func panValidChanged(isValid: Bool) {}
    func expiryDateValidChanged(isValid: Bool) {}
    func cvcValidChanged(isValid: Bool) {}
    func validationSuccess() {}
}
