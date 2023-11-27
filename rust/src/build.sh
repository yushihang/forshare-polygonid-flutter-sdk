rm -rf target

#for simulator arm64
CC=/Users/yushihang/Library/Developer/Xcode/DerivedData/myClang-bgbvbtfirelimyeoxcmvtvnahuys/Build/Products/Debug/myCC cargo +nightly build -Z build-std --target aarch64-apple-ios-sim --release -vvvv > cargo.log 2&>1

lipo -replace arm64 /Users/yushihang/Documents/HSBC/polygonID/polygonid-flutter-sdk/rust/target/aarch64-apple-ios-sim/release/libbabyjubjub.a  /Users/yushihang/Documents/HSBC/polygonID/babyjubjub_with_exception_handing/babyjubjub_with_exception_handing/babyjubjub.xcframework/ios-arm64_x86_64-simulator/libbabyjubjub.a  -output /Users/yushihang/Documents/HSBC/polygonID/babyjubjub_with_exception_handing/babyjubjub_with_exception_handing/babyjubjub.xcframework/ios-arm64_x86_64-simulator/libbabyjubjub.a.a

mv  /Users/yushihang/Documents/HSBC/polygonID/babyjubjub_with_exception_handing/babyjubjub_with_exception_handing/babyjubjub.xcframework/ios-arm64_x86_64-simulator/libbabyjubjub.a.a /Users/yushihang/Documents/HSBC/polygonID/babyjubjub_with_exception_handing/babyjubjub_with_exception_handing/babyjubjub.xcframework/ios-arm64_x86_64-simulator/libbabyjubjub.a



#for simulator x86_64


CC=/Users/yushihang/Library/Developer/Xcode/DerivedData/myCC-fucirlzgogxpujdvhmurnqxjptav/Build/Products/Release/myCC_x86_64 cargo build --target=x86_64-apple-ios --release -vv

lipo -replace x86_64 /Users/yushihang/Documents/HSBC/polygonID/polygonid-flutter-sdk/rust/target/x86_64-apple-ios/release/libbabyjubjub.a  /Users/yushihang/Documents/HSBC/polygonID/babyjubjub_with_exception_handing/babyjubjub_with_exception_handing/babyjubjub.xcframework/ios-arm64_x86_64-simulator/libbabyjubjub.a  -output /Users/yushihang/Documents/HSBC/polygonID/babyjubjub_with_exception_handing/babyjubjub_with_exception_handing/babyjubjub.xcframework/ios-arm64_x86_64-simulator/libbabyjubjub.a.a

mv  /Users/yushihang/Documents/HSBC/polygonID/babyjubjub_with_exception_handing/babyjubjub_with_exception_handing/babyjubjub.xcframework/ios-arm64_x86_64-simulator/libbabyjubjub.a.a /Users/yushihang/Documents/HSBC/polygonID/babyjubjub_with_exception_handing/babyjubjub_with_exception_handing/babyjubjub.xcframework/ios-arm64_x86_64-simulator/libbabyjubjub.a



cargo lipo --release