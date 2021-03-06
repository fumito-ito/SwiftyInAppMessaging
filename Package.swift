// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyInAppMessaging",
    platforms: [.iOS("11.0")],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SwiftyInAppMessaging",
            targets: ["SwiftyInAppMessaging"])
    ],
    dependencies: [
        .package(name: "Firebase",
                 url: "https://github.com/firebase/firebase-ios-sdk.git",
                 .exact("7.3.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SwiftyInAppMessaging",
            dependencies: [
                .product(name: "FirebaseInAppMessaging-Beta", package: "Firebase")
            ]),
        .testTarget(
            name: "SwiftyInAppMessagingTests",
            dependencies: ["SwiftyInAppMessaging"])
    ],
    swiftLanguageVersions: [.v5]
)
