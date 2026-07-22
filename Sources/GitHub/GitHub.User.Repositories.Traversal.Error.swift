extension GitHub.User.Repositories.Traversal {
    public enum Error<Failure: Swift.Error & Sendable>: Swift.Error, Sendable {
        case cancellation
        case client(Failure)
        case cycle
        case items
        case pages
    }
}

extension GitHub.User.Repositories.Traversal.Error: Equatable
where Failure: Equatable {}
