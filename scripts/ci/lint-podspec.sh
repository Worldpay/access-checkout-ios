#!/usr/bin/env bash
# fail if any commands fails
set -e
# debug log
set -x

pod spec lint AccessCheckoutSDK.podspec --allow-warnings
