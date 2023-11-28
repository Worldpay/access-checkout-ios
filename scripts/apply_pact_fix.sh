#!/usr/bin/env bash
# fail if any commands fails
set -e
# debug log
set -x

# Apply fix to generated PACT file
# - replaces . property notation  by [] property notation
python $BITRISE_SOURCE_DIR/scripts/pactFix/main.py \
       $BITRISE_SOURCE_DIR/AccessCheckoutSDK/pacts/access-checkout-ios-sdk-sessions.json \
       $BITRISE_SOURCE_DIR/AccessCheckoutSDK/pacts/access-checkout-ios-sdk-sessions.json

