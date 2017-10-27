import Moya

public enum ConfigurationService {
  case configuration
}

extension ConfigurationService: TMDBType {
  public var path: String {
    return "configuration"
  }

  public var parameters: [String: Any]? {
    return nil
  }

  public var sampleData: Data {
    return stubbedResponse("tmdb_configuration")
  }
}
