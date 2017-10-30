import Carlos
import TraktSwift

extension Genres: StringConvertible {
  public func toString() -> String {
    return self.path
  }
}
