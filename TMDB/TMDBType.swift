import Moya

public protocol TMDBType: TargetType {}

public extension TMDBType {
  public var baseURL: URL { return TMDB.baseURL }

  public var method: Moya.Method { return .get }

  public var parameterEncoding: ParameterEncoding { return URLEncoding.default }

  public var task: Task { return .request }

  public var sampleData: Data { return "".utf8Encoded }
}

func stubbedResponse(_ filename: String) -> Data {
  let resourcesPath = Bundle(for: TMDB.self).bundlePath
  var bundle = Bundle(path: resourcesPath.appending("/../TMDB-Tests-Resources.bundle"))
  if bundle == nil {
    bundle = Bundle(path: resourcesPath.appending("/../../Debug/TMDB-Tests-Resources.bundle"))
  }

  let url = bundle!.url(forResource: filename, withExtension: "json")

  guard let fileURL = url, let data = try? Data(contentsOf: fileURL) else {
    return Data()
  }

  return data
}
