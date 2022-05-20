#!/usr/bin/env bash
# fail if any commands fails
set -e
# debug log
set -x

# Capture the release number and put it in a workflow variable
release_version=$(grep -A1 CFBundleShortVersionString AccessCheckoutSDK/AccessCheckoutSDK/Info.plist | grep string | sed -E "s/<\/?string>//g" | xargs echo -n)
envman add --key PROJECT_VERSION --value $release_version
