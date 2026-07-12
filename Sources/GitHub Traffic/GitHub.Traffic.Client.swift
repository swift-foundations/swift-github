//
//  GitHub.Traffic.Client.swift
//  swift-github-types
//
//  Created by Coen ten Thije Boonkkamp on 22/08/2025.
//

import GitHub_Types_Shared

extension GitHub.Traffic {
    @Witness
    public struct Client: Sendable {
        // https://docs.github.com/en/rest/metrics/traffic#get-repository-views
        public var views:
            @Sendable (_ owner: String, _ repo: String, _ per: Per?) async throws(any Swift.Error) -> Views.Response

        // https://docs.github.com/en/rest/metrics/traffic#get-repository-clones
        public var clones:
            @Sendable (_ owner: String, _ repo: String, _ per: Per?) async throws(any Swift.Error) -> Clones.Response

        // https://docs.github.com/en/rest/metrics/traffic#get-top-referral-paths
        public var paths: @Sendable (_ owner: String, _ repo: String) async throws(any Swift.Error) -> Paths.Response

        // https://docs.github.com/en/rest/metrics/traffic#get-top-referral-sources
        public var referrers:
            @Sendable (_ owner: String, _ repo: String) async throws(any Swift.Error) -> Referrers.Response
    }
}
