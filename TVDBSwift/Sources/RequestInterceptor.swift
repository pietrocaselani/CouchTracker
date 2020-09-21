import Moya

public protocol RequestInterceptor {
  func intercept<T: TVDBType>(target: T.Type, endpoint: Endpoint, done: @escaping MoyaProvider<T>.RequestResultClosure)
}
