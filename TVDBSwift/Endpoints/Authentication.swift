import Moya

public enum Authentication {
  case login(apiKey: String)
  case refreshToken
}

extension Authentication: TVDBType {
  public var path: String {
    switch self {
    case .login: return "login"
    case .refreshToken: return "refresh_token"
    }
  }

  public var authorizationType: AuthorizationType {
    switch self {
    case .login: return .none
    case .refreshToken: return .bearer
    }
  }

  public var method: Moya.Method {
    switch self {
    case .login: return .post
    case .refreshToken: return .get
    }
  }

  public var task: Task {
    switch self {
    case let .login(apiKey):
      return .requestParameters(parameters: ["apikey": apiKey], encoding: JSONEncoding.default)
    case .refreshToken:
      return .requestPlain
    }
  }

  public var sampleData: Data {
    switch self {
    case .login: return stubbedResponse("tvdb_login")
    case .refreshToken: return stubbedResponse("tvdb_refreshtoken")
    }
  }
}
