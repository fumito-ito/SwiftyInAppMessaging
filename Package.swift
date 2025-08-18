// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyInAppMessaging",
    platforms: [
        .iOS(.v15),
        .tvOS(.v15),
        .macOS(.v10_15),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SwiftyInAppMessaging",
            targets: ["SwiftyInAppMessagingTarget"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk", .upToNextMajor(from: .init(12, 0, 0))
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SwiftyInAppMessagingTarget",
            dependencies: [
                .targetItem(
                    name: "SwiftyInAppMessaging",
                    condition: .when(platforms: [.iOS, .tvOS])
                )
            ],
            path: "SwiftPM-PlatformExclude"
        ),
        .target(
            name: "SwiftyInAppMessaging",
            dependencies: [
                .product(name: "FirebaseInAppMessaging-Beta", package: "firebase-ios-sdk")
            ]),
        .testTarget(
            name: "SwiftyInAppMessagingTests",
            dependencies: ["SwiftyInAppMessaging"]
        )
    ],
    swiftLanguageVersions: [.v5]
)
