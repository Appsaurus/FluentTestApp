// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FluentTestApp",
    products: [
        .library(
            name: "FluentTestApp",
            targets: ["FluentTestApp"]),
    ],
    dependencies: [
		.package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
		.package(url: "https://github.com/vapor/fluent.git", .upToNextMajor(from:"3.0.0-rc.3.0.1")),
		.package(url: "https://github.com/vapor/fluent-sqlite.git", .upToNextMajor(from:"3.0.0-rc.3.0.1")),
		.package(url: "https://github.com/Appsaurus/FluentTestModels", .upToNextMajor(from: "0.1.0")),
		.package(url: "https://github.com/Appsaurus/FluentTestUtils", .upToNextMajor(from: "0.1.0")),
		.package(url: "https://github.com/Appsaurus/FluentSeeder", .upToNextMajor(from: "0.1.0")),
    ],
    targets: [
        .target(
            name: "FluentTestApp",
            dependencies: ["Vapor", "Fluent", "FluentSQLite", "FluentTestModels", "FluentTestUtils", "FluentSeeder"]),
        .testTarget(
            name: "FluentTestAppTests",
            dependencies: ["FluentTestApp"]),
    ]
)
