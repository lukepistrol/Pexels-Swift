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
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
        .package(url: "https://github.com/lukepistrol/SwiftLintPlugin.git", from: "0.0.1"),
    ],
    targets: [
        .target(
            name: "PexelsSwift",
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
            ])
        ,
        .testTarget(
            name: "PexelsSwiftTests",
            dependencies: ["PexelsSwift"]),
    ]
)
