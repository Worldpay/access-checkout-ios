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
elif ! [[ "${version}" =~ ^[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{1,2}$ ]]; then
  echo "Version has incorrect format, must be x.y.z"
  echo -e $help
  exit 2
elif ! [[ "${rally_ticket_number}" =~ ^US[0-9]{6,7}$ ]]; then
  echo "Ticket number has incorrect format, must be USxxxxxxx"
  echo -e $help
  exit 2
fi


# Checking that there are no pending changes to commit
echo "Checking that there are no pending changes to commit"
git diff --exit-code > /dev/null
indexCheckExitCode=$?

git diff --cached --exit-code > /dev/null
stagingAreaCheckExitCode=$?

if [[ $indexCheckExitCode -eq 1 || $stagingAreaCheckExitCode -eq 1  ]]; then
  echo "Please run git reset --hard HEAD to clean your index and staging area"
  exit 1
fi


# Pulling latest & creating new branch based off master
newBranch="${rally_ticket_number}-bump-version-to-${version}"

echo "Checking out master"
git checkout master

echo "Pulling latest changes"
git pull

echo "Checking out new branch ${newBranch}"
git checkout -b $newBranch


# Changing version in code
echo "Changing version in code to ${version}"
./scripts/change_version_in_code.sh $version
status=$?

if [ $status -ne 0 ]; then
  exit $status
fi


# Re-installing pods in app because SDK version is changed
echo "Re-installing pods in app due to SDK version change"
cd AccessCheckoutDemo
pod install

status=$?

if [ $status -ne 0 ]; then
  exit $status
fi

cd ..


echo "Committing changes"
git add .
git commit -m "${rally_ticket_number}: bump version to ${version}"

echo "Pushing branch ${newBranch}"
git push --set-upstream origin $newBranch

exit 0
