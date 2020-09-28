import HTTPClient

// swiftlint:disable force_unwrapping
private let baseURL = URL(string: "https://\(apiHost)")!
private let siteURL = URL(string: "https://trakt.tv")!
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

  private let authenticator: TraktAuthenticator?

  public let authentication: AuthenticationService

  public init(
    credentials: Credentials,
    client: HTTPClient
  ) throws {
    if let authData = credentials.authData {
      guard let url = createOAuthURL(
        clientID: credentials.clientId,
        redirectURL: authData.redirectURL
      ) else {
        throw TraktError.failedToCreateOAuthURL
      }

      self.authenticator = .init(authData: authData, oauthURL: url)
    } else {
      self.authenticator = nil
    }

    let clientWithHeaders = client.appending(
      middlewares: .traktHeaders(clientID: credentials.clientId)
    )

    let apiClient = try APIClient(
      client: clientWithHeaders,
      baseURL: baseURL
    )

    self.authentication = .from(apiClient: apiClient)
  }
}

private func createOAuthURL(
  clientID: String,
  redirectURL: URL
) -> URL? {
  guard var components = URLComponents(
    url: siteURL,
    resolvingAgainstBaseURL: false
  ) else { return nil }

  components.path = "oauth/authorize"
  components.queryItems = [
    .init(name: "response_type", value: "code"),
    .init(name: "client_id", value: clientID),
    .init(name: "redirect_uri", value: redirectURL.absoluteString)
  ]

  return components.url
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

struct TraktAuthenticator {
  init(authData: Trakt.AuthData, oauthURL: URL) {
  }
}

private extension HTTPRequest {
  mutating func authorize(token: Token) -> HTTPRequest {
    self.headers["Authorization"] = "Bearer " + token.accessToken
    return self
  }
}
