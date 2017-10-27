import Carlos
import Trakt

extension Movies: StringConvertible {
  public func toString() -> String {
    switch self {
    case .trending(let page, let limit, _):
      return "\(self.path)-\(page)-\(limit)"
    case .summary(let movieId, let extended):
      return "\(self.path)/\(movieId)-\(extended.rawValue)"
    }
  }
}
