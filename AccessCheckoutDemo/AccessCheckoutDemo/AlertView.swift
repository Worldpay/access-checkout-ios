import UIKit

class AlertView {
    private let closeButtonText = "OK"

    private let title: String?
    private let message: String?
    private var closeHandler: (() -> Void)?

    static func display(
        using uiViewController: UIViewController, title: String?, message: String?,
        closeHandler: @escaping () -> Void
    ) {
        let alert = AlertView(title: title, message: message, closeHandler: closeHandler)
        alert.display(using: uiViewController)
    }

    static func display(using uiViewController: UIViewController, title: String?, message: String?)
    {
        let alert = AlertView(title: title, message: message)
        alert.display(using: uiViewController)
    }

    private init(title: String?, message: String?, closeHandler: @escaping () -> Void) {
        self.title = title
        self.message = message
        self.closeHandler = closeHandler
    }

    private init(title: String?, message: String?) {
        self.title = title
        self.message = message
    }

    private func display(using uiViewController: UIViewController) {
        let alertController = UIAlertController(
            title: self.title, message: self.message, preferredStyle: .alert)
        alertController.addAction(
            UIAlertAction(
                title: self.closeButtonText, style: .default,
                handler: { action in
                    self.closeHandler?()

                    alertController.dismiss(animated: true)
                }))

        uiViewController.present(alertController, animated: true)
    }
}
