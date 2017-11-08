import Moya

final class NoCacheMoyaPlugin: PluginType {
  func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
    var newRequest = request

    newRequest.addValue("no-cache", forHTTPHeaderField: "Cache-Control")

    return newRequest
  }
}
