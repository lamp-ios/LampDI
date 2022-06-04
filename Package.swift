// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LampDI",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "DITypes", targets: ["DITypes"]),
        .executable(name: "DynamicDI", targets: ["DynamicDI"]),
        .executable(name: "ServiceLocator", targets: ["ServiceLocator"]),
        .executable(name: "StaticDI", targets: ["StaticDI"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "DITypes", dependencies: [
        ]),
        .executableTarget(name: "StaticDI", dependencies: [
        ]),
        .executableTarget(name: "DynamicDI", dependencies: [
        ]),
        .executableTarget(name: "ServiceLocator", dependencies: [
        ]),
    ]
)
