extension GitHub.User.Repositories.Client {
    public func all(
        _ request: GitHub.User.Repositories.Request,
        limit: GitHub.User.Repositories.Traversal.Limit
    ) async throws(GitHub.User.Repositories.Traversal.Error<Failure>)
        -> [GitHub.Repository.Metadata]
    {
        var repositories: [GitHub.Repository.Metadata] = []
        var requests: Set<GitHub.User.Repositories.Request> = []
        var current: GitHub.User.Repositories.Request? = request
        var pages: UInt = 0

        while let request = current {
            guard !Task<Never, Never>.isCancelled else { throw .cancellation }
            guard pages < limit.pages.rawValue else { throw .pages }
            guard requests.insert(request).inserted else { throw .cycle }

            let page: Page
            do throws(Failure) {
                page = try await self.page(request)
            } catch {
                throw .client(error)
            }

            guard !Task<Never, Never>.isCancelled else { throw .cancellation }
            pages += 1
            repositories.append(contentsOf: page.response.repositories)

            guard UInt(repositories.count) <= limit.items.rawValue else {
                throw .items
            }
            current = page.next
        }

        return repositories
    }
}
