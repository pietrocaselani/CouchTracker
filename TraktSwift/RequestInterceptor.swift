import Moya

public protocol RequestInterceptor {
  func intercept<T: TraktType>(target: T.Type, endpoint: Endpoint, done: @escaping MoyaProvider<T>.RequestResultClosure)
}
