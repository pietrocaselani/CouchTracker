import Moya

public enum Authentication {
  case login
}

extension Authentication: TVDBType {
  public var path: String {
    return "login"
  }

  public var method: Method { return .post }

  public var parameters: [String : Any]? { return nil }

  public var sampleData: Data {
    return stubbedResponse("tvdb_login")
  }
}
