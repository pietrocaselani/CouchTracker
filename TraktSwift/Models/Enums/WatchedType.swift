public enum WatchedType: String, Equatable {
  case movies
  case shows

  public static func == (lhs: WatchedType, rhs: WatchedType) -> Bool {
    return lhs.rawValue == rhs.rawValue
  }
}
