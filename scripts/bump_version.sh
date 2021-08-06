#!/bin/bash

help="\nUsage: bump_version.sh -v=<version -t=<rally_ticket_number>\n"

for i in "$@"
do
case $i in
    -v=*|--version=*)
    version="${i#*=}"
    shift
    ;;
    -t=*|--ticket=*)
    rally_ticket_number="${i#*=}"
    shift
    ;;
    *)
    echo "Unknonwn option $i \n"
    echo $help
    exit 2
    # unknown option
    ;;
esac
done

if [ -z "${version}"  ]; then
  echo "Version must be specified"
  echo -e $help
  exit 2
elif [ -z "${rally_ticket_number}"  ]; then
  echo "Ticket number must be specified"
  echo -e $help
  exit 2
elif ! [[ "${version}" =~ ^[0-9]\.[0-9]\.[0-9]$ ]]; then
  echo "Version has incorrect format, must be x.y.z"
  echo -e $help
  exit 2
elif ! [[ "${rally_ticket_number}" =~ ^US[0-9]{6}$ ]]; then
  echo "Ticket number has incorrect format, must be USxxxxxx"
  echo -e $help
  exit 2
fi

# Changing version in code
./scripts/change_version_in_code.sh $version
status=$?

if [ $status -ne 0 ]; then
  exit $status
fi

# Re-installing pods in app because SDK version is changed
cd AccessCheckoutDemo
pod install

status=$?

if [ $status -ne 0 ]; then
  exit $status
fi

cd ..

# Committing changes
git add AccessCheckoutDemo/AccessCheckoutDemo/Info.plist
git add AccessCheckoutSDK.podspec
git add AccessCheckoutSDK/AccessCheckoutSDK/Info.plist
git add AccessCheckoutSDK/AccessCheckoutSDK/api/UserAgent.swift
git add scripts/upload_pact.sh
git add scripts/verify_pact_tags.sh

git add AccessCheckoutDemo/Podfile.lock

git commit -m "${rally_ticket_number}: bump version to ${version}"

exit 0
