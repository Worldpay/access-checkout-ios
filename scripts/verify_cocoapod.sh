#!/bin/sh

# retrieve all remote tags
git fetch --tags > /dev/null 2>&1

# list the tags and store in the versions array
VERSIONS=`git tag`

# if we do not have any versions (i.e. tags) then we want to fail this script
if [[ -z "${VERSIONS}" ]]; then
  echo "FAILED: could not retrieve tags from git"
  exit 1
else
  echo "TAGS FOUND:" ${VERSIONS[@]}
  echo
fi

# keep a list of versions that we do not want to check
EXCLUDED_VERSIONS=("v1.0.0" "v1.1.0")

# initialise arrays that will keep a list of found and not found versions
success=()
failed=()

for version in ${VERSIONS[*]}
do
    # var to hold status message
    msg=""

    # ignore this iteration if the current version is to be excluded
    if [[ "${EXCLUDED_VERSIONS[*]}" == *"${version}"* ]]; then
      echo "${version} > EXCLUDED"
      continue
    else
      msg+="${version} > CHECKING"
    fi

    # check if the current version in question exists in cocoapod specs
    URL="https://raw.githubusercontent.com/CocoaPods/Specs/master/Specs/4/9/d/AccessCheckoutSDK/${version:1}/AccessCheckoutSDK.podspec.json"
    curl -s -I "${URL}" | head -1 | grep "200 OK" > /dev/null 2>&1
    status=$?

    # if found add it to the success array otherwise to the failed array
    if [ ${status} -eq 0 ]; then
      echo "${msg} ... FOUND"
      success+=(${version})
    else
      echo "${msg} ... NOT FOUND"
      failed+=(${URL})
    fi
done

echo

if [ -z "${failed}" ]; then
  echo "SUCCESS!"
else
  echo "FAILED REQUESTS:"
  echo "${failed[@]}" | tr " " "\n"
fi

echo

# fail the script if the failed array is not empty
$([ -z "${failed}" ] && exit 0 || exit 1)
