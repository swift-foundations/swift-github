import Testing

@testable import GitHub

extension GitHub.Repository.Stargazers {
    @Suite("GitHub.Repository.Stargazers.Client.Unit")
    struct Core {
        @Test("Traversal follows stargazer pages")
        func traversal() async throws {
            let second = try #require(GitHub.Page.Number(rawValue: 2))
            let owner = GitHub.Owner.Login(rawValue: "swiftlang")
            let repository = GitHub.Repository.Name(rawValue: "swift")
            let client = Client<GitHub.Repository.ProviderFailure> {
                (request: Request) async throws(GitHub.Repository.ProviderFailure)
                    -> Client<GitHub.Repository.ProviderFailure>.Page in
                switch request.page?.rawValue {
                case 1:
                    return .init(
                        response: .init(stargazers: []),
                        next: .init(
                            owner: owner,
                            repository: repository,
                            page: second,
                            size: .maximum
                        )
                    )
                case 2:
                    return .init(response: .init(stargazers: []), next: nil)
                default:
                    throw .unexpected
                }
            }

            let first = Request(
                owner: owner,
                repository: repository,
                page: .first,
                size: .maximum
            )
            let stargazers = try await client.all(
                first,
                limit: try self.limit(pages: 2, items: 1)
            )
            #expect(stargazers.isEmpty)
        }

        @Test("Traversal reports typed client, cycle, page, and cancellation failures")
        func failures() async throws {
            let request = GitHub.Repository.Stargazers.Request(
                owner: .init(rawValue: "swiftlang"),
                repository: .init(rawValue: "swift"),
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
                    GitHub.Repository.Stargazers.Traversal.Error<
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
                .init(response: .init(stargazers: []), next: request)
            }
            await #expect(
                throws:
                    GitHub.Repository.Stargazers.Traversal.Error<
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
                    GitHub.Repository.Stargazers.Traversal.Error<
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
                    GitHub.Repository.Stargazers.Traversal.Error<
                        GitHub.Repository.ProviderFailure
                    >.cancellation
            ) {
                try await task.value
            }
        }

        private func limit(
            pages: UInt,
            items: UInt
        ) throws -> GitHub.Repository.Stargazers.Traversal.Limit {
            let pages = try #require(
                GitHub.Repository.Stargazers.Traversal.Limit.Pages(rawValue: pages)
            )
            let items = try #require(
                GitHub.Repository.Stargazers.Traversal.Limit.Items(rawValue: items)
            )
            return .init(pages: pages, items: items)
        }
    }
}
