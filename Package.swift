// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Pexels-Swift",
    platforms: [
        .iOS(.v13),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "Pexels-Swift",
            targets: ["Pexels-Swift"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Pexels-Swift",
            dependencies: []),
        .testTarget(
            name: "Pexels-SwiftTests",
            dependencies: ["Pexels-Swift"]),
    ]
)
