#!/usr/bin/env bash
# fail if any commands fails
set -e
# debug log
# set -x

export TARGET=${SDK_FRAMEWORK}
export COVERAGE=`xcrun xccov view --json --only-targets --report $BITRISE_XCRESULT_PATH | grep -E -o lineCoverage[^,]+,[^:]+:\"$TARGET\" | grep -m 1 -o -E '0\.\d{2}' | cut -b 3-4`

echo "*****               *****"
echo "***** CODE COVERAGE *****"
echo "*****               *****"
echo "CODE COVERAGE FOR ${TARGET}: ${COVERAGE}%"
