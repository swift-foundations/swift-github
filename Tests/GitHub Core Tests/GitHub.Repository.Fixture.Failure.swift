@testable import GitHub

extension GitHub.Repository.Fixture {
    enum Failure: Swift.Error, Equatable, Sendable {
        case expected
        case unexpected
    }
}
