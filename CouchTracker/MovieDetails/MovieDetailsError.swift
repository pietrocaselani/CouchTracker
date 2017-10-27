enum MovieDetailsError: Error, Equatable {

  case noConnection(String)
  case parseError(String)

  var message: String {
    switch self {
    case .noConnection(let message), .parseError(let message):
      return message
    }
  }

  static func == (lhs: MovieDetailsError, rhs: MovieDetailsError) -> Bool {
    return lhs.message == rhs.message
  }
}
