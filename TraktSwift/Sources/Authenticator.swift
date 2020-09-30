import HTTPClient
import Combine

// swiftlint:disable force_unwrapping
private let baseURL = URL(string: "https://\(apiHost)")!
private let siteURL = URL(string: "https://trakt.tv")!
// swiftlint:enable force_unwrapping

private let apiHost = "api.trakt.tv"

public enum AuthenticationResult: Equatable {
  case authenticated
  case undetermined
}

public struct Authenticator {
  public let oauthURL: URL

  private let authData: Trakt.AuthData
  private let clientID: String
  private let tokenManager: TokenManager
  private let accessToken: AccessTokenService
  let refreshToken: RefreshTokenService

  init(
    manager: TokenManager,
    client: HTTPClient,
    clientID: String,
    authData: Trakt.AuthData
  ) throws {
    guard let url = createOAuthURL(
      clientID: clientID,
      redirectURL: authData.redirectURL
    ) else {
      throw TraktError.failedToCreateOAuthURL
    }

    self.oauthURL = url
    self.clientID = clientID
    self.authData = authData
    self.tokenManager = manager

    self.accessToken = .from(apiClient: try .init(
      client: client,
      baseURL: baseURL
    ))

    refreshToken = .from(apiClient: try .init(
      client: client,
      baseURL: baseURL
    ))
  }

  public func finishAuthentication(request: URLRequest) -> AnyPublisher<AuthenticationResult, HTTPError> {
    guard let url = request.url, let host = url.host, authData.redirectURL.host?.contains(host) == true else {
      return Just(AuthenticationResult.undetermined)
        .setFailureType(to: HTTPError.self)
        .eraseToAnyPublisher()
    }

    let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
    guard let codeItemValue = components?.queryItems?.first(where: { $0.name == "code" })?.value else {
      return Just(AuthenticationResult.undetermined)
        .setFailureType(to: HTTPError.self)
        .eraseToAnyPublisher()
    }

    return accessToken.get(
      .init(
        code: codeItemValue,
        clientID: clientID,
        clientSecret: authData.clientSecret,
        redirectURL: authData.redirectURL.absoluteString,
        grantType: "authorization_code"
      )
    ).saveToken(tokenManager)
    .map { _ in AuthenticationResult.authenticated }
    .eraseToAnyPublisher()
  }
}

extension APICallPublisher where Output == Token, Failure == HTTPError {
  func saveToken(_ manager: TokenManager) -> APICallPublisher<Token> {
    self.handleEvents(
      receiveOutput: { token in
        _ = manager.saveToken(token)
      }
    ).eraseToAnyPublisher()
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

  components.path = "/oauth/authorize"
  components.queryItems = [
    .init(name: "response_type", value: "code"),
    .init(name: "client_id", value: clientID),
    .init(name: "redirect_uri", value: redirectURL.absoluteString)
  ]

  return components.url
}
