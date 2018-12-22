enum Fixtures: String {
  case WatchedShowEntity

  func jsonDataFor(file named: String) -> Data {
    let relativePath = "Fixtures/\(rawValue)/\(named)"

    guard let path = Bundle.testing.path(forResource: relativePath, ofType: "json") else {
      fatalError("Resource \(relativePath) not found")
    }

    return try! Data(contentsOf: URL(fileURLWithPath: path, isDirectory: false))
  }
}
