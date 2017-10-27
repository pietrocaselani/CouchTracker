import TMDBSwift

extension Shows: Hashable {
  public var hashValue: Int {
    return self.path.hashValue
  }

  public static func == (lhs: Shows, rhs: Shows) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
