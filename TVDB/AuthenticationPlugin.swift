import Moya
import Result

final class AuthenticationPlugin: PluginType {
  private weak var tvdb: TVDB?

  init(tvdb: TVDB) {
    self.tvdb = tvdb
  }

  func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
    guard let authenticationTarget = target as? Authentication, authenticationTarget == Authentication.login else {
      return request
    }

    return handleAuthenticationLoginRequest(authenticationTarget, request)
  }

  func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
    guard let authenticationTarget = target as? Authentication, authenticationTarget == Authentication.login else {
      return
    }

    handleAuthenticationLoginResult(result)
  }

  private func handleAuthenticationLoginRequest(_ target: Authentication, _ request: URLRequest) -> URLRequest {
    guard let tvdb = self.tvdb else { return request }

    var newRequest = request

    let json = ["apikey": tvdb.apiKey]
    let options = JSONSerialization.WritingOptions.init(rawValue: 0)
    guard let bodyData = try? JSONSerialization.data(withJSONObject: json, options: options) else {
      return request
    }

    newRequest.httpBody = bodyData

    return newRequest
  }

  private func handleAuthenticationLoginResult(_ result: Result<Response, MoyaError>) {
    guard let tvdb = self.tvdb else { return }

    guard let response = result.value else { return }

    guard let successfulResponse = (try? response.filterSuccessfulStatusAndRedirectCodes()) else { return }

    guard let json = try? successfulResponse.mapJSON() as? [String: Any] else { return }

    guard let token = json?["token"] as? String else { return }

    tvdb.token = token
  }  
}
