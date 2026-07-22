import Testing

@testable import GitHub

extension GitHub.User.Repositories {
    @Suite("GitHub.User.Repositories.Client.Unit")
    struct Core {
        @Test("Traversal follows authenticated-user repository pages")
        func traversal() async throws {
            let second = try #require(GitHub.Page.Number(rawValue: 2))
            let client = Client<GitHub.Repository.ProviderFailure> {
                (request: Request) async throws(GitHub.Repository.ProviderFailure)
                    -> Client<GitHub.Repository.ProviderFailure>.Page in
                switch request.page?.rawValue {
                case 1:
                    return .init(
                        response: .init(repositories: []),
                        next: .init(page: second, size: .maximum)
                    )
                case 2:
                    return .init(response: .init(repositories: []), next: nil)
                default:
                    throw .unexpected
                }
            }

            let first = Request(page: .first, size: .maximum)
            let repositories = try await client.all(
                first,
                limit: try self.limit(pages: 2, items: 1)
            )
            #expect(repositories.isEmpty)
        }

        @Test("Traversal reports typed client, cycle, page, and cancellation failures")
        func failures() async throws {
            let request = GitHub.User.Repositories.Request(
                page: .first,
                size: .maximum
            )
            let failing = Client<GitHub.Repository.ProviderFailure> {
                (_: Request) async throws(GitHub.Repository.ProviderFailure)
                    -> Client<GitHub.Repository.ProviderFailure>.Page in
                throw .expected
            }
            await #expect(
                throws:
                    GitHub.User.Repositories.Traversal.Error<
                        GitHub.Repository.ProviderFailure
                    >.client(.expected)
            ) {
                try await failing.all(
                    request,
                    limit: try self.limit(pages: 1, items: 1)
                )
            }

            let cycling = Client<GitHub.Repository.ProviderFailure> {
                (_: Request) async throws(GitHub.Repository.ProviderFailure)
                    -> Client<GitHub.Repository.ProviderFailure>.Page in
                .init(response: .init(repositories: []), next: request)
            }
            await #expect(
                throws:
                    GitHub.User.Repositories.Traversal.Error<
                        GitHub.Repository.ProviderFailure
                    >.cycle
            ) {
                try await cycling.all(
                    request,
                    limit: try self.limit(pages: 2, items: 1)
                )
            }
            await #expect(
                throws:
                    GitHub.User.Repositories.Traversal.Error<
                        GitHub.Repository.ProviderFailure
                    >.pages
            ) {
                try await cycling.all(
                    request,
                    limit: try self.limit(pages: 1, items: 1)
                )
            }

            let task = Task {
                try await cycling.all(
                    request,
                    limit: try self.limit(pages: 2, items: 1)
                )
            }
            task.cancel()
            await #expect(
                throws:
                    GitHub.User.Repositories.Traversal.Error<
                        GitHub.Repository.ProviderFailure
                    >.cancellation
            ) {
                try await task.value
            }
        }

        private func limit(
            pages: UInt,
            items: UInt
        ) throws -> GitHub.User.Repositories.Traversal.Limit {
            let pages = try #require(
                GitHub.User.Repositories.Traversal.Limit.Pages(rawValue: pages)
            )
            let items = try #require(
                GitHub.User.Repositories.Traversal.Limit.Items(rawValue: items)
            )
            return .init(pages: pages, items: items)
        }
    }
}
