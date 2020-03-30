import Moya

public enum ConfigurationService {
  case configuration
}

extension ConfigurationService: TMDBType {
  public var path: String {
    "configuration"
  }

  public var task: Task {
    .requestPlain
  }

  public var sampleData: Data {
    stubbedResponse("tmdb_configuration")
  }
}
