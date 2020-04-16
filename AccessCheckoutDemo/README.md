# Access Checkout Demo for iOS

## A sample App to demonstrate an Access Checkout SDK integration

The Access Checkout SDK dependency is managed via Cocoapods, run `pod install` before building the example App.


## CI related variables

CI related variables can be assigned within CIVariables.swift. These will be injected by the variable-injector plugin at build time.
The swift-variable-injector step is configured within the bitrise primary workflow.

Note that because of what looks like a bug, the variable-injector plugin does not seem to replace the variables by their values in PR builds.
