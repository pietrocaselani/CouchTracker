import Moya

public enum Users {
  case settings
}

extension Users: TraktType {
  public var path: String {
    return "users/settings"
  }

  public var task: Task {
    return .requestPlain
  }

  public var authorizationType: AuthorizationType? {
    return .bearer
  }

  public var sampleData: Data {
    return stubbedResponse("trakt_users_settings")
  }
}
