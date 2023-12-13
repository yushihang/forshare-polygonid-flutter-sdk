#!/bin/bash

#rustup component add rust-src --toolchain nightly-aarch64-apple-darwin
#rustup target add aarch64-apple-ios-sim --toolchain nightly
#rustup target add aarch64-apple-ios x86_64-apple-ios aarch64-apple-ios-sim

set -e

current_directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "current_directory:$current_directory"
# enter project directory
parent_directory="$(dirname "$current_directory")"
#echo "$parent_directory"
project_directory="$parent_directory"

cargo_path="$project_directory/Cargo.toml"

output_path="$project_directory/output"

framework_path="$parent_directory/xcframework/Frameworks"

# check project existance
if [ -e "$cargo_path" ]; then
    echo "$cargo_path exists."
else
    echo "Error: $cargo_path NOT found!"
    exit 1
fi

rm -rf "$output_path"
mkdir "$output_path"

target_path="$project_directory/target"
rm -rf "$target_path"

mkdir "$output_path/iPhoneSimulator" >/dev/null 2>&1
mkdir "$output_path/iPhoneOS" >/dev/null 2>&1

output_path_iphone_simulator_x86_64="$output_path/iPhoneSimulator/x86_64"
mkdir "$output_path_iphone_simulator_x86_64" > /dev/null 2>&1

output_path_iphone_simulator_arm64="$output_path/iPhoneSimulator/arm64"
mkdir "$output_path_iphone_simulator_arm64" > /dev/null 2>&1

output_path_iphone_simulator_universal="$output_path/iPhoneSimulator/universal"
mkdir "$output_path_iphone_simulator_universal" > /dev/null 2>&1

output_path_iphoneos_arm64="$output_path/iPhoneOS/arm64"
mkdir "$output_path_iphoneos_arm64" > /dev/null 2>&1

libName="libbabyjubjub.a"

cd "$project_directory"

myCC_ios_sim_arm64="$parent_directory/xcframework/bin/myCC_ios_sim_arm64"
myCC_ios_sim_x86_64="$parent_directory/xcframework/bin/myCC_ios_sim_x86_64"

CC="$myCC_ios_sim_arm64" RUSTFLAGS="-Zlocation-detail=none" cargo +nightly  build -Z build-std --target aarch64-apple-ios-sim --release -vv > "$output_path/cargo.arm64.log"
cp "$target_path/aarch64-apple-ios-sim/release/$libName" "$output_path_iphone_simulator_arm64"


CC="$myCC_ios_sim_x86_64" RUSTFLAGS="-Zlocation-detail=none" cargo +nightly build -Z build-std --target=x86_64-apple-ios --release -vv > "$output_path/cargo.x86_64.log"
cp "$target_path/x86_64-apple-ios/release/$libName" "$output_path_iphone_simulator_x86_64"

RUSTFLAGS="-Zlocation-detail=none" cargo +nightly build -Z build-std --target=aarch64-apple-ios --release -vv  > "$output_path/cargo.iosdevice.log" 2>&1
cp "$target_path/aarch64-apple-ios/release/$libName" "$output_path_iphoneos_arm64"

xcframework_name="babyjubjub"


lipo -create "$output_path_iphone_simulator_x86_64/$libName" "$output_path_iphone_simulator_arm64/$libName" -output "$output_path_iphone_simulator_universal/$libName"
cp "$output_path_iphone_simulator_universal/$libName" "$framework_path/$xcframework_name.xcframework/ios-arm64_x86_64-simulator/$libName"
cp "$output_path_iphoneos_arm64/$libName" "$framework_path/$xcframework_name.xcframework/ios-arm64/$libName"

#build babyjubjub_with_exception_handing
babyjubjub_with_exception_handing_path="$project_directory/xcframework/babyjubjub_with_exception_handing"
babyjubjub_with_exception_handing_xcode_proj_path="$babyjubjub_with_exception_handing_path/babyjubjub_with_exception_handing.xcodeproj"

if [ -e "$babyjubjub_with_exception_handing_xcode_proj_path" ]; then
    echo "$babyjubjub_with_exception_handing_xcode_proj_path exists."
else
    echo "Error: $babyjubjub_with_exception_handing_xcode_proj_path NOT found!"
    exit 1
fi

build_configuration="Release"

derivedDataPath="$project_directory/DerivedData"

rm -rf "$babyjubjub_with_exception_handing_path/build"

babyjubjub_with_exception_handing_libs_path="$babyjubjub_with_exception_handing_path/libs"

rm -rf "$babyjubjub_with_exception_handing_libs_path"

cp -rf "$framework_path/$xcframework_name.xcframework" "$babyjubjub_with_exception_handing_path/babyjubjub_with_exception_handing"

available_sdks=$(xcodebuild -showsdks)
ios_simulator_sdk=$(echo "$available_sdks" | grep -o "iphonesimulator[0-9.]*")
echo "Available iOS Simulator SDKs: $ios_simulator_sdk"

#available_sdks=$(xcodebuild -showsdks)
ios_device_sdk=$(echo "$available_sdks" | grep -o "iphoneos[0-9.]*")
echo "Available iOS Device SDKs: $ios_device_sdk"

scheme="babyjubjub_with_exception_handing"

libName="libbabyjubjub_with_exception_handing.a"

sdk="arm64"
xcodebuild -project "$babyjubjub_with_exception_handing_xcode_proj_path" -configuration "$build_configuration" -scheme "$scheme" -derivedDataPath "$derivedDataPath" -sdk "$ios_device_sdk" -arch "$sdk"

sdk="arm64"
xcodebuild -project "$babyjubjub_with_exception_handing_xcode_proj_path" -configuration "$build_configuration" -scheme "$scheme" -derivedDataPath "$derivedDataPath" -sdk "$ios_simulator_sdk" -arch "$sdk"

sdk="x86_64"
xcodebuild -project "$babyjubjub_with_exception_handing_xcode_proj_path" -configuration "$build_configuration" -scheme "$scheme" -derivedDataPath "$derivedDataPath" -sdk "$ios_simulator_sdk" -arch "$sdk"

xcframework_name="babyjubjub_with_exception_handing"
cp "$babyjubjub_with_exception_handing_libs_path/Release_iphoneos_arm64/$libName" "$framework_path/$xcframework_name.xcframework/ios-arm64/$libName"



lipo -create "$babyjubjub_with_exception_handing_libs_path/Release_iphonesimulator_arm64/$libName" "$babyjubjub_with_exception_handing_libs_path/Release_iphonesimulator_x86_64/$libName" -output "$framework_path/$xcframework_name.xcframework/ios-arm64_x86_64-simulator/$libName"




echo "Finished"