//
//  GitHub.Stargazers.Client.swift
//  swift-github-types
//
//  Created by Coen ten Thije Boonkkamp on 30/08/2025.
//

import Dependencies
import DependenciesMacros
import GitHub_Types_Shared

extension GitHub.Stargazers {
    @DependencyClient
    public struct Client: Sendable {
        // https://docs.github.com/en/rest/activity/starring#list-stargazers
        @DependencyEndpoint
        public var list:
            @Sendable (_ owner: String, _ repo: String, _ request: List.Request?) async throws ->
                List.Response
    }
}

extension GitHub.Stargazers.Client {
    public func list(owner: String, repo: String) async throws -> GitHub.Stargazers.List.Response {
        try await self.list(owner, repo, nil)
    }

    public func listAll(
        owner: String,
        repo: String
    ) async throws -> [GitHub.Stargazers.List.Stargazer] {
        var allStargazers: [GitHub.Stargazers.List.Stargazer] = []
        var page = 1
        let perPage = 100  // GitHub's max per page

        while true {
            let request = GitHub.Stargazers.List.Request(perPage: perPage, page: page)
            let response = try await self.list(owner, repo, request)

            if response.isEmpty {
                break
            }

            allStargazers.append(contentsOf: response)

            // If we got less than perPage, we've reached the end
            if response.count < perPage {
                break
            }

            page += 1
        }

        return allStargazers
    }
}
