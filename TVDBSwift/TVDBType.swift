import Moya

public protocol TVDBType: TargetType, AccessTokenAuthorizable {}

public extension TVDBType {
  var baseURL: URL { return TVDB.baseURL }

  var headers: [String: String]? { return nil }

  var method: Moya.Method { return .get }

  var authorizationType: AuthorizationType { return .bearer }

  var sampleData: Data { return Data() }
}

func stubbedResponse(_ filename: String) -> Data {
  let bundle = Bundle.testable

  let url = bundle.url(forResource: filename, withExtension: "json")

  guard let fileURL = url, let data = try? Data(contentsOf: fileURL) else {
    return Data()
  }

  return data
}
