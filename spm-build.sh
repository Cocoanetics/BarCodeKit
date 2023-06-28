# https://developer.apple.com/documentation/xcode/creating-a-multi-platform-binary-framework-bundle/

# ROOT_PATH=$("$(dirname xcFrameworks)"; pwd -P)
# pushd $ROOT_PATH > /dev/null

BUILD_DIR="build"
OUTPUT_PATH="Source/libs"

# requires BUILD_DIR to be set, defaults to `build`
function build_library_xcframework() { # LIBRARY_NAME, PRODUCT_NAME, XCODEPROJ_PATH, SCHEME
    LIBRARY_NAME=$1
    PRODUCT_NAME=$2
    PROJECT_NAME=$3
    SCHEME=$4
    OUTPUT_FILE="${OUTPUT_PATH}/${PRODUCT_NAME}.xcframework"

    # Remove previous products
    rm -rf "${OUTPUT_FILE}"

    # Build archive for iphoneos
    xcodebuild archive -project "${PROJECT_NAME}" -scheme "${SCHEME}" -sdk iphoneos \
     -archivePath "${BUILD_DIR}/${PRODUCT_NAME}-iphoneos.xcarchive" SKIP_INSTALL=NO BUILD_BINARY_FOR_DISTRIBUTION=YES

    # Build archive for iphonesimulator
    xcodebuild archive -project "${PROJECT_NAME}" -scheme "${SCHEME}" -sdk iphonesimulator \
     -archivePath "${BUILD_DIR}/${PRODUCT_NAME}-iphonesimulator.xcarchive" SKIP_INSTALL=NO BUILD_BINARY_FOR_DISTRIBUTION=YES

    # Package as XCFramework
    xcodebuild -create-xcframework \
        -library "${BUILD_DIR}/${PRODUCT_NAME}-iphoneos.xcarchive/Products/usr/local/lib/${LIBRARY_NAME}.a" \
        -headers "${BUILD_DIR}/${PRODUCT_NAME}-iphoneos.xcarchive/Products/usr/local/include" \
        -library "${BUILD_DIR}/${PRODUCT_NAME}-iphonesimulator.xcarchive/Products/usr/local/lib/${LIBRARY_NAME}.a" \
        -headers "${BUILD_DIR}/${PRODUCT_NAME}-iphonesimulator.xcarchive/Products/usr/local/include" \
        -output "${OUTPUT_FILE}"
}

build_library_xcframework "libBarCodeKit" "libBarCodeKit" "BarCodeKit.xcodeproj" "BarCodeKit (iOS)"

# popd > /dev/null