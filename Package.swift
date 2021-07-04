// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "tdLBSwiftApi",
    platforms: [
        .macOS(.v11)
//        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "tdLBSwiftApi",
            targets: ["tdLB", "tdLBGeometry"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        //        .package(url: "https://github.com/apple/swift-numerics", from: "0.0.5"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "tdLB",
            dependencies: []),
        .target(
            name: "tdLBGeometry",
            dependencies: ["tdLB"],
            resources: [
                .process("dragon.ply")
            ]),
        .testTarget(
            name: "tdLBTests",
            dependencies: ["tdLB"]),
        .testTarget(
            name: "tdLBGeometryTests",
            dependencies: ["tdLBGeometry"])
    ]
)
