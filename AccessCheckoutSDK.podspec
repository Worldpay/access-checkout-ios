Pod::Spec.new do |spec|
  spec.name         = 'AccessCheckoutSDK'
  spec.version      = "2.3.0"
  spec.summary      = 'Worldpay Access Checkout iOS SDK'
  spec.description  = <<-DESC
  iOS SDK library for Worldpay Access Checkout.
                   DESC

  spec.documentation_url = 'https://developer.worldpay.com/docs/access-worldpay/checkout'

  spec.swift_version = '5.0'
  spec.platform = :ios
  spec.ios.deployment_target = '8.0'

  spec.homepage     = 'https://github.com/Worldpay/access-checkout-ios'
  spec.license      = { :type => 'MIT', :file => 'AccessCheckoutSDK/LICENSE' }

  spec.author       = 'Access Worldpay'

  spec.source       = { :git => "https://github.com/Worldpay/access-checkout-ios.git", :tag => "v2.3.0" }
  spec.source_files = 'AccessCheckoutSDK/AccessCheckoutSDK/**/*.{h,swift,xib,strings}'
  spec.public_header_files = 'AccessCheckoutSDK/AccessCheckoutSDK/AccessCheckoutSDK.h'
  spec.resources    = 'AccessCheckoutSDK/AccessCheckoutSDK/**/*.{json,png}'
end
