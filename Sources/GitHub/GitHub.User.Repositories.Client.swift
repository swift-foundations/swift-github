//
//  GitHub.Repositories.Client.swift
//  swift-github-types
//
//  Created by Coen ten Thije Boonkkamp on 22/08/2025.
//

import GitHub_Types_Shared

extension GitHub.Repositories {
    @Witness
    public struct Client: Sendable {
        // https://docs.github.com/en/rest/repos/repos#list-repositories-for-the-authenticated-user
        public var list: @Sendable (_ request: List.Request?) async throws(any Swift.Error) -> List.Response

        // https://docs.github.com/en/rest/repos/repos#get-a-repository
        public var get:
            @Sendable (_ owner: String, _ repo: String) async throws(any Swift.Error) -> GitHub.Repository

        // https://docs.github.com/en/rest/repos/repos#create-a-repository-for-the-authenticated-user
        public var create: @Sendable (_ request: Create.Request) async throws(any Swift.Error) -> GitHub.Repository

        // https://docs.github.com/en/rest/repos/repos#update-a-repository
        public var update:
            @Sendable (_ owner: String, _ repo: String, _ request: Update.Request) async throws(any Swift.Error) ->
                GitHub.Repository

        // https://docs.github.com/en/rest/repos/repos#delete-a-repository
        public var delete:
            @Sendable (_ owner: String, _ repo: String) async throws(any Swift.Error) -> Delete.Response
    }
}

extension GitHub.Repositories.Client {
    public func list() async throws -> GitHub.Repositories.List.Response {
        try await self.list(request: nil)
    }
}
