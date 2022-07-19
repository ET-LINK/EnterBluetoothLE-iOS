// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EnterBluetoothLE-iOS",
    platforms: [
            .iOS(.v13)
        ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "EnterBluetoothLE-iOS",
            targets: ["EnterBluetoothLE-iOS"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/mxcl/PromiseKit.git", from: "6.15.3"),
        .package(url: "https://github.com/ET-LINK/CombineCoreBluetooth", branch: "lk"),
        // .package(url: "https://github.com/Entertech/IOS-Pods-DFU-Library.git", from: "4.11.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "EnterBluetoothLE-iOS",
            dependencies: [
                "CombineCoreBluetooth",
                "PromiseKit",
            ]),
        .testTarget(
            name: "EnterCombineBluetoothTests",
            dependencies: ["EnterBluetoothLE-iOS"]),
    ]
)
