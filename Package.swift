// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UCSeatSelector",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "UCSeatSelector",
            targets: ["UCSeatSelector"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "UCSeatSelector",
            path: "Sources/UCSeatSelector",
            resources: [
                .process("Resources")
            ],
            publicHeadersPath: "include"
        ),
        .testTarget(
            name: "UCSeatSelectorTests",
            dependencies: ["UCSeatSelector"]
        ),
    ]
)