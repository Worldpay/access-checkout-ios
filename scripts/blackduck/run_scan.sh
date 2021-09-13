#!/bin/bash

echo "Initiating Blackduck Scan..."

curl -LOk https://detect.synopsys.com/detect.sh
chmod +x ./detect.sh
SDK_VERSION=$(grep 'spec.version' AccessCheckoutSDK.podspec | cut -d= -f2 | sed -e 's/"//g' | awk '{$1=$1};1')
./detect.sh --blackduck.url="https://fis2.app.blackduck.com/" --blackduck.api.token=$hydra_aco_blackduck_token --blackduck.trust.cert=true --detect.project.name=$BLACKDUCK_PROJECT_NAME --detect.project.version.name=$SDK_VERSION --detect.risk.report.pdf=true
