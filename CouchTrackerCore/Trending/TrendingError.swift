enum TrendingError: Error {
  case noConnection(String)
  case parseError(String)

  var message: String {
    switch self {
    case let .noConnection(message), let .parseError(message):
      return message
    }
  }
}
