public final class Configuration: Hashable, Codable {
  public let images: ImagesConfiguration

  public func hash(into hasher: inout Hasher) {
    hasher.combine(images)
  }

  public static func == (lhs: Configuration, rhs: Configuration) -> Bool {
    lhs.hashValue == rhs.hashValue
  }
}
