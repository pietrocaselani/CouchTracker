import Carlos
import TMDBSwift

extension ConfigurationService: StringConvertible {
  public func toString() -> String {
    return self.path
  }
}
