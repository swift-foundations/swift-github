extension GitHub.Organization.Repositories.Traversal {
    public enum Error<Failure: Swift.Error>: Swift.Error, Sendable {
        case cancellation
        case client(Failure)
        case cycle
        case duplicate(GitHub.Repository.ID)
        case items
        case pages
    }
}

extension GitHub.Organization.Repositories.Traversal.Error: Equatable
where Failure: Equatable {}
