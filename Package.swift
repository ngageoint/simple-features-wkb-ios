// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "SimpleFeaturesWKB",
    platforms: [.macOS(.v11), .iOS(.v13)],
    products: [
        .library(
            name: "SimpleFeaturesWKB",
            targets: ["SimpleFeaturesWKB"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ngageoint/simple-features-ios", from: "5.0.0"),
    ],
    targets: [
        .target(
            name: "SimpleFeaturesWKB",
            dependencies: [
                .product(name: "SimpleFeatures", package: "simple-features-ios")
            ],
            path: "sf-wkb-ios",
            publicHeadersPath: "include"
        ),
        .testTarget(
            name: "SimpleFeaturesWKBTests",
            dependencies: [
                "SimpleFeaturesWKB",
                "TestUtils"
            ],
            path: "sf-wkb-iosTests"
        ),
        .testTarget(
            name: "SimpleFeaturesWKBTestsSwift",
            dependencies: [
                "SimpleFeaturesWKB",
                "TestUtils"
            ],
            path: "sf-wkb-iosTests-swift"
        ),
        .target(
            name: "TestUtils", // Shared test code
            dependencies: ["SimpleFeaturesWKB"],
            path: "TestUtils",
            publicHeadersPath: ""
        ),
    ]
)
