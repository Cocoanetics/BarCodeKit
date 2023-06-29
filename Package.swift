// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BarCodeKit",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v11),         //.v8 - .v13
        .macOS(.v10_13)   //.v10_10 - .v10_15
    ],
    products: [
        .library(
            name: "BarCodeKit",
            targets: ["BarCodeKit"])
    ],
    targets: [
        .target(
            name: "BarCodeKit",
            path: "Core",
            exclude: ["BarCodeKit-Framework-Info.plist", "BarCodeKit-Prefix.pch"],
            cSettings: [
                .headerSearchPath("include/BarCodeKit"),
                .define("BITCODE_GENERATION_MODE", to: "bitcode"),
                .define("ENABLE_BITCODE", to: "YES")
            ]
        )
    ]
)
