public final class Genre: Codable, Hashable {
  public let name: String
  public let slug: String

  public init(name: String, slug: String) {
    self.name = name
    self.slug = slug
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(name)
    hasher.combine(slug)
  }

  public static func == (lhs: Genre, rhs: Genre) -> Bool {
    lhs.hashValue == rhs.hashValue
  }
}
