#!/bin/bash

# This script is used to add to the Demo app project the AccessCheckoutSDK as a local SPM dependency
# This is achieved by editing the project file

sed -i '' '/fileRef = 5174649927271F1A00E4902B/a\
		5193A86B282D0FBC00036506 /* AccessCheckoutSDK in Frameworks */ = {isa = PBXBuildFile; productRef = 5193A86A282D0FBC00036506 /* AccessCheckoutSDK */; };' \
./AccessCheckoutDemo/AccessCheckoutDemo.xcodeproj/project.pbxproj


sed -i '' '/path = Configuration.swift;/a\
    5193A8A7282D211600036506 /* access-checkout-ios */ = {isa = PBXFileReference; lastKnownFileType = folder; name = "access-checkout-ios"; path = ..; sourceTree = "<group>"; };' \
./AccessCheckoutDemo/AccessCheckoutDemo.xcodeproj/project.pbxproj


sed -i '' '/\/\* Pods_AccessCheckoutDemo.framework in Frameworks \*\/,/a\
				5193A8AB282D211C00036506 /* AccessCheckoutSDK in Frameworks */,' \
./AccessCheckoutDemo/AccessCheckoutDemo.xcodeproj/project.pbxproj


sed -i '' '/C9AFE3F822B799AC00943B3E \/\* AccessCheckoutDemo \*\/,/i\
				5193A8A7282D211600036506 /* access-checkout-ios */,' \
./AccessCheckoutDemo/AccessCheckoutDemo.xcodeproj/project.pbxproj


sed -i '' '/name = AccessCheckoutDemo/a\
			packageProductDependencies = (\
				5193A8AA282D211C00036506 /* AccessCheckoutSDK */,\
			);' \
./AccessCheckoutDemo/AccessCheckoutDemo.xcodeproj/project.pbxproj


sed -i '' '/End XCConfigurationList section/a\
/* Begin XCSwiftPackageProductDependency section */\
		5193A8AA282D211C00036506 /* AccessCheckoutSDK */ = {\
			isa = XCSwiftPackageProductDependency;\
			productName = AccessCheckoutSDK;\
		};\
/* End XCSwiftPackageProductDependency section */' \
./AccessCheckoutDemo/AccessCheckoutDemo.xcodeproj/project.pbxproj
