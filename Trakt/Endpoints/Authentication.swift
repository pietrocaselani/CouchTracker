import Moya

public enum Authentication {
  case accessToken(code: String, clientId: String, clientSecret: String, redirectURL: String, grantType: String)
}

extension Authentication: TraktType {
  public var path: String {
    return Trakt.OAuth2TokenPath
  }

  public var method: Method { return .post }

  public var parameters: [String : Any]? {
    switch self {
    case .accessToken(let code, let clientId, let clientSecret, let redirectURL, let grantType):
      return ["code": code,
              "client_id": clientId,
              "client_secret": clientSecret,
              "redirect_uri": redirectURL,
              "grant_type": grantType]
    }
  }

  public var parameterEncoding: ParameterEncoding {
    return JSONEncoding.default
  }
}
