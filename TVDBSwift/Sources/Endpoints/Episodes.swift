import Moya

public enum Episodes {
  case episode(id: Int)
}

extension Episodes: TVDBType {
  public var path: String {
    switch self {
    case let .episode(id): return "episodes/\(id)"
    }
  }

  public var task: Task {
    .requestPlain
  }

  public var sampleData: Data {
    stubbedResponse("tvdb_episodes")
  }
}
