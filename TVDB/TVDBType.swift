import Moya

public protocol TVDBType: TargetType {}

public extension TVDBType {
  public var baseURL: URL { return TVDB.baseURL }

  public var method: Method { return .get }

  public var parameterEncoding: ParameterEncoding { return URLEncoding.default }

  public var task: Task { return .request }

  public var sampleData: Data { return Data() }
}

func stubbedResponse(_ filename: String) -> Data {
  let resourcesPath = Bundle(for: TVDB.self).bundlePath
  var bundle = Bundle(path: resourcesPath.appending("/../TVDB-Tests-Resources.bundle"))
  if bundle == nil {
    bundle = Bundle(path: resourcesPath.appending("/../../Debug/TVDB-Tests-Resources.bundle"))
  }

  let url = bundle!.url(forResource: filename, withExtension: "json")

  guard let fileURL = url, let data = try? Data(contentsOf: fileURL) else {
    return Data()
  }

  return data
}
