//
//  GitHub.Traffic.Response.swift
//  swift-github
//
//  Created for RepoTraffic.com
//

import Foundation
import GitHub_Traffic_Types
import GitHub_Types_Shared

extension GitHub.Traffic {
    /// Combined response from multiple traffic endpoints
    public struct Response: Sendable {
        public let views: Views.Response
        public let clones: Clones.Response
        public let paths: Paths.Response
        public let referrers: Referrers.Response

        public init(
            views: Views.Response,
            clones: Clones.Response,
            paths: Paths.Response,
            referrers: Referrers.Response
        ) {
            self.views = views
            self.clones = clones
            self.paths = paths
            self.referrers = referrers
        }
    }
}
