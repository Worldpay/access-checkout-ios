# Access Checkout SDK for iOS

## Table of Contents
* [Project Structure](#project-structure)
* [Integrate the SDK into an iOS app](#integrate-the-sdk-into-an-ios-app)
* [Generate a Verified Tokens session](#generate-a-verified-tokens-session)
* [Generate a Payments CVC session](#generate-a-payments-cvc-session)
* [Generate a Verified Tokens session and a Payments CVC session](#generate-a-verified-tokens-session-and-a-payments-cvc-session)
* [Handling errors](#handling-errors)
* [Integrating the UI components validation for a payment flow with full card details](#integrating-the-ui-components-validation-for-a-payment-flow-with-full-card-details)
* [Integrating the UI components validation for a payment flow with CVV only](#integrating-the-ui-components-validation-for-a-payment-flow-with-cvv-only)
* [Getting started with SDK development](#getting-started-with-sdk-development)

## Project Structure

<div align="right">
    <b><a href="#access-checkout-sdk-for-ios">↥ back to top</a></b>
</div>

Access Checkout iOS is split into two projects:

1. The [AccessCheckoutSDK](/AccessCheckoutSDK), available as a [Cocoapods](https://cocoapods.org) pod
2. A sample App, [AccessCheckoutDemo](/AccessCheckoutDemo), demonstrating how to integrate the different functionalities available in the SDK

## Integrate the SDK into an iOS app

<div align="right">
    <b><a href="#access-checkout-sdk-for-ios">↥ back to top</a></b>
</div>

The SDK can be integrated into an iOS app for the following functionality:

1. Generate sessions to be used to integrate with Worldpay payments API services
    - generate a Verified Tokens session
    - generate a Payments CVC session
    - generate both a Verified Tokens session and a Payments CVC session
2. PAN, Expiry Date and CVC UI components with built-in validation mechanism
    - content of the UI components is validated on user input using a set of fixed rules
    - merchant's code can adopt a protocol to listen to validation events raised by the UI components    
    
## Generate a Verified Tokens session

<div align="right">
    <b><a href="#access-checkout-sdk-for-ios">↥ back to top</a></b>
</div>

**As a merchant, you will want to use this feature as part of a payment flow with full card details for a non-Mastercard card.**

All code displayed below is to be added into a class/a method that handles your payment flow. The following assumptions are made:
* you have added the `AccessCheckoutSDK` to your project as a Cocoapods dependency
* you have added an `import AccessCheckoutSDK` at the top of your swift file
* your view uses the `PanView`, `ExpiryDateView` and `CvcView` components provided by the `AccessCheckoutSDK`

e.g. 
```swift
import AccessCheckoutSDK

class ViewController: UIViewController {

    @IBOutlet weak var panView: PanView!
    @IBOutlet weak var expiryDateView: ExpiryDateView!
    @IBOutlet weak var cvcView: CvcView!

    func submitButtonClickHandler() {
        // code to generate your session(s)
        ...
    }   
    ...
```

---

**1. Create an instance of the CardDetails class with the PAN, expiry date and CVC to submit.**
    
```swift
guard let pan = panView.text, expiryDate = expiryDateView.text, cvc = cvcView.text else {
    return
}

// The CardDetailsBuilder will throw an error if the expiry date is provided in a format different from MM/YY or MMYY
let cardDetails:CardDetails = try! CardDetailsBuilder().pan(pan)
    .expiryDate(expiryDate)
    .cvc(cvc)
    .build()
```
**2. Create an instance of an AccessCheckoutClient using the `Merchant ID` provided to you by Worldpay**

```swift
// The accessBaseUrl corresponds to Worldpay's try or production environment
// It is hard-coded for the sake of this example but in practice should be coming from some form of configuration
let accessBaseUrl:String = "https://access.worldpay.com"
let yourMerchantId = "..."

// The AccessCheckoutClientBuilder will throw an exception if either the accessBaseUrl or merchantId are missing 
let accessCheckoutClient:AccessCheckoutClient? = try? AccessCheckoutClientBuilder().accessBaseUrl(accessBaseUrl)
   .merchantId(yourMerchantId)
   .build()
```
   
**3. Generate the session by using `[SessionType.verifiedTokens]` as the type of session to generate**

```swift
try? accessCheckoutClient?.generateSessions(cardDetails: cardDetails, sessionTypes: [SessionType.verifiedTokens]) { result in
    DispatchQueue.main.async {
        switch result {
        case .success(let sessions):
            // The session is returned in a Dictionary[SessionType:String]
            let session = sessions[SessionType.verifiedTokens]
            ...
        case .failure(let error):
            // The error returned is of type AccessCheckoutError (see the Handling errors section for more details) 
            let errorDescription = error.localizedDescription
            ...
        }
    }
}
```
* The call to `generateSessions` takes a closure that returns a `Result<[SessionType: String], AccessCheckoutError>`
* Note the use of the main thread in the closure. This is because handling the success/failure would lead to updating the UI

## Generate a Payments CVC session

<div align="right">
    <b><a href="#access-checkout-sdk-for-ios">↥ back to top</a></b>
</div>

**As a merchant, you will want to use this feature as part of a payment flow with only a CVC, e.g. as part of a recurring payment.**
   
All code displayed below is to be added into a class/a method that handles your payment flow. The following assumptions are made:
* you have added the `AccessCheckoutSDK` to your project as a Cocoapods dependency
* you have added an `import AccessCheckoutSDK` at the top of your swift file
* your view uses the `PanView`, `ExpiryDateView` and `CvcView` components provided by the `AccessCheckoutSDK`

**1. Create an instance of the CardDetails class with the CVC to submit.**
    
```swift
let cvc:String = cvcView.text

let cardDetails:CardDetails = CardDetailsBuilder().cvc(cvc)
    .build()   
```
 
**2. Create an instance of an AccessCheckoutClient using the `Merchant ID` provided to you by Worldpay**

```swift
// This URL corresponds to Worldpay's try or production environment
// It is hard-coded for the sake of this example but in practice should be coming from some form of configuration
let environmentUrl:String = "https://access.worldpay.com"
let yourMerchantId = "..."

// The AccessCheckoutClientBuilder will throw an exception if either the accessBaseUrl or merchantId are missing
let accessCheckoutClient:AccessCheckoutClient? = try? AccessCheckoutClientBuilder().accessBaseUrl(environmentUrl)
   .merchantId(yourMerchantId)
   .build()
```
   
**3. Generate the session by using `[SessionType.paymentsCvc]` as the type of session to generate**

```swift
try? accessCheckoutClient?.generateSessions(cardDetails: cardDetails, sessionTypes: [SessionType.paymentsCvc]) { result in
    DispatchQueue.main.async {
        switch result {
        case .success(let sessions):
            // The session is returned in a Dictionary[SessionType:String]
            let session = sessions[SessionType.verifiedTokens]
            ...
        case .failure(let error):
            // The error returned is of type AccessCheckoutError
            let errorDescription = error.localizedDescription
            ...
        }
    }
}
```
* The call to `generateSessions` takes a closure that returns a `Result<[SessionType: String], AccessCheckoutError>`
* Note the use of the main thread in the closure. This is because handling the success/failure would lead to updating the UI

## Generate a Verified Tokens session and a Payments CVC session

<div align="right">
    <b><a href="#access-checkout-sdk-for-ios">↥ back to top</a></b>
</div>

**As a merchant, you will want to use this feature as part of a payment flow with full card details for a Mastercard card.**

All code displayed below is to be added into a class/a method that handles your payment flow. The following assumptions are made:
* you have added the `AccessCheckoutSDK` to your project as a Cocoapods dependency
* you have added an `import AccessCheckoutSDK` at the top of your swift file
* your view uses the `PanView`, `ExpiryDateView` and `CvcView` components provided by the `AccessCheckoutSDK`
  
**1. Create an instance of the CardDetails class with the PAN, expiry date and CVC to submit.**
    
```swift
guard let pan = panView.text, expiryDate = expiryDateView.text, cvc = cvcView.text else {
    return
}

// The CardDetailsBuilder will throw an error if the expiry date is provided in a format different from MM/YY or MMYY
let cardDetails:CardDetails = try! CardDetailsBuilder().pan(pan)
    .expiryDate(expiryDate)
    .cvc(cvc)
    .build()
```

**2. Create an instance of an AccessCheckoutClient using the `Merchant ID` provided to you by Worldpay**

```swift
// This URL corresponds to Worldpay's try or production environment
// It is hard-coded for the sake of this example but in practice should be coming from some form of configuration
let environmentUrl:String = "https://access.worldpay.com"
let yourMerchantId = "..."

// The AccessCheckoutClientBuilder will throw an exception if either the accessBaseUrl or merchantId are missing
let accessCheckoutClient:AccessCheckoutClient? = try? AccessCheckoutClientBuilder().accessBaseUrl(environmentUrl)
   .merchantId(yourMerchantId)
   .build()
```
   
**3. Generate the sessions by using `[SessionType.verifiedTokens, SessionType.paymentsCvc]` as the type of session to generate**

```swift
try? accessCheckoutClient?.generateSessions(cardDetails: cardDetails, sessionTypes: [SessionType.verifiedTokens]) { result in
    DispatchQueue.main.async {
        switch result {
        case .success(let sessions):
            // Sessions are always returned as a [SessionType:String]
            let verifiedTokensession = sessions[SessionType.verifiedTokens]
            let paymentsCvcSession = sessions[SessionType.paymentsCvc]
            ...
        case .failure(let error):
            // Errors are always of type AccessCheckoutError
            let errorDescription = error.localizedDescription
            ...
        }
    }
}
```
* The call to `generateSessions` takes a closure that returns a `Result<[SessionType: String], AccessCheckoutError>`
* Note the use of the main thread in the closure. This is because handling the success/failure would lead to updating the UI
   
## Handling errors

<div align="right">
    <b><a href="#access-checkout-sdk-for-ios">↥ back to top</a></b>
</div>

Errors are returned in the form of an instance of the `AccessCheckoutError` struct. 
This allows you to get more details about the actual error that has occurred.

This struct contains the following fields:
* message (String)
* validationErrors: an array of `AccessCheckoutValidationError` with more details about the error
* each `AccessCheckoutValidationError` contains an `errorName`, `message` and `jsonPath` providing details about the validation that failed and the field for which that validation failed.

The details provided in the error is helpful during the integration phase but pretty much irrelevant in production given that all what would be expected following to an error is for the end user to verify their card details and try again.   

```swift
try? accessCheckoutClient?.generateSessions(cardDetails: ..., sessionTypes: ...) { result in
    DispatchQueue.main.async {
        switch result {
        case .success(let sessions):
            ...
        case .failure(let error):
            ...
        }
    }
}
```
  
## Integrating the components with built-in validation for a payment flow with full card details

<div align="right">
    <b><a href="#access-checkout-sdk-for-ios">↥ back to top</a></b>
</div>

The three basic components for this integration are as follows:

* An `AccessCheckoutCardValidationDelegate` is designed to receive events pertaining to validation 
* An instance of `CardValidationConfig` contains all the information required for the initialisation of the validation flow, including references to the view components to enable validation for
* An `AccessCheckoutValidationInitialiser` is responsible for initialising the validation flow

---

1. Begin by creating and referencing the UI components in your view controller:

```swift
import AccessCheckoutSDK

class ViewController: UIViewController {

  @IBOutlet weak var panView: PanView!
  @IBOutlet weak var expiryDateView: ExpiryDateView!
  @IBOutlet weak var cvcView: CvcView!
  ...
```

  * Note to import the `AccessCheckoutSDK` module.

2. Implement the `AccessCheckoutCardValidationDelegate` protocol. This will allow your code to be notified of validation events and card brand changes on user input:

```swift
extension ViewController: AccessCheckoutCardValidationDelegate {

    func cardBrandChanged(cardBrand: CardBrand?) {
        // A brand contains a name an array of images providing the same image in different types
        // Each image has a URL and a type (either image/png or image/svg+xml)
        // This will update in the UI a card image displayed next to the PAN
        if let imageUrl = cardBrand?.images.filter({ $0.type == "image/png" }).first?.url,
            let url = URL(string: imageUrl) {
            updateCardBrandImage(url: url)
        } else {
            // This situation occurs when the SDK as not been able to identify the card brand from the PAN entered by the end-user
            panView.imageView.image = ...
        }
    }
    
    func panValidChanged(isValid: Bool) {
        // You may want to do something such as changing the text colour
        panView.textColor = isValid ? nil : UIColor.red
        
        if !valid {
            submitButton.isEnabled = false
        }
    }
    
    func cvcValidChanged(isValid: Bool) {
        // You may want to do something such as changing the text colour
        cvcView.textColor = isValid ? nil : UIColor.red
        
        if !valid {
            submitButton.isEnabled = false
        }
    }
    
    func expiryDateValidChanged(isValid: Bool) {
        // You may want to do something such as changing the text colour
        expiryDateView.textColor = isValid ? nil : UIColor.red
        
        if !valid {
            submitButton.isEnabled = false
        }
    }
    
    func validationSuccess() {
        submitButton.isEnabled = true
    }

    private func updateCardBrandImage(url: URL) {
        DispatchQueue.global(qos: .userInteractive).async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.panView.imageView.image = UIImage(data: data)
                }
            }
        }
    }
}
```

3. In your `viewDidLoad()` handler, instantiate a `CardValidationConfig` and initialise the validation
  
```swift
override func viewDidLoad() {
    ...
    let validationConfig = CardValidationConfig(panView: panView,
                                            expiryDateView: expiryDateView,
                                            cvcView: cvcView,
                                            accessBaseUrl: accessBaseUrl,
                                            validationDelegate: self)

    AccessCheckoutValidationInitialiser().initialise(validationConfig)
}
```  

## Integrating the UI components validation for a payment flow with CVV only

<div align="right">
    <b><a href="#access-checkout-sdk-for-ios">↥ back to top</a></b>
</div>

The basic component for this integration is `AccessCheckoutCVVOnly`:

* An `AccessCheckoutCVVOnly` is responsible for managing the CVV UI component. The SDK provides an implementation
of this component or for more custom requirements you may provide your own

---

1. Begin by creating and referencing the UI component in your view controller:

```swift
import AccessCheckoutSDK

class ViewController: UIViewController {

  @IBOutlet weak var cvcView: CvcView!
  ...
```

  * Note to import the `AccessCheckoutSDK` module.

2. Implement the `AccessCheckoutCvcOnlyValidationDelegate` protocol. This will allow your code to be notified of validation events on user input:

```swift
extension ViewController: AccessCheckoutCvcOnlyValidationDelegate {

    func cvcValidChanged(isValid: Bool) {
        // You may want to do something such as changing the text colour
        cvcView.textColor = isValid ? nil : UIColor.red
        
        if !valid {
            submitButton.isEnabled = false
        }
    }
    
    // This is complimentary to cvcValidChanged() which will also be notified when the Cvc is valid
    func validationSuccess() {
        submitButton.isEnabled = true
    }
}
```

3. In your `viewDidLoad()` handler, instantiate a `CvcOnlyValidationConfig` and initialise the validation
  
```swift
override func viewDidLoad() {
    ...
    let validationConfig = CvcOnlyValidationConfig(cvcView: cvcView, validationDelegate: self)
    AccessCheckoutValidationInitialiser().initialise(validationConfig)
}
```  

## Getting started with SDK development

<div align="right">
    <b><a href="#access-checkout-sdk-for-ios">↥ back to top</a></b>
</div>

### Building the SDK project

```
Note: <access-checkout-ios-root> refers to the folder that contains your copy of the access-checkout-ios repository
```

1. Install XCode, if not already installed

2. Install cocoapods (for dependency management), if not already installed
    ```
    sudo gem install cocoapods
    ```
3. Install dependencies for the SDK project (i.e. add pods)
    ```
    cd <access-checkout-ios-root>/AccessCheckoutSDK
    pod install
    pod update
    ```
4. Open project in XCode
    1. Click on 'File > Open'
    2. Select the '<access-checkout-ios-root>/AccessCheckoutSDK/' directory and click 'Open'
    
5. Build the project
    1. Click the `Play` button in the top left corner to build the project, the build should be successful.
    
### Running tests

1. Install `pact-ruby-standalone`
    1. Download a copy from https://github.com/pact-foundation/pact-ruby-standalone
    2. Unzip the file in a folder of your choice (reference as `<pact-ruby-folder>` hereafter)
    3. Run the `install.sh` script located in `<pact-ruby-folder>`. This will install binaries in `<pact-ruby-folder>/pact/bin/`
    
2. Create a syml link to the `pact-ruby-standalone` binaries in the AccessCheckoutSDK project
    ```
    cd <access-checkout-ios-root>/AccessCheckoutSDK/
    mkdir pact
    cd pact
    ln -s <pact-ruby-folder>/pact/bin .
    ```
    This step is required because we have configured a Test pre-action/post-action in XCode to start/stop a mock-service 
    before and after the PACT tests. If you want, you can check this configuration as following:
    ```
    1. Click on the AccessCheckoutSDK scheme next to the Play/Stop icon at the top of XCode
    2. Click `Edit Scheme`
    3. Expand `Test`
    4. Click on `Pre-actions` / `Post-actions` to see the commands that are run
    ```
    
3. Go to the Test Navigator in XCode. You can access it by
    1. Clicking on View > Navigators > Show Test Navigator menu
    2. Or by clicking on the Diamond icon in the small menu bar above the list of modules
    
4. Click on the `Play` icon next to `AccessCheckoutSDKTests` to run the unit tests

5. Click on the `Play` icon next to `AccessCheckoutSDKPactTest` to run the PACT tests
    1. If you're having failures, make sure that the `<access-checkout-ios-root>/AccessCheckoutSDK/pact/bin` sym link exists

6. When running the Pact tests to generate and upload new Pact versions - make sure you run each Pact test file separately one after the other. There is an issue with PactConsumerSwift not supporting multiple providers.

### Generate a mock class using Cuckoo for an existing production code class or protocol

See instructions in the `AccessCheckoutSDK/scripts/mocks-build-phase.sh` script

### Running the Demo App

1. Install dependencies for the demo app
    ```
    cd <access-checkout-ios-root>/AccessCheckoutDemo
    pod install
    ```
2. Open project in XCode
    1. Click on 'File > Open'
    2. Select the '<access-checkout-ios-root>/AccessCheckoutSDKDemo/' directory and click 'Open'
    
3. Run the demo app
    1. Click the `Play` button on the top-left corner of the screen to open the demo app in the simulated device of your choice.
    