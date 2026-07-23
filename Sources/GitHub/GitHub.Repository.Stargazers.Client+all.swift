extension GitHub.Repository.Stargazers.Client {
    public func all(
        _ request: GitHub.Repository.Stargazers.Request,
        limit: GitHub.Repository.Stargazers.Traversal.Limit
    ) async throws(GitHub.Repository.Stargazers.Traversal.Error<Failure>)
        -> [GitHub.Repository.Stargazers.Stargazer]
    {
        var stargazers: [GitHub.Repository.Stargazers.Stargazer] = []
        var requests: Set<GitHub.Repository.Stargazers.Request> = []
        var current: GitHub.Repository.Stargazers.Request? = request
        var pages: UInt = 0

        while let request = current {
            guard !Task<Never, Never>.isCancelled else { throw .cancellation }
            // swift-linter:disable:next raw value access
            // REASON: same-package traversal-limit boundary — the page counter
            //   is compared against the limit newtype's own raw magnitude.
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
            stargazers.append(contentsOf: page.response.stargazers)

            // swift-linter:disable:next raw value access
            // REASON: same-package traversal-limit boundary — the accumulated
            //   item count is compared against the limit newtype's raw magnitude.
            guard UInt(stargazers.count) <= limit.items.rawValue else {
                throw .items
            }
            current = page.next
        }

        return stargazers
    }
}
