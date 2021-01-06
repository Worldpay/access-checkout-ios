new_version=$1

updateVersionInInfoPlist(){
  sed -i '' '/CFBundleShortVersionString/,/<string>/s/[0-9].[0-9].[0-9]/'"$1"'/' $2
}

updateVersionInPodSpec(){
  sed -i '' '/spec.version/s/[0-9].[0-9].[0-9]/'"$1"'/; /spec.source/s/[0-9].[0-9].[0-9]/'"$1"'/' $2
}

updateVersionInUserAgent(){
  sed -i '' '/sdkVersion/s/[0-9].[0-9].[0-9]/'"$1"'/' $2
}

updateVersionInPactScript(){
  sed -i '' '/CONTRACT_VERSION/s/[0-9].[0-9].[0-9]/'"$1"'/' $2
}

updateVersionInInfoPlist "$new_version" "../AccessCheckoutSDK/AccessCheckoutSDK/Info.plist"
updateVersionInInfoPlist "$new_version" "../AccessCheckoutDemo/AccessCheckoutDemo/Info.plist"
updateVersionInPodSpec "$new_version" "../AccessCheckoutSDK.podspec"
updateVersionInUserAgent "$new_version" "../AccessCheckoutSDK/AccessCheckoutSDK/api/UserAgent.swift"
updateVersionInPactScript "$new_version" "../scripts/upload_pact.sh"
updateVersionInPactScript "$new_version" "../scripts/verify_pact_tags.sh"
