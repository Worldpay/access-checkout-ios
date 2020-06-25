# Access Checkout Demo for iOS

## A sample App to demonstrate an Access Checkout SDK integration

The Access Checkout SDK dependency is managed via Cocoapods, run `pod install` before building the example App.

## How to integrate the SDK in an iOS app

Refer to the Worldpay Developers documentation to find out how to integrate the SDK in your app - [https://developer.worldpay.com/docs/access-worldpay/checkout/ios](https://developer.worldpay.com/docs/access-worldpay/checkout/ios)

## CI related variables

CI related variables can be assigned within CIVariables.swift. These will be injected by the variable-injector plugin at build time in BitRise.
The swift-variable-injector step is configured within the bitrise primary workflow.

Note that because of what looks like a bug, the variable-injector plugin does not seem to replace the variables by their values in PR builds.

## Stubbing

By default this demo application uses stubs to emulate Worldpay API services.
