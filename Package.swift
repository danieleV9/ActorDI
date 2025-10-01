// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ActorDI",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "ActorDI",
            targets: ["ActorDI"]
        ),
    ],
    targets: [
        .target(
            name: "ActorDI",
            swiftSettings: [
                .defaultIsolation(MainActor.self)
            ]
        ),
        .testTarget(
            name: "ActorDITests",
            dependencies: ["ActorDI"]
        ),
    ]
)
