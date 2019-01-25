enum Fixtures: String {
  case WatchedShowEntity
  case TMDBConfiguration

  func jsonDataFor(file named: String) -> Data {
    let relativePath = "Fixtures/\(rawValue)/\(named)"

    guard let path = Bundle.testing.path(forResource: relativePath, ofType: "json") else {
      fatalError("Resource \(relativePath) not found")
    }

    return try! Data(contentsOf: URL(fileURLWithPath: path, isDirectory: false))
  }

  func modelFor<T: Decodable>(file named: String, ofType type: T.Type, decoder: JSONDecoder = .init()) -> T {
    let data = jsonDataFor(file: named)
    return try! decoder.decode(type, from: data)
  }
}
