# swift-github

[![CI](https://github.com/swift-foundations/swift-github/actions/workflows/ci.yml/badge.svg)](https://github.com/swift-foundations/swift-github/actions/workflows/ci.yml)

Typed, transport-independent GitHub clients for Swift.

## Ecosystem

This package belongs to the Swift Institute Foundations layer. It turns the
contracts from
[swift-github-standard](https://github.com/swift-standards/swift-github-standard)
into injectable async capabilities without choosing HTTP, authentication,
persistence, or application policy.

## Products

| Product | Module | Purpose |
| --- | --- | --- |
| GitHub | `GitHub` | Typed one-call clients and bounded paginated traversals |

## Installation

```swift
dependencies: [
    .package(
        url: "https://github.com/swift-foundations/swift-github.git",
        branch: "main"
    )
]
```

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "GitHub", package: "swift-github")
    ]
)
```

## Usage

Clients are generic over their typed failure:

```swift
import GitHub

let traffic = GitHub.Repository.Traffic.Client<MyError>(
    views: fetchViews,
    clones: fetchClones,
    paths: fetchPaths,
    referrers: fetchReferrers
)

let response = try await traffic.views(
    .init(
        owner: .init(rawValue: "swiftlang"),
        repository: .init(rawValue: "swift"),
        interval: .day
    )
)
```

Repository lookup and authenticated-user repository listing use
`GitHub.Repository.Get.Client` and `GitHub.User.Repositories.Client`.
Timestamped stars use `GitHub.Repository.Stargazers.Client`.

Paginated repository and stargazer traversal requires explicit page and item
limits. Traversal observes task cancellation and fails on client errors, page
cycles, or exceeded bounds rather than returning an incomplete result.

## Architecture

This package defines no live or configured-live client. The HTTP binding lives
in
[swift-github-http](https://github.com/swift-foundations/swift-github-http).
Aggregating views, clones, paths, and referrers into an application snapshot is
application policy and is intentionally outside this package.

No deprecated `GitHub Traffic`, `GitHub Stargazers`, or
`GitHub Repositories` compatibility products are provided.

## Development

```bash
/Users/coen/Developer/swift-institute/Scripts/swift-build package build
/Users/coen/Developer/swift-institute/Scripts/swift-build package test
```

## License

This package is available under the MIT license.
