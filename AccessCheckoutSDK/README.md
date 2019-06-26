# Access Checkout SDK for iOS

## Simple Integration Example

The three basic components for integration are as follows:

* A `Card` is responsible for managing the payment card views, card number, expiry date and CVV. The SDK provides implementations
of these views or for more custom requirements you may provide your own
* A `CardValidator` handles the validation of card fields
* The `AccessCheckoutClient` provides the interface to the Access Checkout API

---

1. Begin by creating and referencing the card views in your view controller:

  ```
  import AccessCheckoutSDK

  class ViewController: UIViewController {

      @IBOutlet weak var panView: PANView!
      @IBOutlet weak var expiryDateView: ExpiryDateView!
      @IBOutlet weak var cvvView: CVVView!
      ...
  ```

  * Note to import the `AccessCheckoutSDK` module.

2. Instantiate your `AccessCheckoutCard` object with the `CardView`'s:

  ```
  override func viewDidLoad() {

      let card = AccessCheckoutCard(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView)
      card.cardDelegate = self
  ```

  - The `CardDelegate` handles the events on the card views, add conformance to the protocol on the view controller
  and set on the card, e.g, `extension ViewController: CardDelegate { ...`
  
  3. Create a `CardValidator` with a `CardConfiguration` encapsulating card validation rules. A default card configuration is located here:
  [https://access.worldpay.com/access-checkout/cardConfiguration.json]
```
    let cardValidator = AccessCheckoutCardValidator()
    if let url = URL(string: <YOUR_CARD_CONFIGURATION>) {
        cardValidator.cardConfiguration = CardConfiguration(fromURL: url)
    }
    self.card = card
```

3. Create an `AccessCheckoutClient` instance with an `AccessCheckoutDiscovery` object:

  ```
    let accessCheckoutDiscovery = AccessCheckoutDiscovery(baseUrl: <ACCESS_CHECKOUT_BASE_URL>)
    accessCheckoutDiscovery.discover(urlSession: URLSession.shared) {
        self.accessCheckoutClient = AccessCheckoutClient(discovery: accessCheckoutDiscovery, merchantIdentifier: <MERCHANT_ID>)
    }
  ```

  * The `AccessCheckoutDiscovery` component provides the entry point to Access Checkout API Services and provides a single `discover()` function,
  this discovery may be called wherever fits your application's lifecycle.
  * You need to supply the <ACCESS_CHECKOUT_BASE_URL>, e.g. https://access.worldpay.com, and your unique merchant identifier <MERCHANT_ID>.

4. Implement the `CardDelegate` functions on the view controller:

  ```
  extension ViewController: CardDelegate {

    func cardView(_ cardView: CardView, isValid valid: Bool) {
        // Update your UI with the validation result
        cardView.isValid(valid: valid)
        // Check for card validity to enable submission
        if let valid = card?.isValid() {
            submitButton.isEnabled = valid
        }
    }

    func didChangeCardBrand(_ cardBrand: CardConfiguration.CardBrand?) {
        // Update any card brand on the panView
        if let imageUrl = cardBrand?.imageUrl {
            // Load the brand image here...
        } else {
            // Clear brand image here...
        }
    }
  }
  ```

  * The `cardView(_, isValid:)` function can be used to update the UI with card view validation
  outcomes and enabling the form for submission.

5. Implement a submit function on the view controller, e.g.:

  ```
  func submitCard(pan: PAN, month: ExpiryMonth, year: ExpiryYear, cvv: CVV) {

    accessCheckoutClient?.createSession(pan: pan,
                                        expiryMonth: expiryMonth,
                                        expiryYear: expiryYear,
                                        cvv: cvv) { result in
                                            DispatchQueue.main.async {
                                                switch result {
                                                case .success(let session):
                                                    // Session is returned here
                                                case .failure(let error):
                                                    // Error handling
                                                    if let accessCheckoutClientError = error as? AccessCheckoutClientError {
                                                        switch accessCheckoutClientError {
                                                        case .bodyDoesNotMatchSchema(_, let validationErrors):
                                                            // Handle validation errors
                                                        default:
                                                            break
                                                        }
                                                    } else {
                                                        // handle other errors
                                                    }
                                                }
                                            }
                                        }
    }
  ```

  * The create session result is returned as a `Result<String, Error>`
  * Errors may be of type `AccessCheckoutClientError`, which may contain an array, `[AccessCheckoutClientValidationError]`. These will
  need to be inspected and handle on the UI accordingly. Validation errors contain `jsonPath` properties to establish the offending card view.
  * The call to `createSession` takes a closure that returns on a background thread - note all UI calls on the main thread here.
