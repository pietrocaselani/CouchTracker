import Moya

public protocol TMDBType: TargetType {}

public extension TMDBType {
  var baseURL: URL { return TMDB.baseURL }

  var method: Moya.Method { return .get }

  var headers: [String: String]? { return nil }

  var sampleData: Data { return Data() }
}

func stubbedResponse(_ filename: String) -> Data {
  let bundle = Bundle.testable

  let url = bundle.url(forResource: filename, withExtension: "json")

  guard let fileURL = url, let data = try? Data(contentsOf: fileURL) else {
    Swift.fatalError("JSON named \(filename) not found")
  }

  return data
}
