import Moya
import RxSwift

public class Trakt {
  let credentials: Credentials
  var oauthCode: String?
  private var lastTokenDate: Date?
  private var plugins: [PluginType]
  private let userDefaults: UserDefaults
  private let callbackQueue: DispatchQueue?
  private let dateProvider: DateProvider
  private var interceptors = [RequestInterceptor]()
  public let oauthURL: URL?

  public internal(set) var accessToken: Token? {
    didSet {
      guard let token = accessToken else { return }
      saveToken(token)
    }
  }

  public var hasValidToken: Bool {
    guard let tokenDate = lastTokenDate else { return false }
    return tokenDate.compare(dateProvider.now) == .orderedDescending
  }

  public lazy var movies: MoyaProvider<Movies> = createProvider(forTarget: Movies.self)
  public lazy var genres: MoyaProvider<Genres> = createProvider(forTarget: Genres.self)
  public lazy var search: MoyaProvider<Search> = createProvider(forTarget: Search.self)
  public lazy var shows: MoyaProvider<Shows> = createProvider(forTarget: Shows.self)
  public lazy var users: MoyaProvider<Users> = createProvider(forTarget: Users.self)
  public lazy var authentication: MoyaProvider<Authentication> = createProvider(forTarget: Authentication.self)
  public lazy var sync: MoyaProvider<Sync> = createProvider(forTarget: Sync.self)
  public lazy var episodes: MoyaProvider<Episodes> = createProvider(forTarget: Episodes.self)
  public lazy var seasons: MoyaProvider<Seasons> = createProvider(forTarget: Seasons.self)

  public init(builder: TraktBuilder) {
    guard let clientId = builder.clientId else {
      fatalError("Trakt needs a clientId")
    }

    credentials = Credentials(clientId: clientId,
                              clientSecret: builder.clientSecret,
                              redirectURL: builder.redirectURL)

    userDefaults = builder.userDefaults
    plugins = builder.plugins ?? [PluginType]()
    callbackQueue = builder.callbackQueue
    dateProvider = builder.dateProvider
    interceptors = builder.interceptors ?? [RequestInterceptor]()

    if let redirectURL = credentials.redirectURL {
      let url = Trakt.siteURL.appendingPathComponent(Trakt.OAuth2AuthorizationPath)
      var componenets = URLComponents(url: url, resolvingAgainstBaseURL: false)

      let responseTypeItem = URLQueryItem(name: "response_type", value: "code")
      let clientIdItem = URLQueryItem(name: "client_id", value: clientId)
      let redirectURIItem = URLQueryItem(name: "redirect_uri", value: redirectURL)
      componenets?.queryItems = [responseTypeItem, clientIdItem, redirectURIItem]

      oauthURL = componenets?.url
    } else {
      oauthURL = nil
    }

    loadToken()

    interceptors.append(TraktTokenInterceptor(trakt: self))

    plugins.append(AccessTokenPlugin { [weak self] () -> String in
      self?.accessToken?.accessToken ?? ""
    })
  }

  public final func finishesAuthentication(with request: URLRequest) -> Single<AuthenticationResult> {
    guard credentials.clientSecret != nil, let redirectURL = credentials.redirectURL else {
      let error = TraktError.cantAuthenticate(message: "Trying to authenticate without a secret or redirect URL")
      return Single.error(error)
    }

    guard let url = request.url, let host = url.host, redirectURL.contains(host) else {
      return Single.just(AuthenticationResult.undetermined)
    }

    let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
    guard let codeItemValue = components?.queryItems?.first(where: { $0.name == "code" })?.value else {
      return Single.just(AuthenticationResult.undetermined)
    }

    oauthCode = codeItemValue

    return Single.just(AuthenticationResult.authenticated)
  }

  func createProvider<T: TraktType>(forTarget target: T.Type) -> MoyaProvider<T> {
    let endpointClosure = createEndpointClosure(forTarget: target)
    let requestClosure = createRequestClosure(forTarget: target)

    return MoyaProvider<T>(endpointClosure: endpointClosure,
                           requestClosure: requestClosure,
                           callbackQueue: callbackQueue,
                           plugins: plugins)
  }

  private func loadToken() {
    guard let tokenData = userDefaults.object(forKey: Trakt.accessTokenKey) as? Data else { return }

    guard let tokenDate = userDefaults.object(forKey: Trakt.accessTokenDateKey) as? Date else { return }

    guard let token = NSKeyedUnarchiver.unarchiveObject(with: tokenData) as? Token else { return }

    accessToken = token
    lastTokenDate = tokenDate
  }

  private func saveToken(_ token: Token) {
    lastTokenDate = dateProvider.now.addingTimeInterval(token.expiresIn)
    let tokenData = NSKeyedArchiver.archivedData(withRootObject: token)
    userDefaults.set(tokenData, forKey: Trakt.accessTokenKey)
    userDefaults.set(lastTokenDate, forKey: Trakt.accessTokenDateKey)
    userDefaults.synchronize()
  }

  private func createEndpointClosure<T: TraktType>(forTarget _: T.Type) -> MoyaProvider<T>.EndpointClosure {
    let endpointClosure = { (target: T) -> Endpoint in
      let endpoint = MoyaProvider.defaultEndpointMapping(for: target)

      let traktHeaders = [Trakt.headerContentType: Trakt.contentTypeJSON,
                          Trakt.headerTraktAPIVersion: Trakt.apiVersion,
                          Trakt.headerTraktAPIKey: self.credentials.clientId]

      return endpoint.adding(newHTTPHeaderFields: traktHeaders)
    }

    return endpointClosure
  }

  private func createRequestClosure<T: TraktType>(forTarget target: T.Type) -> MoyaProvider<T>.RequestClosure {
    let requestClosure = { [unowned self] (endpoint: Endpoint, done: @escaping MoyaProvider.RequestResultClosure) in
      self.interceptors.forEach { $0.intercept(target: target, endpoint: endpoint, done: done) }
    }

    return requestClosure
  }
}
