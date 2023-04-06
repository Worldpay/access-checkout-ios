#!/bin/bash

echo "Initiating Blackduck Scan..."

SDK_VERSION=$(grep 'spec.version' AccessCheckoutSDK.podspec | cut -d= -f2 | sed -e 's/"//g' | awk '{$1=$1};1')
cd AccessCheckoutSDK
curl -LOk https://detect.synopsys.com/detect8.sh
mv  detect8.sh ./detect.sh
chmod +x ./detect.sh

if [ $IS_RELEASE_SCAN -eq 0 ]
then
  VERSION_NAME=$SDK_VERSION
else
  VERSION_NAME="$SDK_VERSION-RELEASE"
fi

./detect.sh --blackduck.url="https://fis2.app.blackduck.com/" --blackduck.api.token=$hydra_aco_blackduck_token --blackduck.trust.cert=true --detect.project.name=$BLACKDUCK_PROJECT_NAME --detect.project.version.name=$VERSION_NAME --detect.detector.buildless=true --detect.risk.report.pdf=true
cd ..
