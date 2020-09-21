import Moya

public protocol TVDBType: TargetType, AccessTokenAuthorizable {}

public extension TVDBType {
  var baseURL: URL { TVDB.baseURL }

  var headers: [String: String]? { nil }

  var method: Moya.Method { .get }

  var authorizationType: AuthorizationType? { .bearer }

  var sampleData: Data { Data() }
}

func stubbedResponse(_ filename: String) -> Data {
  let bundle = Bundle.testable

  let url = bundle.url(forResource: filename, withExtension: "json")

  guard let fileURL = url, let data = try? Data(contentsOf: fileURL) else {
    return Data()
  }

  return data
}
