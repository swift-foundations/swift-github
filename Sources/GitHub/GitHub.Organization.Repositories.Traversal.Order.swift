extension GitHub.Organization.Repositories.Traversal {
    public struct Order: Sendable {
        public static let server = Self { $0 }

        private let body: @Sendable ([GitHub.Repository.Summary]) -> [GitHub.Repository.Summary]

        public init(
            _ body: @escaping @Sendable ([GitHub.Repository.Summary]) -> [GitHub.Repository.Summary]
        ) {
            self.body = body
        }

        public func callAsFunction(
            _ repositories: [GitHub.Repository.Summary]
        ) -> [GitHub.Repository.Summary] {
            self.body(repositories)
        }
    }
}
