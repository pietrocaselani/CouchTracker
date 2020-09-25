import HTTPClient

struct RefreshTokenService {
  let refresh: () -> APICallPublisher<TVDBToken>

  static func from(apiClient: APIClient) -> RefreshTokenService {
    .init(
      refresh: {
        apiClient.get(.init(path: "refresh_token"))
          .decoded(as: TVDBToken.self)
      }
    )
  }
}

struct LoginService {
  let login: (LoginParams) -> APICallPublisher<TVDBToken>

  static func from(apiClient: APIClient) -> LoginService {
    .init(
      login: { params in
        apiClient.post(
          .init(
            path: "login",
            body: .encodableModel(value: params)
          )
        ).decoded(as: TVDBToken.self)
      }
    )
  }
}

struct LoginParams: Equatable, Encodable {
  let apikey: String
}
