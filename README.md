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

1. The [AccessCheckoutSDK](/AccessCheckoutSDK), available as a [Cocoapods](https://cocoapods.org) pod
2. A sample App, [AccessCheckoutDemo](/AccessCheckoutDemo), demonstrating how to integrate the different functionalities available in the SDK

## How to integrate the SDK in an iOS app

Refer to the Worldpay Developers documentation to find out how to integrate the SDK in your app - [https://developer.worldpay.com/docs/access-worldpay/checkout/ios](https://developer.worldpay.com/docs/access-worldpay/checkout/ios)

## Getting started with SDK development

<div align="right">s
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

## Security

Checkmarx scans are triggered on push via a webhook set up in GitHub, and CRs for new releases must have a valid Checkmarx report attached to the CR

## How-tos

### Bumping the SDK version

Run the command below to bump the SDK version in code. 
A commit with all relevant changes will be added to the branch currently checked out. 

`./scripts/bump_version.sh -v=[version] -t=[ticket_number]`
