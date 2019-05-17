import Moya

public enum ConfigurationService {
  case configuration
}

extension ConfigurationService: TMDBType {
  public var path: String {
    return "configuration"
  }

  public var task: Task {
    return .requestPlain
  }

  public var sampleData: Data {
    return stubbedResponse("tmdb_configuration")
  }
}
