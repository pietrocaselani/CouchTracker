import Moya

public enum Episodes {
  case episode(id: Int)
}

extension Episodes: TVDBType {
  public var path: String {
    switch self {
    case .episode(let id): return "episodes/\(id)"
    }
  }

  public var parameters: [String : Any]? { return nil }

  public var sampleData: Data {
    return stubbedResponse("tvdb_episodes")
  }
}
