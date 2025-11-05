//
//  GitHub.Traffic.Client.swift
//  swift-github-types
//
//  Created by Coen ten Thije Boonkkamp on 22/08/2025.
//

import GitHub_Types_Shared

extension GitHub.Traffic {
    @DependencyClient
    public struct Client: Sendable {
        // https://docs.github.com/en/rest/metrics/traffic#get-repository-views
        @DependencyEndpoint
        public var views:
            @Sendable (_ owner: String, _ repo: String, _ per: Per?) async throws -> Views.Response

        // https://docs.github.com/en/rest/metrics/traffic#get-repository-clones
        @DependencyEndpoint
        public var clones:
            @Sendable (_ owner: String, _ repo: String, _ per: Per?) async throws -> Clones.Response

        // https://docs.github.com/en/rest/metrics/traffic#get-top-referral-paths
        @DependencyEndpoint
        public var paths: @Sendable (_ owner: String, _ repo: String) async throws -> Paths.Response

        // https://docs.github.com/en/rest/metrics/traffic#get-top-referral-sources
        @DependencyEndpoint
        public var referrers:
            @Sendable (_ owner: String, _ repo: String) async throws -> Referrers.Response
    }
}
