import Carlos
import Trakt

extension Genres: StringConvertible {
  public func toString() -> String {
    return self.path
  }
}
