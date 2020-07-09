#!/bin/bash
set -e

export CONTRACT_VERSION="1.3.0"
export HASH_CODE=$(git rev-parse --short HEAD)

curl --fail --show-error -v -XPUT \-H "Content-Type: application/json" \
  -d@$BITRISE_SOURCE_DIR/AccessCheckoutSDK/pacts/access-checkout-ios-sdk-verified-tokens.json \
  -u $PACTBROKER_USERNAME:$PACTBROKER_PASSWORD \
  https://$PACTBROKER_URL/pacts/provider/verified-tokens/consumer/access-checkout-iOS-sdk/version/$CONTRACT_VERSION+$HASH_CODE

curl --fail --show-error -v -XPUT \-H "Content-Type: application/json" \
  -d@$BITRISE_SOURCE_DIR/AccessCheckoutSDK/pacts/access-checkout-ios-sdk-sessions.json \
  -u $PACTBROKER_USERNAME:$PACTBROKER_PASSWORD \
  https://$PACTBROKER_URL/pacts/provider/sessions/consumer/access-checkout-iOS-sdk/version/$CONTRACT_VERSION+$HASH_CODE

export BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [ $BRANCH == "master" ]
then
  curl --fail --show-error -v -XPUT \-H "Content-Type: application/json" \
  -u $PACTBROKER_USERNAME:$PACTBROKER_PASSWORD \
  https://$PACTBROKER_URL/pacticipants/access-checkout-iOS-sdk/versions/$CONTRACT_VERSION+$HASH_CODE/tags/master
fi
