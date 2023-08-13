// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NowPlaying-macOS",
    platforms: [.macOS(.v10_15)],
    products: [
        .executable(name: "nowplaying-plugin", targets: ["nowplaying"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
       //.package(name: "StreamDeck", url: "https://github.com/emorydunn/StreamDeckPlugin.git", .branch("main")),
        .package(name: "StreamDeck", path: "StreamDeckPlugin"), // For local development
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "nowplaying",
            dependencies: [
                .product(name: "StreamDeck", package: "StreamDeck"),
            ])
    ]
)
