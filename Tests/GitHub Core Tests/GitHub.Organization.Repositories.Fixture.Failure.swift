@testable import GitHub

extension GitHub.Organization.Repositories {
    enum Fixture {
        enum Failure: Swift.Error, Equatable, Sendable {
            case unexpected
        }
    }
}
