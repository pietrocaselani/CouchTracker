import Moya
import RxSwift
import Moya_ObjectMapper

public final class Trakt {
  let clientId: String
  let clientSecret, redirectURL: String?
  var plugins = [PluginType]()
  let userDefaults: UserDefaults
  public let oauthURL: URL?

  public private(set) var accessToken: Token? {
    didSet {
      updateAccessTokenPlugin(accessToken)
    }
  }

  public var hasValidToken: Bool {
    return accessToken?.expiresIn.compare(Date()) == .orderedDescending
  }

  public convenience init(clientId: String, userDefaults: UserDefaults = UserDefaults.standard) {
    self.init(clientId: clientId, clientSecret: nil, redirectURL: nil)
  }

  public init(clientId: String, clientSecret: String?,
              redirectURL: String?, userDefaults: UserDefaults = UserDefaults.standard) {
    self.clientId = clientId
    self.clientSecret = clientSecret
    self.redirectURL = redirectURL

    if let redirectURL = redirectURL {
      let url = Trakt.siteURL.appendingPathComponent(Trakt.OAuth2AuthorizationPath)
      var componenets = URLComponents(url: url, resolvingAgainstBaseURL: false)

      let responseTypeItem = URLQueryItem(name: "response_type", value: "code")
      let clientIdItem = URLQueryItem(name: "client_id", value: clientId)
      let redirectURIItem = URLQueryItem(name: "redirect_uri", value: redirectURL)
      componenets?.queryItems = [responseTypeItem, clientIdItem, redirectURIItem]

      self.oauthURL = componenets?.url
    } else {
      self.oauthURL = nil
    }

    self.userDefaults = userDefaults

    loadToken()
  }

  public func addPlugin(_ plugin: PluginType) {
    plugins.append(plugin)
  }

  public func finishesAuthentication(with request: URLRequest) -> Observable<AuthenticationResult> {
    guard let secret = clientSecret, let redirectURL = redirectURL else {
      let error = TraktError.cantAuthenticate(message: "Trying to authenticate without a secret or redirect URL")
      return Observable.error(error)
    }

    guard let url = request.url, let host = url.host, redirectURL.contains(host) else {
      return Observable.just(AuthenticationResult.undetermined)
    }

    let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
    guard let codeItemValue = components?.queryItems?.first(where: { $0.name == "code" })?.value else {
      return Observable.just(AuthenticationResult.undetermined)
    }

    let target = Authentication.accessToken(code: codeItemValue, clientId: clientId, clientSecret: secret,
                                            redirectURL: redirectURL, grantType: "authorization_code")

    return self.authentication.request(target)
      .filterSuccessfulStatusCodes()
      .flatMap { [unowned self] response -> Observable<AuthenticationResult> in
        do {
          self.accessToken = try response.mapObject(Token.self)
          return Observable.just(AuthenticationResult.authenticated)
        } catch {
          return Observable.error(error)
        }
    }
  }

  private func loadToken() {
    let tokenData = userDefaults.object(forKey: Trakt.accessTokenKey) as? Data
    if let tokenData = tokenData, let token = NSKeyedUnarchiver.unarchiveObject(with: tokenData) as? Token {
      self.accessToken = token
    }
  }

  private func saveToken(_ token: Token) {
    let tokenData = NSKeyedArchiver.archivedData(withRootObject: token)
    userDefaults.set(tokenData, forKey: Trakt.accessTokenKey)
  }

  private func updateAccessTokenPlugin(_ token: Token?) {
    if let index = self.plugins.index(where: { $0 is AccessTokenPlugin }) {
      plugins.remove(at: index)
    }

    if let token = token {
      plugins.append(AccessTokenPlugin(token: token.accessToken))
      saveToken(token)
    }
  }
}
