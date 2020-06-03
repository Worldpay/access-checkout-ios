# This script has been added as a BuildPhase in the AccessCheckoutSDKTests Build Phases.
# It will run everytime tests are compiled or run.
#
# Steps to generate a new mock class using Cuckoo for an existing production code class or protocol
# 1. At the bottom of this script, add another line with the path of the swift file containing the production code class or protocol
#    e.g. "${INPUT_SOURCE_DIR}/my-folder/my-filename.swift"
# 2. Add a trailing \ to the previous line. As indicated at the very bottom, all lines of the Cuckoo run command must end with a \ apart from the last line
# 3. Run tests or alternatively build the AccessCheckoutSDKTests target. This will generate the new mock class
# 4. In a terminal window, ls the "/AccessCheckoutSDK/AccessCheckoutSDKTests/mock" directory to ensure you can see the swift file containing the new mock class generated by Cuckoo
# 5. In the file explorer part of this window, on the left hand-side, right-click the "mock" folder in "AccessCheckoutSDKTests" and click 'Add Files to "AccessCheckoutSDK"...'
# 6. In the pop up window that's opened, select the swift file containing the new mock class to add

echo "Running from sh file"
# Define output file. Change "${PROJECT_DIR}/${PROJECT_NAME}Tests" to your test's root source folder, if it's not the default name.
OUTPUT_DIR="${PROJECT_DIR}/${PROJECT_NAME}Tests/mock/"
echo "Mocks output directory = ${OUTPUT_DIR}"

# Define input directory. Change "${PROJECT_DIR}/${PROJECT_NAME}" to your project's root source folder, if it's not the default name.
INPUT_SOURCE_DIR="${PROJECT_DIR}/${PROJECT_NAME}"

# Generate mock files, include as many input files as you'd like to create mocks for.
"${PODS_ROOT}/Cuckoo/run" generate --testable "${PROJECT_NAME}" \
--no-header \
--file-prefix "Mock" \
--output "${OUTPUT_DIR}" \
"${INPUT_SOURCE_DIR}/api/SingleLinkDiscoveryFactory.swift" \
"${INPUT_SOURCE_DIR}/client/card/AccessCardDelegate.swift" \
"${INPUT_SOURCE_DIR}/client/cvv/CVVOnlyDelegate.swift" \
"${INPUT_SOURCE_DIR}/validation/api/CardBrandDtoTransformer.swift" \
"${INPUT_SOURCE_DIR}/validation/card/CvvWithPanValidationFlow.swift" \
"${INPUT_SOURCE_DIR}/validation/card/PanValidationStateHandler.swift" \
"${INPUT_SOURCE_DIR}/validation/card/PanValidator.swift" \
"${INPUT_SOURCE_DIR}/validation/cvv/CVVValidator.swift"
# all lines of this command must end with a \ apart from the last line
