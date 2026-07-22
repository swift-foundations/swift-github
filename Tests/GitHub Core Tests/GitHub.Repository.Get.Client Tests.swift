import Testing

@testable import GitHub

extension GitHub.Repository.Get {
    @Suite("GitHub.Repository.Get.Client.Unit")
    struct Core {
        @Test("Repository lookup preserves its typed failure")
        func failure() async {
            let client = Client<GitHub.Repository.ProviderFailure> {
                (request: Request) async throws(GitHub.Repository.ProviderFailure) -> Response in
                #expect(request.owner.rawValue == "swiftlang")
                #expect(request.repository.rawValue == "swift")
                throw .expected
            }

            let request = Request(
                owner: .init(rawValue: "swiftlang"),
                repository: .init(rawValue: "swift")
            )
            await #expect(throws: GitHub.Repository.ProviderFailure.expected) {
                try await client.get(request)
            }
        }
    }
}
