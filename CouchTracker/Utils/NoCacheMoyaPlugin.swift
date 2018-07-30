import Moya

final class NoCacheMoyaPlugin: PluginType {
    func prepare(_ request: URLRequest, target _: TargetType) -> URLRequest {
        var newRequest = request

        newRequest.setValue("no-cache", forHTTPHeaderField: "Cache-Control")

        return newRequest
    }
}
