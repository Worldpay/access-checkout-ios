import UIKit
import AccessCheckoutSDK

class CvvOnlyFlowViewController: UIViewController {

    @IBOutlet weak var cvvField: CVVView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBAction func submitTouchUpInsideHandler(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cvvField.layer.borderWidth = 1
        cvvField.layer.borderColor = UIColor.lightText.cgColor
        cvvField.layer.cornerRadius = 8
        
        submitButton.isEnabled = false
    }
}

