// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "DataCompression",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
        .tvOS(.v15),
        .watchOS(.v9),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "DataCompression",
            targets: ["DataCompression"]),
    ],
    targets: [
        .target(
            name: "DataCompression",
            dependencies: []),
        .testTarget(
            name: "DataCompressionTests",
            dependencies: ["DataCompression"]),
    ]
)
