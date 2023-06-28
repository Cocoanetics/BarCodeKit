// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
let package = Package(
    name: "BarCodeKitWrapper",
    platforms: [.iOS(.v11)],
    products: [
        .library(name: "BarCodeKitWrapper", type: .dynamic, targets: ["libBarCodeKit", "BarCodeKitWrapper"]),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "libBarCodeKit",
            path: "Source/libs/libBarCodeKit.xcframework"
        ),

        .target(
            name: "BarCodeKitWrapper",
            dependencies: ["libBarCodeKit"],
            path: "Source",
            exclude: ["libs"],
            linkerSettings: [
                .unsafeFlags(["-all_load"])
            ]
        ),

    ]
)
