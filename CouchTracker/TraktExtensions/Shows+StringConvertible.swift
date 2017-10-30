import TraktSwift
import Carlos

extension Shows: StringConvertible {
  public func toString() -> String {
    return self.path
  }
}
