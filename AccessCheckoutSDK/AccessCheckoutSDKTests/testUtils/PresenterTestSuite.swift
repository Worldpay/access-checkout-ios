import Cuckoo
import XCTest

@testable import AccessCheckoutSDK

class PresenterTestSuite: XCTestCase {
    let panTextField = UITextField()
    let expiryDateTextField = UITextField()
    let cvcTextField = UITextField()

    func enterPanInUITextField(
        presenter: PanViewPresenter, uiTextField: UITextField, _ text: String
    ) {
        let range = NSRange(location: 0, length: 0)

        _ = presenter.textField(
            uiTextField, shouldChangeCharactersIn: range, replacementString: text)
    }

    func canEnterExpiryDate(
        presenter: ExpiryDateViewPresenter, uiTextField: UITextField, _ text: String
    ) -> Bool {
        let range = NSRange(location: 0, length: 0)

        return presenter.textField(
            uiTextField, shouldChangeCharactersIn: range, replacementString: text)
    }

    func canEnterCvc(presenter: CvcViewPresenter, uiTextField: UITextField, _ text: String) -> Bool
    {
        let range = NSRange(location: 0, length: 0)

        return presenter.textField(
            uiTextField, shouldChangeCharactersIn: range, replacementString: text)
    }
}
