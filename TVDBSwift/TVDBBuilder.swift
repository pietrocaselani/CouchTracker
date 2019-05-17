import Moya

public final class TVDBBuilder {
  public var apiKey: String?
  public var userDefaults: UserDefaults?
  public var plugins: [PluginType]?
  public var callbackQueue: DispatchQueue?
  public var dateProvider: DateProvider
  public var interceptors = [RequestInterceptor]()

  public typealias BuilderClosure = (TVDBBuilder) -> Void

  public init(buildClosure: BuilderClosure) {
    dateProvider = DefaultDateProvider()
    userDefaults = .standard
    buildClosure(self)
  }
}
