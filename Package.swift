// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RemindersApp",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "RemindersApp",
            targets: ["RemindersApp"]),
    ],
    targets: [
        .target(
            name: "RemindersApp",
            dependencies: [],
            path: "Sources/RemindersApp",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "RemindersAppTests",
            dependencies: ["RemindersApp"],
            path: "Tests/RemindersAppTests"
        ),
    ]
)
