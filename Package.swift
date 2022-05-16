// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "PexelsSwift",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
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
