import HTTPClient

// swiftlint:disable force_unwrapping
private let baseURL = URL(string: "https://\(apiHost)")!
private let bannersImageURL = URL(string: "https://www.thetvdb.com/banners/")!
private let smallBannersImageURL = URL(string: "https://www.thetvdb.com/banners/_cache/")!
// swiftlint:enable force_unwrapping

private let apiHost = "api.thetvdb.com"
private let apiVersion = "2.1.2"

public struct TVDB {
  private let login: LoginService
  private let refreshToken: RefreshTokenService

  public let episodes: EpisodesService

  public init(
    apiKey: String,
    client: HTTPClient,
    manager: TokenManager
  ) throws {
    let loginClient = client.appending(middlewares: .tvdbHeaders)

    self.login = .from(
      apiClient: try APIClient(
        client: loginClient,
        baseURL: baseURL
      )
    )

    let refreshClient = loginClient.appending(
      middlewares: .addTVDBToken(
        tokenProvider: { () -> TVDBToken? in
          manager.tokenStatus().token
        }
      )
    )

    self.refreshToken = .from(
      apiClient: try APIClient(
        client: refreshClient,
        baseURL: baseURL
      )
    )

    let tvdbClient = refreshClient.appending(
      middlewares: .refreshToken(
        apiKey: apiKey,
        tokenManager: manager,
        loginService: login,
        refreshService: refreshToken
      )
    )

    let apiClient = try APIClient(
      client: tvdbClient,
      baseURL: baseURL
    )

    episodes = .from(apiClient: apiClient)
  }
}

private extension HTTPMiddleware {
  static let tvdbHeaders = Self { request, responder -> HTTPCallPublisher in
    var request = request
    request.headers["Content-Type"] = "application/json"
    request.headers["Accept"] = "application/vnd.thetvdb.v\(apiVersion)"

    return responder.respondTo(request)
  }

  static func addTVDBToken(tokenProvider: @escaping () -> TVDBToken?) -> Self {
    .init { request, responder -> HTTPCallPublisher in
      guard let token = tokenProvider() else {
        return responder.respondTo(request)
      }

      var request = request
      return responder.respondTo(request.authorize(token: token))
    }
  }

  static func refreshToken(
    apiKey: String,
    tokenManager: TokenManager,
    loginService: LoginService,
    refreshService: RefreshTokenService
  ) -> Self {
    let refreshToken: () -> APICallPublisher<TVDBToken> = {
      refreshService.refresh().saveToken(tokenManager)
    }

    let login: () -> APICallPublisher<TVDBToken> = {
      loginService.login(.init(apikey: apiKey)).saveToken(tokenManager)
    }

    return .init { request, responder -> HTTPCallPublisher in
      let status = tokenManager.tokenStatus()

      switch status {
      case .valid:
        return responder.respondTo(request)
      case .refresh:
        return refreshToken()
          .flatMap { _ in responder.respondTo(request) }
          .eraseToAnyPublisher()
      case .invalid:
        return login()
          .flatMap { _ in responder.respondTo(request) }
          .eraseToAnyPublisher()
      }
    }
  }
}

private extension APICallPublisher where Output == TVDBToken, Failure == HTTPError {
  func saveToken(_ manager: TokenManager) -> APICallPublisher<TVDBToken> {
    self.handleEvents(
      receiveOutput: { token in
        manager.saveToken(token)
      }
    ).eraseToAnyPublisher()
  }
}

private extension HTTPRequest {
  mutating func authorize(token: TVDBToken) -> HTTPRequest {
    self.headers["Authorization"] = "Bearer " + token.token
    return self
  }
}
