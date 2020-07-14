// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "revamp",
    platforms: [
        .macOS(.v10_11)
    ],
    products: [
        .executable(name: "revamp", targets: ["revamp"]),
        .library(name: "Library", targets: ["Library"]),
        // .library(name: "Command", targets: ["Command"]),
        // .library(name: "Services", targets: ["Services"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.1.0"),
        .package(url: "https://github.com/JohnSundell/Files", from: "4.0.0"),
        .package(url: "https://github.com/weichsel/ZIPFoundation/", .upToNextMajor(from: "0.9.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "revamp",
            dependencies: [.product(name: "ArgumentParser", package: "swift-argument-parser"),
                           .product(name: "Files", package: "Files"),
                           "Library", "ZIPFoundation"]),
        .target(
            name: "Library",
            dependencies: [.product(name: "Files", package: "Files"),
                            "ZIPFoundation"]),
        // .target(
        //     name: "Services",
        //     dependencies: []),        
        // .target(
        //     name: "Command",
        //     dependencies: [.product(name: "Files", package: "Files"),
        //                     "ZIPFoundation"]),
        .testTarget(
            name: "revampTests",
            dependencies: [.product(name: "Files", package: "Files"),
                "Library"]),
    ]
)
