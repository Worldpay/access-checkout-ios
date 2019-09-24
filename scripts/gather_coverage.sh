#!/usr/bin/env bash
# fail if any commands fails
set -e
# debug log
# set -x

export TARGET="${SDK_FRAMEWORK}"
export COVERAGE=`xcrun xccov view --json --only-targets --report $BITRISE_XCRESULT_PATH | jq --arg TARGET "$TARGET" '.[] | select(.name == $TARGET) | .lineCoverage' | cut -b 3-4`

echo "***** CODE COVERAGE *****"
echo "CODE COVERAGE FOR ${TARGET}: ${COVERAGE}%"
