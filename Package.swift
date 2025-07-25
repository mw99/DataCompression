// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "DataCompression",
    platforms: [.macOS(.v10_13), .iOS(.v12), .tvOS(.v12), .watchOS(.v4), .visionOS(.v1)],
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
