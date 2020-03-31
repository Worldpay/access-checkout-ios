#!/bin/bash
set -e

export PACTBROKER_USERNAME="aesaiKekeethaht6"
export PACTBROKER_PASSWORD="tiToh3ii6nazei2ShoQu+ah4ohyaejee"
export PACTBROKER_URL="pactbroker-ext.npe.euw1.gw2.worldpay.io"
export BITRISE_SOURCE_DIR=".."
export PROJECT_VERSION="1.0.0"

curl --fail --show-error -v -XPUT \-H "Content-Type: application/json" \
  -d@$BITRISE_SOURCE_DIR/AccessCheckoutSDK/pacts/access-checkout-ios-sdk-sessions.json \
  -u $PACTBROKER_USERNAME:$PACTBROKER_PASSWORD \
  https://$PACTBROKER_URL/pacts/provider/sessions/consumer/access-checkout-iOS-sdk/version/$PROJECT_VERSION
