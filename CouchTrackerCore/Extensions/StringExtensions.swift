import Foundation

extension String {
  public var toURL: URL? {
    URL(string: self)
  }
}
