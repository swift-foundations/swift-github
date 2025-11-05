//
//  GitHub.OAuth.Client.swift
//  swift-github-types
//
//  Created by Coen ten Thije Boonkkamp on 10/09/2025.
//

import Dependencies
import DependenciesMacros
import GitHub_Types_Shared

extension GitHub.OAuth {
    @DependencyClient
    public struct Client: @unchecked Sendable {
        /// Exchange authorization code for access token
        @DependencyEndpoint
        public var exchangeCode:
            (
                _ clientId: String,
                _ clientSecret: String,
                _ code: String,
                _ redirectUri: String?
            ) async throws -> GitHub.OAuth.TokenResponse

        /// Get authenticated user information
        @DependencyEndpoint
        public var getAuthenticatedUser:
            (
                _ accessToken: String
            ) async throws -> GitHub.OAuth.User

        /// Get user's primary email addresses
        @DependencyEndpoint
        public var getUserEmails:
            (
                _ accessToken: String
            ) async throws -> [Email]

        public struct Email: Codable, Sendable {
            public let email: String
            public let primary: Bool
            public let verified: Bool
            public let visibility: String?
        }
    }
}
