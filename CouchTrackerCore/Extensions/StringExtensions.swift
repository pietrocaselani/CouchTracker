import Foundation

extension String {
  public var toURL: URL? {
    return URL(string: self)
  }
}
