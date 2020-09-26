import HTTPClient

public struct AuthenticationService {
    public struct AccessTokenParameters: Encodable {
        public let code: String
        public let clientID, clientSecret: String
        public let redirectURL, grantType: String
    }

    public struct RefreshTokenParameters: Encodable {
        public let refreshToken: String
        public let client_id, clientSecret: String
        public let redirectURL, grantType: String
    }

    public let accessToken: (AccessTokenParameters) -> APICallPublisher<Token>
    public let refreshToken: (RefreshTokenParameters) -> APICallPublisher<Token>

    static func from(apiClient: APIClient) -> AuthenticationService {
        .init(
            accessToken: { params in
                apiClient.post(
                    .init(
                        path: "oauth/token",
                        body: .encodableModel(value: params)
                    )
                ).decoded(as: Token.self)
            },
            refreshToken: { params in
                apiClient.post(
                    .init(
                        path: "oauth/token",
                        body: .encodableModel(value: params)
                    )
                ).decoded(as: Token.self)
            }
        )
    }
}
