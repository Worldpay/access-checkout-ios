#!/bin/bash
set -e

curl --fail --show-error -v -XPUT \-H "Content-Type: application/json" \
  -d@$BITRISE_SOURCE_DIR/access-checkout-ios-sdk-verified-tokens.json \
  -u $PACTBROKER_USERNAME:$PACTBROKER_PASSWORD \
  https://$PACTBROKER_URL/pacts/provider/verified-tokens/consumer/access-checkout-iOS-sdk/version/$PROJECT_VERSION
