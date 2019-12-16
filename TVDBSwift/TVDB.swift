import Moya
import RxSwift

public class TVDB {
  let apiKey: String
  let dateProvider: DateProvider
  private let userDefaults: UserDefaults
  private let callbackQueue: DispatchQueue?
  private var interceptors: [RequestInterceptor]
  private var plugins: [PluginType]

  public internal(set) var token: String? {
    get {
      guard let tokenData = userDefaults.object(forKey: TVDB.accessTokenKey) as? Data else { return nil }
      guard let savedToken = NSKeyedUnarchiver.unarchiveObject(with: tokenData) as? String else { return nil }
      return savedToken
    }
    set {
      guard let newToken = newValue else { return }
      let tokenData = NSKeyedArchiver.archivedData(withRootObject: newToken)
      userDefaults.set(tokenData, forKey: TVDB.accessTokenKey)
      lastTokenDate = dateProvider.now
    }
  }

  internal private(set) var lastTokenDate: Date? {
    get {
      guard let tokenDate = userDefaults.object(forKey: TVDB.accessTokenDateKey) as? Date else { return nil }
      return tokenDate
    }
    set {
      guard let newTokenDate = newValue else { return }
      userDefaults.set(newTokenDate, forKey: TVDB.accessTokenDateKey)
    }
  }

  public var hasValidToken: Bool {
    guard let tokenDate = lastTokenDate else { return false }

    let diff = dateProvider.now.timeIntervalSince1970 - tokenDate.timeIntervalSince1970

    return diff < 82800
  }

  public lazy var authentication: MoyaProvider<Authentication> = createProvider(forTarget: Authentication.self)
  public lazy var episodes: MoyaProvider<Episodes> = createProvider(forTarget: Episodes.self)

  public init(builder: TVDBBuilder) {
    guard let apiKey = builder.apiKey else {
      fatalError("TVDB needs an apiKey")
    }

    guard let userDefaults = builder.userDefaults else {
      fatalError("TVDB needs an userDefaults")
    }

    self.apiKey = apiKey
    self.userDefaults = userDefaults
    callbackQueue = builder.callbackQueue
    plugins = builder.plugins ?? [PluginType]()
    dateProvider = builder.dateProvider
    interceptors = builder.interceptors

    interceptors.append(TVDBTokenRequestInterceptor(tvdb: self))

    plugins.append(AccessTokenPlugin(tokenClosure: { [token] _ -> String in
      token ?? ""
    }))
  }

  func createProvider<T: TVDBType>(forTarget target: T.Type) -> MoyaProvider<T> {
    let endpointClosure = createEndpointClosure(for: target)
    let requestClosure = createRequestClosure(for: target)

    return MoyaProvider<T>(endpointClosure: endpointClosure,
                           requestClosure: requestClosure,
                           callbackQueue: callbackQueue,
                           plugins: plugins)
  }

  private func createRequestClosure<T: TVDBType>(for target: T.Type) -> MoyaProvider<T>.RequestClosure {
    if target is Authentication.Type { return MoyaProvider<T>.defaultRequestMapping }

    let requestClosure = { [unowned self] (endpoint: Endpoint, done: @escaping MoyaProvider.RequestResultClosure) in
      self.interceptors.forEach {
        $0.intercept(target: target, endpoint: endpoint, done: done)
      }
    }

    return requestClosure
  }

  private func createEndpointClosure<T: TVDBType>(for target: T.Type) -> MoyaProvider<T>.EndpointClosure {
    let endpointClosure = { (target: T) -> Endpoint in
      let endpoint = MoyaProvider.defaultEndpointMapping(for: target)
      let headers = [TVDB.headerContentType: TVDB.contentTypeJSON, TVDB.headerAccept: TVDB.acceptValue]
      return endpoint.adding(newHTTPHeaderFields: headers)
    }

    return endpointClosure
  }
}
