//
//  GitHub.Repositories.Client.swift
//  swift-github-types
//
//  Created by Coen ten Thije Boonkkamp on 22/08/2025.
//

import GitHub_Types_Shared

extension GitHub.Repositories {
  @DependencyClient
  public struct Client: Sendable {
    // https://docs.github.com/en/rest/repos/repos#list-repositories-for-the-authenticated-user
    @DependencyEndpoint
    public var list: @Sendable (_ request: List.Request?) async throws -> List.Response

    // https://docs.github.com/en/rest/repos/repos#get-a-repository
    @DependencyEndpoint
    public var get: @Sendable (_ owner: String, _ repo: String) async throws -> GitHub.Repository

    // https://docs.github.com/en/rest/repos/repos#create-a-repository-for-the-authenticated-user
    @DependencyEndpoint
    public var create: @Sendable (_ request: Create.Request) async throws -> GitHub.Repository

    // https://docs.github.com/en/rest/repos/repos#update-a-repository
    @DependencyEndpoint
    public var update:
      @Sendable (_ owner: String, _ repo: String, _ request: Update.Request) async throws ->
        GitHub.Repository

    // https://docs.github.com/en/rest/repos/repos#delete-a-repository
    @DependencyEndpoint
    public var delete: @Sendable (_ owner: String, _ repo: String) async throws -> Delete.Response
  }
}

extension GitHub.Repositories.Client {
  public func list() async throws -> GitHub.Repositories.List.Response {
    try await self.list(request: nil)
  }
}
