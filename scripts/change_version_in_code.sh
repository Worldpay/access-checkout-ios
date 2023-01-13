new_version=$1

if ! [[ "$new_version" =~ ^[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{1,2}$ ]]; then
    echo "Failed to change version in code.

Version provided must be in format x.y.z"
    exit 2
fi

updateVersionInInfoPlist(){
  sed -i '' '/CFBundleShortVersionString/,/<string>/s/[0-9]\{1,2\}.[0-9]\{1,2\}.[0-9]\{1,2\}/'"$1"'/' $2
}

updateVersionInPodSpec(){
  sed -i '' '/spec.version/s/[0-9]\{1,2\}.[0-9]\{1,2\}.[0-9]\{1,2\}/'"$1"'/; /spec.source/s/[0-9]\{1,2\}.[0-9]\{1,2\}.[0-9]\{1,2\}/'"$1"'/' $2
}

updateVersionInWpSdkHeader(){
  sed -i '' '/sdkVersion/s/[0-9]\{1,2\}.[0-9]\{1,2\}.[0-9]\{1,2\}/'"$1"'/' $2
}

updateVersionInPactScript(){
  sed -i '' '/CONTRACT_VERSION/s/[0-9]\{1,2\}.[0-9]\{1,2\}.[0-9]\{1,2\}/'"$1"'/' $2
}

updateVersionInInfoPlist "$new_version" "./AccessCheckoutSDK/AccessCheckoutSDK/Info.plist"
if [ $? -ne 0 ]; then
  echo "Failed to update version in ./AccessCheckoutSDK/AccessCheckoutSDK/Info.plist"
fi

updateVersionInInfoPlist "$new_version" "./AccessCheckoutDemo/AccessCheckoutDemo/Info.plist"
if [ $? -ne 0 ]; then
  echo "Failed to update version in ./AccessCheckoutDemo/AccessCheckoutDemo/Info.plist"
fi

updateVersionInPodSpec "$new_version" "./AccessCheckoutSDK.podspec"
if [ $? -ne 0 ]; then
  echo "Failed to update version in ./AccessCheckoutSDK.podspec"
fi

updateVersionInWpSdkHeader "$new_version" "./AccessCheckoutSDK/AccessCheckoutSDK/api/WpSdkHeader.swift"
if [ $? -ne 0 ]; then
  echo "Failed to update version in ./AccessCheckoutSDK/AccessCheckoutSDK/api/WpSdkHeader.swift"
fi

updateVersionInPactScript "$new_version" "./scripts/upload_pact.sh"
if [ $? -ne 0 ]; then
  echo "Failed to update version in ./scripts/upload_pact.sh"
fi

updateVersionInPactScript "$new_version" "./scripts/verify_pact_tags.sh"
if [ $? -ne 0 ]; then
  echo "Failed to update version in ./scripts/verify_pact_tags.sh"
fi
