#!/usr/bin/env bash
# fail if any commands fails
set -e
# debug log
set -x

# Download and install Swift environment variable innjector
curl -ssl https://raw.githubusercontent.com/LucianoPAlmeida/variable-injector/0.3.3/scripts/install-binary.sh | sh

# Replacing env variables
variable-injector --file AccessCheckoutDemo/AccessCheckoutDemo/CIVariables.swift --verbose
