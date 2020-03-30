import Moya

public enum Users {
  case settings
}

extension Users: TraktType {
  public var path: String {
    "users/settings"
  }

  public var task: Task {
    .requestPlain
  }

  public var authorizationType: AuthorizationType? {
    .bearer
  }

  public var sampleData: Data {
    stubbedResponse("trakt_users_settings")
  }
}
