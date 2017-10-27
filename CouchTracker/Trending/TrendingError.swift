enum TrendingError: Error {
  case noConnection(String)
  case parseError(String)

  var message: String {
    switch self {
    case .noConnection(let message), .parseError(let message):
      return message
    }
  }
}
