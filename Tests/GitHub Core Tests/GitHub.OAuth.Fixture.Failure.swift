@testable import GitHub

extension GitHub.OAuth.Fixture {
    enum Failure: Swift.Error, Equatable, Sendable {
        case expected
    }
}
