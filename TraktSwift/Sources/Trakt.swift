import HTTPClient

// swiftlint:disable force_unwrapping
private let baseURL = URL(string: "https://\(apiHost)")!
// swiftlint:enable force_unwrapping

private let apiHost = "api.trakt.tv"
private let apiVersion = "2"

public struct Trakt {
  public struct AuthData {
    public let clientSecret: String
    public let redirectURL: URL

    public init(
      clientSecret: String,
      redirectURL: URL
    ) {
      self.clientSecret = clientSecret
      self.redirectURL = redirectURL
    }
  }

  public struct Credentials {
    public let clientId: String
    public let authData: AuthData?

    public init(
      clientId: String,
      authData: AuthData?
    ) {
      self.clientId = clientId
      self.authData = authData
    }
  }

  public let authenticator: Authenticator?
  public let movies: MoviesService

  public init(
    credentials: Credentials,
    client: HTTPClient,
    manager: TokenManager
  ) throws {
    let clientWithHeadersAndToken = client.appending(
      middlewares: .traktHeaders(clientID: credentials.clientId),
      .addToken(tokenProvider: { manager.tokenStatus().token })
    )

    let traktClient: HTTPClient

    if let authData = credentials.authData {
      let authenticator = try Authenticator(
        manager: manager,
        client: clientWithHeadersAndToken,
        clientID: credentials.clientId,
        authData: authData
      )

      self.authenticator = authenticator

      traktClient = clientWithHeadersAndToken.appending(
        middlewares: .refreshTokenMiddleware(
          tokenManager: manager,
          refreshToken: authenticator.refreshToken,
          clientID: credentials.clientId,
          authData: authData
        )
      )
    } else {
      self.authenticator = nil
      traktClient = clientWithHeadersAndToken
    }

    movies = .from(apiClient: try .init(
      client: traktClient,
      baseURL: baseURL
    ))
  }
}

private extension HTTPMiddleware {
  static func traktHeaders(clientID: String) -> Self {
    .init { request, responder -> HTTPCallPublisher in
      var request = request

      request.headers["trakt-api-key"] = clientID
      request.headers["trakt-api-version"] = apiVersion
      request.headers["Content-Type"] = "application/json"

      return responder.respondTo(request)
    }
  }

  static func refreshTokenMiddleware(
    tokenManager: TokenManager,
    refreshToken: RefreshTokenService,
    clientID: String,
    authData: Trakt.AuthData
  ) -> Self {
    .init { request, responder -> HTTPCallPublisher in
      guard case let .refresh(token) = tokenManager.tokenStatus() else {
        return responder.respondTo(request)
      }

      var request = request

      return refreshToken.refresh(
        .init(
          refreshToken: token.refreshToken,
          client_id: clientID,
          clientSecret: authData.clientSecret,
          redirectURL: authData.redirectURL.absoluteString,
          grantType: "refresh_token"
        )
      )
      .saveToken(tokenManager)
      .flatMap { token in
        responder.respondTo(request.authorize(token: token))
      }.eraseToAnyPublisher()
    }
  }

  static func addToken(tokenProvider: @escaping () -> Token?) -> Self {
    .init { request, responder -> HTTPCallPublisher in
      guard let token = tokenProvider() else {
        return responder.respondTo(request)
      }

      var request = request
      return responder.respondTo(request.authorize(token: token))
    }
  }
}

private extension HTTPRequest {
  mutating func authorize(token: Token) -> HTTPRequest {
    self.headers["Authorization"] = "Bearer " + token.accessToken
    return self
  }
}
