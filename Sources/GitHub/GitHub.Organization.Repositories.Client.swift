extension GitHub.Organization.Repositories {
    public struct Client<Failure: Swift.Error & Sendable>: Sendable {
        public var page: @Sendable (Request) async throws(Failure) -> Page

        public init(
            page: @escaping @Sendable (Request) async throws(Failure) -> Page
        ) {
            self.page = page
        }
    }
}
