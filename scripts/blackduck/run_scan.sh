#!/bin/bash

echo "Initiating Blackduck Scan..."

SDK_VERSION=$(grep 'spec.version' AccessCheckoutSDK.podspec | cut -d= -f2 | sed -e 's/"//g' | awk '{$1=$1};1')
cd AccessCheckoutSDK
curl -LOk https://detect.synopsys.com/detect.sh
chmod +x ./detect.sh
./detect.sh --blackduck.url="https://fis2.app.blackduck.com/" --blackduck.api.token=$hydra_aco_blackduck_token --blackduck.trust.cert=true --detect.project.name=$BLACKDUCK_PROJECT_NAME --detect.project.version.name=$SDK_VERSION --detect.detector.buildless=true --detect.risk.report.pdf=true
cd ..
