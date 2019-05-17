public final class UserIds: Codable, Hashable {
  public let slug: String

  public func hash(into hasher: inout Hasher) {
    hasher.combine(slug)
  }

  public static func == (lhs: UserIds, rhs: UserIds) -> Bool {
    return lhs.slug == rhs.slug
  }
}
