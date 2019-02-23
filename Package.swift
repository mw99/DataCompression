// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "DataCompression",
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
