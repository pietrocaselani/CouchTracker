import HTTPClient

public struct AccessTokenService {
  public struct Parameters: Encodable {
      public let code: String
      public let clientID, clientSecret: String
      public let redirectURL, grantType: String
  }

  let get: (Parameters) -> APICallPublisher<Token>

  static func from(apiClient: APIClient) -> Self {
    .init(get: { params in
      apiClient.post(
          .init(
              path: "oauth/token",
              body: .encodableModel(value: params)
          )
      ).decoded(as: Token.self)
    })
  }
}

public struct RefreshTokenService {
  public struct Parameters: Encodable {
    public let refreshToken: String
    public let client_id, clientSecret: String
    public let redirectURL, grantType: String
  }

  let refresh: (Parameters) -> APICallPublisher<Token>

  static func from(apiClient: APIClient) -> Self {
    .init(refresh: { params in
      apiClient.post(
          .init(
              path: "oauth/token",
              body: .encodableModel(value: params)
          )
      ).decoded(as: Token.self)
    })
  }
}
