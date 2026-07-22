// swift-tools-version: 6.3.3

import PackageDescription

let package = Package(
    name: "swift-github",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(
            name: "GitHub",
            targets: ["GitHub"]
        )
    ],
    dependencies: [
        .package(path: "../../swift-standards/swift-github-types")
    ],
    targets: [
        .target(
            name: "GitHub",
            dependencies: [
                .product(
                    name: "GitHub Standard",
                    package: "swift-github-types"
                )
            ]
        ),
        .testTarget(
            name: "GitHub Core Tests",
            dependencies: ["GitHub"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
