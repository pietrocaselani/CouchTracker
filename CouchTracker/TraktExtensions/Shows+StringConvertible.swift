import Trakt
import Carlos

extension Shows: StringConvertible {
  public func toString() -> String {
    return self.path
  }
}
