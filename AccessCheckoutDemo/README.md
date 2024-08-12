# Access Checkout Demo for iOS

A sample App to demonstrate an Access Checkout SDK integration

## Running the Access Checkout Demo App

1. Install dependencies
    ```
    # Install Cocoapods dependencies for the SDK first
    cd <access-checkout-ios-root>/AccessCheckoutSDK
    pod install
    
    # Install Cocoapods dependencies for the demo app
    cd <access-checkout-ios-root>/AccessCheckoutDemo
    pod install
    ```
2. Open project `AccessCheckoutDemo` in XCode
    1. Click on `File > Open`
    2. Select the `<access-checkout-ios-root>/AccessCheckoutSDKDemo/AccessCheckoutDemo.xcworkspace` directory and click `Open`

3. In the Project Navigator in XCode, click on the `AccessCheckoutDemo` app
4. In the app properties, select the `AccessCheckoutDemo` target under `Targets`
5. Scroll down to the `User-Defined` properties
6. Replace the `ACCESS_CHECKOUT_ID` value by the `Checkout ID` that was provided to you when you were on-boarded on Access Worldpay
7. To run the demo app, click the `Play` button in the top-left corner of the screen to open the demo app in the simulated device of your choice.

## How to integrate the SDK in an iOS app

Refer to the Worldpay Developers documentation to find out how to integrate the SDK in your app - [https://developer.worldpay.com/docs/access-worldpay/checkout/ios](https://developer.worldpay.com/docs/access-worldpay/checkout/ios)

## CI related variables

CI related variables can be assigned within CIVariables.swift. These will be injected by the variable-injector plugin at build time in BitRise.
The swift-variable-injector step is configured within the bitrise primary workflow.

Note that because of what looks like a bug, the variable-injector plugin does not seem to replace the variables by their values in PR builds.

## Stubbing

By default this demo application uses stubs to emulate Worldpay API services. 
They can be disabled by adding the `-disableStubs true` command line argument in the AccessCheckoutDemo scheme configuration.
