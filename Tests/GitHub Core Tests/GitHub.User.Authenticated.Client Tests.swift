import Testing

@testable import GitHub

extension GitHub.User.Authenticated {
    @Suite("GitHub.User.Authenticated.Client.Unit")
    struct Core {
        @Test("Authenticated-user lookup preserves its typed failure")
        func get() async {
            let client = Get.Client<GitHub.OAuth.Fixture.Failure> {
                (request: Get.Request) async throws(GitHub.OAuth.Fixture.Failure) in
                #expect(request.accessToken == "access-token")
                throw .expected
            }

            await #expect(throws: GitHub.OAuth.Fixture.Failure.expected) {
                try await client.get(.init(accessToken: "access-token"))
            }
        }

        @Test("Authenticated-user email listing preserves its typed failure")
        func emails() async {
            let client = Emails.List.Client<GitHub.OAuth.Fixture.Failure> {
                (request: Emails.List.Request) async throws(GitHub.OAuth.Fixture.Failure) in
                #expect(request.accessToken == "access-token")
                throw .expected
            }

            await #expect(throws: GitHub.OAuth.Fixture.Failure.expected) {
                try await client.list(.init(accessToken: "access-token"))
            }
        }
    }
}
