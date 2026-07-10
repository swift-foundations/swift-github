// swift-tools-version: 6.3.3

import Foundation
import PackageDescription

extension String {
    static let github: Self = "GitHub"
    static let githubTraffic: Self = "GitHub Traffic"
    static let githubRepositories: Self = "GitHub Repositories"
    static let githubShared: Self = "GitHub Shared"
}

extension Target.Dependency {
    static var github: Self { .target(name: .github) }
    static var githubTraffic: Self { .target(name: .githubTraffic) }
    static var githubRepositories: Self { .target(name: .githubRepositories) }
    static var githubShared: Self { .target(name: .githubShared) }
}

extension Target.Dependency {
    static var githubLive: Self { .product(name: "GitHub Live", package: "swift-github-live") }
    static var githubTrafficLive: Self { .product(name: "GitHub Traffic Live", package: "swift-github-live") }
    static var githubRepositoriesLive: Self { .product(name: "GitHub Repositories Live", package: "swift-github-live") }
    static var githubLiveShared: Self { .product(name: "GitHub Live Shared", package: "swift-github-live") }
}

let package = Package(
    name: "swift-github",
    platforms: [
        .macOS(.v26),
        .iOS(.v26)
    ],
    products: [
        .library(name: .github, targets: [.github]),
        .library(name: .githubTraffic, targets: [.githubTraffic]),
        .library(name: .githubRepositories, targets: [.githubRepositories]),
        .library(name: .githubShared, targets: [.githubShared])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-foundations/swift-github-live.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-dependencies.git", branch: "main"),
    ],
    targets: [
        .target(
            name: .githubShared,
            dependencies: [
                .githubLiveShared
            ]
        ),
        .target(
            name: .github,
            dependencies: [
                .githubShared,
                .githubLive,
                .githubTraffic,
                .githubRepositories,
            ]
        ),
        .target(
            name: .githubTraffic,
            dependencies: [
                .githubShared,
                .githubTrafficLive
            ]
        ),
        .target(
            name: .githubRepositories,
            dependencies: [
                .githubShared,
                .githubRepositoriesLive
            ]
        ),
        .testTarget(
            name: .github + " Tests",
            dependencies: [
                .github
            ]
        ),
        .testTarget(
            name: "GitHub Traffic Tests",
            dependencies: [.githubTraffic]
        ),
        .testTarget(
            name: "GitHub Repositories Tests",
            dependencies: [.githubRepositories]
        )
    ],
    swiftLanguageModes: [.v6]
)
