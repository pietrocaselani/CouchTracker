import HTTPClient

// swiftlint:disable force_unwrapping
private let baseURL = URL(string: "https://\(apiHost)")!
private let bannersImageURL = URL(string: "https://www.thetvdb.com/banners/")!
private let smallBannersImageURL = URL(string: "https://www.thetvdb.com/banners/_cache/")!
// swiftlint:enable force_unwrapping

private let apiHost = "api.thetvdb.com"
private let apiVersion = "2.1.2"

private let headerAccept = "Accept"
private let acceptValue = "application/vnd.thetvdb.v\(apiVersion)"
private let headerContentType = "Content-Type"
private let contentTypeJSON = "application/json"

public final class TVDB {
  private let login: LoginService
  private let refreshToken: RefreshTokenService

  public let episodes: EpisodesService

  public init(
    apiKey: String,
    client: HTTPClient,
    manager: TokenManager
  ) throws {
    let headersMiddleware = TVDBHeadersMiddleware()

    let loginClient = client.appending(middlewares: headersMiddleware)

    self.login = .from(
      apiClient: try APIClient(
        client: loginClient,
        baseURL: baseURL
      )
    )

    let addTokenMiddleware = TVDBAddTokenMiddleware(
      tokenProvider: {
        manager.tokenStatus().token
      }
    )

    let refreshClient = loginClient.appending(middlewares: addTokenMiddleware)

    self.refreshToken = .from(
      apiClient: try APIClient(
        client: refreshClient,
        baseURL: baseURL
      )
    )

    let refreshTokenMiddleware = TVDBTokenRefresherMiddleware(
      apiKey: apiKey,
      tokenManager: manager,
      loginService: self.login,
      refreshService: self.refreshToken
    )

    let apiClient = try APIClient(
      client: refreshClient.appending(middlewares: refreshTokenMiddleware),
      baseURL: baseURL
    )

    episodes = .from(apiClient: apiClient)
  }
}

private struct TVDBHeadersMiddleware: HTTPMiddleware {
  private static let tvdbHeaders = [
    headerContentType: contentTypeJSON,
    headerAccept: acceptValue
  ]

  func respond(to request: HTTPRequest, andCallNext responder: HTTPResponding) -> HTTPCallPublisher {
    var request = request

    request.headers = request.headers.merging(Self.tvdbHeaders) { (lhs, rhs) -> String in
      rhs
    }

    return responder.respond(to: request)
  }
}

private struct TVDBAddTokenMiddleware: HTTPMiddleware {
  private let tokenProvider: () -> TVDBToken?

  init(tokenProvider: @escaping () -> TVDBToken?) {
    self.tokenProvider = tokenProvider
  }

  func respond(to request: HTTPRequest, andCallNext responder: HTTPResponding) -> HTTPCallPublisher {
    guard let token = tokenProvider() else {
      return responder.respond(to: request)
    }

    var request = request
    return responder.respond(to: request.authorize(token: token))
  }
}

private struct TVDBTokenRefresherMiddleware: HTTPMiddleware {
  private let apiKey: String
  private let tokenManager: TokenManager
  private let loginService: LoginService
  private let refreshService: RefreshTokenService

  init(
    apiKey: String,
    tokenManager: TokenManager,
    loginService: LoginService,
    refreshService: RefreshTokenService
  ) {
    self.apiKey = apiKey
    self.tokenManager = tokenManager
    self.loginService = loginService
    self.refreshService = refreshService
  }

  func respond(to request: HTTPRequest, andCallNext responder: HTTPResponding) -> HTTPCallPublisher {
    let status = tokenManager.tokenStatus()

    switch status {
    case .valid:
      return responder.respond(to: request)
    case .refresh:
      return refreshToken()
        .flatMap { _ in responder.respond(to: request) }
        .eraseToAnyPublisher()
    case .invalid:
      return login()
        .flatMap { _ in responder.respond(to: request) }
        .eraseToAnyPublisher()
    }
  }

  private func refreshToken() -> APICallPublisher<TVDBToken> {
    refreshService.refresh().saveToken(tokenManager)
  }

  private func login() -> APICallPublisher<TVDBToken> {
    loginService.login(.init(apikey: apiKey)).saveToken(tokenManager)
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
