// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PexelsSwift",
    platforms: [
        .iOS(.v13),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "PexelsSwift",
            targets: ["PexelsSwift"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "PexelsSwift",
            dependencies: []),
        .testTarget(
            name: "PexelsSwiftTests",
            dependencies: ["PexelsSwift"]),
    ]
)
