# Access Checkout SDK for iOS

## Table of Contents
* [Project Structure](#project-structure)
* [How to integrate the SDK in an iOS app](#how-to-integrate-the-sdk-in-an-ios-app)
* [Getting started with SDK development](#getting-started-with-sdk-development)

## Project Structure

<div align="right">
    <b><a href="#access-checkout-sdk-for-ios">↥ back to top</a></b>
</div>

Access Checkout iOS is split into two projects:

1. The [AccessCheckoutSDK](./AccessCheckoutSDK)
2. A sample App, [AccessCheckoutDemo](./AccessCheckoutDemo), demonstrating how to integrate the different functionalities available in the SDK

## How to integrate the SDK in an iOS app

Refer to the Worldpay Developers documentation to find out how to integrate the SDK in your app - [https://docs.worldpay.com/access/products/checkout/ios](https://docs.worldpay.com/access/products/checkout/ios)

## Getting started with SDK development

<div align="right">
    <b><a href="#access-checkout-sdk-for-ios">↥ back to top</a></b>
</div>

### Building the SDK project

```
Note: <access-checkout-ios-root> refers to the folder that contains your copy of the access-checkout-ios repository
```

1. Install XCode, if not already installed

2. Open project in XCode
    1. Click on 'File > Open'
    2. Select the '<access-checkout-ios-root>/AccessCheckoutSDK/AccessCheckoutSDK.xcodeproj' directory and click 'Open'
    
5. Build the project
    1. Click the `Product` > `Build` menu item to build the project.
    
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

See instructions in the [AccessCheckoutDemo](./AccessCheckoutDemo/README.md)

## Code formatting

[Swift format](https://github.com/swiftlang/swift-format) is used to format the code and uses the configuration set up in the `.swift-format` file as per the [configuration options available](https://github.com/swiftlang/swift-format/blob/main/Documentation/Configuration.md) in swift format
The code can be reformatted in command line by using 

```swift-format -i -r ./AccessCheckoutDemo ./AccessCheckoutSDK```

Note you may see errors due to swift format trying to format swift files in `Pods` directories. You can ignore those. This issue will be solved once swift-format supports ignoring files.

Do not format code using XCode as the indentation settings (and other formatting configuration) would be different to that defined in the .swift-format file.

**Code must be formatted using this tool before raising a PR.**
