@testable import GitHub

extension GitHub.Repository {
    enum ProviderFailure: Swift.Error, Equatable, Sendable {
        case expected
        case unexpected
    }
}
