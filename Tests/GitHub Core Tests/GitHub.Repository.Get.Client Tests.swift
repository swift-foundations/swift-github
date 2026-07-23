import Testing

@testable import GitHub

extension GitHub.Repository.Get {
    @Suite("GitHub.Repository.Get.Client.Unit")
    struct Core {
        @Test("Repository lookup preserves its typed failure")
        func failure() async {
            let client = Client<GitHub.Repository.Fixture.Failure> {
                (request: Request) async throws(GitHub.Repository.Fixture.Failure) -> Response in
                #expect(request.owner == .init(rawValue: "swiftlang"))
                #expect(request.repository == .init(rawValue: "swift"))
                throw .expected
            }

            let request = Request(
                owner: .init(rawValue: "swiftlang"),
                repository: .init(rawValue: "swift")
            )
            await #expect(throws: GitHub.Repository.Fixture.Failure.expected) {
                try await client.get(request)
            }
        }
    }
}
