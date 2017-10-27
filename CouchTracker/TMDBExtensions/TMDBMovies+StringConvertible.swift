import Carlos
import TMDBSwift

extension Movies: StringConvertible {
  public func toString() -> String {
    switch self {
    case .images(let movieId):
      return "\(self.path)-\(movieId)"
    }
  }
}
