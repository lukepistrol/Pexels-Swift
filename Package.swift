// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "PexelsSwift",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        .library(
            name: "PexelsSwift",
            targets: ["PexelsSwift"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.2.0"),
    ],
    targets: [
        .target(
            name: "PexelsSwift"),
        .testTarget(
            name: "PexelsSwiftTests",
            dependencies: ["PexelsSwift"]),
    ]
)
