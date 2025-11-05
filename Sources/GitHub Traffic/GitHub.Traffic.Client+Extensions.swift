//
//  GitHub.Traffic.Client+Extensions.swift
//  swift-github
//
//  Created for RepoTraffic.com
//

import Foundation
import GitHub_Traffic_Live
import GitHub_Traffic_Types

extension GitHub.Traffic.Client {
    /// Fetch all traffic data (views, clones, paths, referrers) for a repository
    public func fetchAll(
        owner: String,
        repo: String,
        per: GitHub.Traffic.Per? = .day
    ) async throws -> GitHub.Traffic.Response {
        async let views = self.views(owner: owner, repo: repo, per: per)
        async let clones = self.clones(owner: owner, repo: repo, per: per)
        async let paths = self.paths(owner: owner, repo: repo)
        async let referrers = self.referrers(owner: owner, repo: repo)

        return try await GitHub.Traffic.Response(
            views: views,
            clones: clones,
            paths: paths,
            referrers: referrers
        )
    }
}
