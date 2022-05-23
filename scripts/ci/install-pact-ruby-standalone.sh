#!/usr/bin/env bash
# fail if any commands fails
set -e
# debug log
set -x

# Download to AccessCheckout directory
cd AccessCheckoutSDK

echo "Fetching pact-ruby-standalone..."
curl -LO https://github.com/pact-foundation/pact-ruby-standalone/releases/download/v1.63.0/pact-1.63.0-osx.tar.gz

echo "Unpacking..."
tar xzf pact-1.63.0-osx.tar.gz

./pact/bin/pact-mock-service --help start
echo "... pact-ruby-standalone ready!"
