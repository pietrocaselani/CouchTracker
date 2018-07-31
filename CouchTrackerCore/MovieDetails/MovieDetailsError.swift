public enum MovieDetailsError: Error, Hashable {
  case noImageAvailable
  case noConnection(String)
  case parseError(String)

  public var message: String {
    switch self {
    case let .noConnection(message), let .parseError(message):
      return message
    default:
      return localizedDescription
    }
  }

  public static func == (lhs: MovieDetailsError, rhs: MovieDetailsError) -> Bool {
    return lhs.message == rhs.message
  }
}
