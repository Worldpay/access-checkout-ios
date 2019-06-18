Pod::Spec.new do |spec|
  spec.name         = 'AccessCheckoutSDK'
  spec.version      = "1.0.0"
  spec.summary      = 'Worldpay Access Checkout iOS SDK'
  spec.description  = <<-DESC
  iOS SDK library for Worldpay Access Checkout.
                   DESC

  spec.documentation_url = 'https://beta.developer.worldpay.com/docs/access-worldpay/checkout'

  spec.swift_version = '5.0'
  spec.platform = :ios
  spec.ios.deployment_target = '8.0'

  spec.homepage     = 'https://github.com/Worldpay/access-checkout-ios'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }

  spec.author       = 'Access Worldpay'

  spec.source       = { :git => "https://github.com/Worldpay/access-checkout-ios", :tag => "v1.0.0" }
  spec.source_files = 'AccessCheckoutSDK/**/*.{h,swift,xib,strings}'
  spec.public_header_files = 'AccessCheckoutSDK/AccessCheckoutSDK.h'
  spec.resources    = 'AccessCheckoutSDK/**/*.{json,png}'
end
