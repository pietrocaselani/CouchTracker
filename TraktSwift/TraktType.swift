import Moya

public protocol TraktType: TargetType, AccessTokenAuthorizable, Hashable {}

public extension TraktType {
  var baseURL: URL { Trakt.baseURL }

  var method: Moya.Method { .get }

  var headers: [String: String]? { nil }

  var task: Task { .requestPlain }

  var authorizationType: AuthorizationType? { nil }

  var sampleData: Data { Data() }

  func hash(into hasher: inout Hasher) {
    let typeName = String(reflecting: self)

    hasher.combine(typeName)
    hasher.combine(path)
    hasher.combine(method)
    hasher.combine(authorizationType?.value)
  }

  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.hashValue == rhs.hashValue
  }
}

func stubbedResponse(_ filename: String) -> Data {
  let bundle = Bundle.testable

  let url = bundle.url(forResource: filename, withExtension: "json")

  guard let fileURL = url, let data = try? Data(contentsOf: fileURL) else {
    Swift.fatalError("JSON named \(filename) not found")
  }

  return data
}
