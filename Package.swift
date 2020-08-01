// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "revamp",
    platforms: [
        .macOS(.v10_11)
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.2.1"),
        .package(url: "https://github.com/JohnSundell/Files", from: "4.0.0"),
        .package(url: "https://github.com/weichsel/ZIPFoundation/", .upToNextMajor(from: "0.9.0")),
    ],
    targets: [
        .target(
            name: "revamp",
            dependencies: ["ArgumentParser", "Library"]),
        .target(
            name: "Library",
            dependencies: [ "Files",
                            "ZIPFoundation"]),
        .testTarget(
            name: "revampTests",
            dependencies: [.product(name: "Files", package: "Files"),
                "Library"]),
    ]
)
