import Moya

public enum Authentication {
  case accessToken(code: String, clientId: String, clientSecret: String, redirectURL: String, grantType: String)
  case refreshToken(refreshToken: String, clientId: String,
    clientSecret: String, redirectURL: String, grantType: String)
}

extension Authentication: TraktType {
  public var path: String { Trakt.OAuth2TokenPath }

  public var method: Moya.Method { .post }

  public var task: Task {
    var parameters = [String: Any]()
    var codeParameter: String

    switch self {
    case let .accessToken(code, clientId, clientSecret, redirectURL, grantType),
         let .refreshToken(code, clientId, clientSecret, redirectURL, grantType):
      codeParameter = code
      parameters = ["client_id": clientId,
                    "client_secret": clientSecret,
                    "redirect_uri": redirectURL,
                    "grant_type": grantType]
    }

    let codeKey: String

    if case .accessToken = self {
      codeKey = "code"
    } else {
      codeKey = "refresh_token"
    }

    parameters[codeKey] = codeParameter

    return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
  }

  public var sampleData: Data {
    switch self {
    case .accessToken(let code, _, _, _, _), .refreshToken(let code, _, _, _, _):
      if code == "my_wrong_code" {
        return stubbedResponse("trakt_authentication_accesstoken_wrong")
      }
      return stubbedResponse("trakt_authentication_accesstoken")
    }
  }
}
