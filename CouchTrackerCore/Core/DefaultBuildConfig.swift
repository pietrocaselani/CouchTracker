public struct DefaultBuildConfig: BuildConfig {
  public let debug: Bool

  public init(debug: Bool) {
    self.debug = debug
  }
}
