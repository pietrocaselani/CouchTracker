import Moya

public enum Users {
  case settings
}

extension Users: TraktType {
  public var path: String {
    return "users/settings"
  }

  public var parameters: [String : Any]? { return nil }

  public var sampleData: Data {
    return stubbedResponse("trakt_users_settings")
  }
}
