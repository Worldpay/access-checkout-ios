#!/usr/bin/env bash
# fail if any commands fails
set -e
# debug log
set -x

# Apply fix to generated PACT file
python $PROJECT_LOCATION/scripts/pactFix/main.py $PROJECT_LOCATION/AccessCheckoutSDK/tmp/pacts/access-checkout-ios-sdk-verified-tokens.json $PROJECT_LOCATION/access-checkout-ios-sdk-verified-tokens.json
