import TMDBSwift

extension Configuration {
  static func mockDefaultConfiguration(decoder _: JSONDecoder = .init()) -> Configuration {
    return Fixtures.TMDBConfiguration.modelFor(file: "default_configuration", ofType: Configuration.self)
  }
}
