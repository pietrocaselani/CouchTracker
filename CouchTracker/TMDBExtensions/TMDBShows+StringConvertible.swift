import Carlos
import TMDBSwift

extension Shows: StringConvertible {
  public func toString() -> String {
    return self.path
  }
}
