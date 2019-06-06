Pod::Spec.new do |spec|
  spec.name         = 'AccessCheckout'
  spec.version      = "#{ENV['PROJECT_VERSION']}"
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

  spec.source       = { :git => "#{ENV['COCOAPODS_SOURCE_REPO_URL']}", :tag => "v#{spec.version}" }
  spec.source_files = 'AccessCheckout/AccessCheckout/**/*.{h,swift,xib,strings}'
  spec.public_header_files = 'AccessCheckout/AccessCheckout/AccessCheckout.h'
  spec.resources    = 'AccessCheckout/AccessCheckout/**/*.{json,png}'
end
