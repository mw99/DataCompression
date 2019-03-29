// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "DataCompression",
    platforms: [.macOS(.v10_11)],
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
