  
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


# Render Template.
cat > ${BITRISE_SOURCE_DIR}/coverage.html << EOF
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Access Checkout iOS Code Coverage</title>
  </head>
  <body>
    <h1>Access Checkout iOS Code Coverage</h1>
    <p><strong>Module:</strong> ${TARGET}</p>
    <p><strong>Rate:</strong> ${COVERAGE}%</p>
  </body>
</html>
EOF

envman add --key COVERAGE_RATE --value ${COVERAGE}
